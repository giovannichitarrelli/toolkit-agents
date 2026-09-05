---
name: provas-de-regressao
description: Persiste a prova que o verificador acabou de executar como script re-rodável em provas/, e roda a suíte existente antes de provar coisa nova para pegar regressão. Use dentro do verificador — no início (rodar a suíte) e no fim (gravar a prova nova). Use também quando quem pediu pedir para rodar as provas, ver o que já está provado, ou montar a pasta provas/ num subprojeto.
---

# Provas de regressão

O `verificador` prova que o fluxo funciona **hoje** e joga a prova fora. Dois meses depois alguém altera uma policy e quebra aquele fluxo — e ninguém roda aquela prova de novo, porque a tarefa da vez é outra.

Esta skill converte a prova de momento em suíte: mesma prova, mesmo JWT de usuário, mesmo banco real — só que gravada e re-rodável.

**Não é teste unitário.** Teste com mock fica verde nos seis bugs que derrubaram esta plataforma. O valor está em ser exatamente a prova que já pega essa classe.

## Onde fica

`provas/` na raiz do subprojeto. **Nunca** em `test/`, `tests/` ou `__tests__` — `flutter test`, vitest e `deno test` descobrem esses diretórios sozinhos, e estas provas precisam de credencial real e escrevem em produção. Não podem rodar por acidente num `pnpm test` nem em CI.

```
provas/
  README.md         leitura/<area>-<fluxo>.sh     só lê; sempre seguro repetir
  rodar.sh          escrita/<area>-<fluxo>.sh     cria e apaga; teardown obrigatório
  lib.sh            .env                          NUNCA commitado
  env.example
```

## Montar num subprojeto que ainda não tem

Copie `modelo/` (ao lado deste SKILL.md) para `provas/` — `lib.sh`, `rodar.sh`, `README.md`, `env.example` — **byte a byte**. Não reescreva `lib.sh` nem `rodar.sh`: asserção escrita na hora erra em silêncio, e o modo de falha é uma prova que fica verde sem provar nada.

Depois: `chmod +x provas/rodar.sh`, e acrescente `provas/.env` ao `.gitignore` do subprojeto. Confirme que entrou — prova com JWT commitado é vazamento de credencial.

## Passo 1 (início da verificação) — rodar a suíte antes de provar coisa nova

```bash
./provas/rodar.sh
```

Sempre. Antes de qualquer coisa da tarefa nova.

- Tudo passou → siga para a verificação normal.
- Alguma falhou → **isso é REGRESSÃO**, e é achado separado do resultado da tarefa. Reporte em seção própria, com o nome da prova e o output. **Regressão bloqueia o commit** igual a `NÃO PROVADO`, mesmo que a tarefa nova esteja perfeita.
- `--escrita` só quando o diff toca um fluxo que tem prova de escrita. Elas escrevem em produção.

Prova que não roda mais porque o fluxo deixou de existir: **reporte, não apague.** Remover prova é decisão de quem pediu — prova apagada em silêncio é cobertura perdida sem ninguém saber.

## Passo 2 (fim da verificação) — gravar a prova nova

Depois do veredito **PROVADO**, e só então: transforme as consultas e chamadas que você acabou de rodar em um arquivo em `provas/`.

Grave só o que **prova comportamento**, não o que inspeciona ambiente. `list_tables`, `get_advisors` e leitura de log são diagnóstico, não prova — ficam de fora.

Uma prova por fluxo, não por tarefa. Se o fluxo já tem prova, **atualize a existente** em vez de criar `-v2`.

### Cabeçalho obrigatório

```bash
#!/usr/bin/env bash
# FLUXO:    organizador edita endereço do próprio evento
# TIPO:     leitura
# CRIADA:   2026-09-05 · tarefa: edição de endereço no painel
# PROVA:    dono edita e a mudança aparece; outro organizador não consegue
# USUÁRIO:  PROVA_JWT_ORGANIZADOR (dono), PROVA_JWT_OUTRO_ORGANIZADOR
# ESPERADO: dono → 1 linha; outro → 0 linhas; anon → 0 linhas
# TEARDOWN: n/a
. "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"
```

Sem esse cabeçalho a prova é ilegível daqui a três meses e ninguém confia nela.

### O que toda prova precisa cobrir

As mesmas coisas que o plano exige como critério de pronto:

- **a escrita gravou** — contando linha afetada ou relendo o efeito. `error == null` não é prova
- **quem não pode** — o mesmo passo com outro usuário e com `anon`, esperando 0
- **o caso sem dado** — o que o sistema devolve quando não existe nada
- **o contrato** — a RPC/coluna chamada existe com a assinatura chamada

### Helpers (de `lib.sh` — não reinvente)

| Chamada | Para quê |
|---|---|
| `prova_requer_env VAR...` | falta env → sai com 2 ("não deu para provar"), não com falha |
| `rest_como "$JWT" GET "tabela?select=*"` | PostgREST com JWT de usuário real |
| `rest_anon GET "tabela?select=*"` | como o mundo vê |
| `setup_sql "..."` | **só** montar cenário e limpar. Nunca para provar |
| `conferir "desc" esperado obtido` | asserção de igualdade |
| `conferir_diferente "desc" nao_esperado obtido` | asserção de diferença |
| `conferir_linhas "desc" min "$json"` | conta linhas de uma resposta PostgREST |
| `registrar_teardown 'comando'` | roda no fim **mesmo se a prova falhar** |
| `encerrar` | fecha e devolve o exit code certo |

### Prova de escrita

Vai para `escrita/`, e:

- todo conteúdo textual visível começa com `[QA]`; usuário efêmero em `qa-<carimbo>@<dominio-de-teste>`
- `registrar_teardown` **na primeira linha depois do cabeçalho**, antes de criar qualquer coisa
- nunca `UPDATE`/`DELETE` em linha que a prova não criou
- teardown falhou → a prova imprime os ids órfãos em destaque, nunca esconde

Nunca vira prova, em hipótese nenhuma: cobrança real, saque/repasse/Pix, envio de push ou e-mail para público que não seja o usuário efêmero.

### Credencial

Sempre de env, nunca no arquivo. Antes de gravar, confirme que `provas/.env` está no `.gitignore`. JWT commitado é vazamento — o arquivo vai para o git, o segredo não.

## Passo 3 — reportar

O veredito do `verificador` ganha duas linhas:

```
REGRESSÃO: nenhuma | <provas que falharam>
PROVA GRAVADA: provas/leitura/<arquivo>.sh | nenhuma (e por quê)
```

"Não gravei porque o fluxo não é re-rodável" é resposta aceitável — desde que dita. Silêncio não é.
