# 🧪 Provas de execução

A parte deste toolkit que não existe em outros lugares. Se você adotar uma coisa
só daqui, adote esta.

## 🧨 O problema

Code review lê código. Teste unitário roda código isolado, com dependência
falsa. Nenhum dos dois toca o sistema.

Estas seis falhas passam pelos dois, verdes:

| Falha | Por que passa |
|---|---|
| **RLS bloqueando em silêncio** | O banco devolve `[]` com HTTP 200. Não é erro — é lista vazia |
| **View sem `security_invoker`** | Roda com a permissão de quem criou, furando a RLS das tabelas de baixo |
| **Grant por coluna matando `upsert`** | `excluded.<col>` exige `SELECT` na coluna; o upsert inteiro falha quando o payload traz uma coluna fora da lista |
| **Teto de 1000 do PostgREST** | A lista volta truncada, sem aviso. O código soma o que veio e mostra um total errado |
| **Ausência virando zero** | `LEFT JOIN` sem `COALESCE`, agregação sobre conjunto vazio. A tela diz "R$ 0,00" onde deveria dizer "sem dado" |
| **Gate só no cliente** | A regra existe no app, não no servidor. Binário instalado ignora a tela |

Com mock, os seis ficam verdes. Só caem quando alguém executa como usuário real.

## 🥇 A regra de ouro

**Prove como um usuário, não como o dono do banco.**

A chave de serviço fura RLS, grant e policy. Verificar com ela faz **todo** teste
passar — e é assim que bug chega em produção.

- **Exercitar o fluxo:** sempre com JWT de um usuário real. Em chamada REST,
  quem manda é o header `Authorization: Bearer <jwt>`.
- **Chave de serviço só para dois usos:** arrumar o cenário antes, limpar depois.
  Nunca para provar que algo funciona.
- Se um passo **só** passa com a chave de serviço, isso **é o achado**: o gate
  não existe para o usuário real.

## 🪤 As seis armadilhas do teste verde

Antes de escrever "passou", confirme que não caiu em nenhuma:

1. **Chave de serviço mascarando** — passou porque o gate foi furado, não porque
   existe.
2. **Login mockado** — sessão injetada não prova nada. Prove que há sessão antes
   de asserir qualquer tela.
3. **Ausência de erro tratada como sucesso** — RLS bloqueia escrita em silêncio.
   Toda escrita se prova contando linha afetada ou relendo o efeito.
   `error == null` **não é prova**.
4. **Reler pela mesma sessão que escreveu** — pode ser cache ou optimistic
   update. Releia com sessão nova, ou com um segundo usuário quando o que importa
   é visibilidade.
5. **Só o caminho feliz** — teste também: sem permissão, sem dado, valor nulo,
   limite estourado, duplo clique.
6. **Provar contra arquivo em vez do sistema** — migration antiga e tipo gerado
   mentem. Contrato se confere no catálogo do banco, nunca num `.sql` do repo.

## 📋 A saída do verificador

```
VEREDITO: PROVADO | PARCIAL | NÃO PROVADO
REGRESSÃO: nenhuma | <provas que falharam>
PROVA GRAVADA: provas/<caminho>.sh | nenhuma (e por quê)
```

**Provado** — cada item com o comando e o output real que sustenta.
**Não provado** — entrada concreta → resultado errado → onde.
**Não deu para provar** — o quê, por quê, e o que destravaria. Nunca implícito.
**Sujeira deixada** — ids não limpos, ou "nada".

`PARCIAL`, `NÃO PROVADO` e qualquer regressão **bloqueiam o commit**. Na dúvida
entre PROVADO e PARCIAL, é PARCIAL.

---

# 🔁 A prova vira suíte

Provar e jogar a prova fora resolve hoje e não protege amanhã. A skill
`provas-de-regressao` fecha esse buraco.

## 📁 Onde fica

`provas/`, na raiz do repositório que **é dono do que a prova exercita** —
normalmente onde vivem migrations e funções de servidor.

**Nunca** em `test/`, `tests/` ou `__tests__`. Os runners descobrem esses
diretórios sozinhos, e estas provas precisam de credencial real e podem escrever
em produção. Não podem rodar por acidente num `npm test` nem em CI.

```
provas/
  leitura/<area>-<fluxo>.sh   só lê · sempre seguro repetir
  escrita/<area>-<fluxo>.sh   cria e apaga · teardown obrigatório · só com --escrita
  lib.sh  rodar.sh  .env      .env NUNCA commitado
```

## 🔢 O contrato de exit code

| Código | Significa |
|---|---|
| `0` | passou |
| `1` | **falhou** — é regressão, bloqueia o commit |
| `2` | não deu para provar (falta credencial) — não é falso vermelho |

O `2` importa: sem ele, falta de env vira vermelho e o time aprende a ignorar.

## ♻️ O ciclo

**Antes** de provar a tarefa nova: `./provas/rodar.sh`. Sempre. Prova antiga
falhando é achado separado do resultado da tarefa.

**Depois** do veredito PROVADO: grave a prova em `provas/`. Uma prova por fluxo —
fluxo que já tem prova, atualize a existente, nunca crie `-v2`. Só o que prova
comportamento; listar tabela e ler log é diagnóstico, não prova.

Prova que não roda mais porque o fluxo sumiu: **reporte, não apague**. Prova
apagada em silêncio é cobertura perdida sem ninguém saber.

## 🧾 O que toda prova cobre

As mesmas quatro coisas que o plano exige como critério de pronto:

- **a escrita gravou** — contando linha afetada ou relendo o efeito
- **quem não pode** — o mesmo passo com outro usuário e anônimo, esperando 0
- **o caso sem dado** — o que o sistema devolve quando não existe nada
- **o contrato** — a RPC ou coluna chamada existe com a assinatura chamada

## ✏️ Prova de escrita

Vai para `escrita/`, e:

- todo conteúdo visível começa com um marcador (`[QA]`), usuário efêmero com
  carimbo no e-mail
- `registrar_teardown` **na primeira linha** depois do cabeçalho, antes de criar
  qualquer coisa — e ele roda **mesmo se a prova falhar**
- nunca `UPDATE`/`DELETE` em linha que a prova não criou
- teardown falhou → imprime os ids órfãos em destaque, nunca esconde

Nunca vira prova, em hipótese nenhuma: cobrança real, saque ou transferência,
envio de e-mail ou push para público que não seja o usuário efêmero.

## 🔑 Credencial

Sempre de env, nunca no arquivo. Antes de gravar, confirme que `provas/.env` está
no `.gitignore`. O script vai para o git; o segredo não.

## 🤔 Por que isto e não TDD

TDD deixa uma suíte que roda de novo, barata, a cada mudança — é a resposta certa
para *manter* um bug corrigido. Mas a suíte que o TDD produz é de teste isolado
com dependência falsa, e é exatamente onde os seis casos lá de cima ficam verdes.

Os dois eixos não competem: **o verificador pega o bug na primeira vez, a suíte
de provas impede que ele volte** — usando o mesmo teste que pegou.
