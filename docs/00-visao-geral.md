# 🔭 Visão geral

Cada peça daqui existe porque evitou um problema real pelo menos uma vez. Nada
foi adicionado porque parecia legal. Se você só for ler uma página, leia esta —
os documentos seguintes fazem sentido depois que você entende como as peças se
encaixam.

## 🎼 1. Orquestração, não implementação solo

A sessão principal tem um trabalho só: entender o problema, decidir, coordenar.
Ela não escreve código de produção com as próprias mãos.

Um tech lead experiente nunca senta sozinho para codificar um sistema inteiro.
Ele entende, desenha em linhas gerais, e distribui cada pedaço para quem tem
propriedade sobre o assunto — o banco vai para o especialista em dados, o trecho
sensível passa por segurança antes de ir pro ar. Ele nunca perde a visão do todo,
mas também nunca vira gargalo.

O ganho não é ter mais agentes. É que **cada despacho já chega com o checklist
certo**, em vez de um generalista reinventando um processo apressado sob pressão
de tempo, toda vez.

O contraponto importa: um agente para um domínio que o seu projeto não tem é
peso morto na tabela de roteamento. Nove agentes cobrindo o que existe valem
mais que cem cobrindo o que não existe.

## 🎚️ 2. Tier de modelo é decisão, nunca herança

Todo despacho declara em qual tier de modelo roda. Nenhum herda por acidente.

A regra é: **use a camada mais barata que ainda resolve.** Busca e leitura no
tier barato. Implementação, review e debug no intermediário. O tier caro fica
reservado para decisão de arquitetura de verdade — não para volume de trabalho.

Isso não é preciosismo. `Explore`, `general-purpose` e `fork` **herdam o modelo
do pai**: sem `model` explícito, sobem no mais caro que você tiver, para tarefas
que só leem arquivo. Num período medido, isso foi **20% do consumo total**.

## ✅ 3. Planejar, executar, revisar — e então **provar**

Código é a última etapa, não a primeira. Deixado por conta própria, um agente
interpreta o pedido do jeito mais óbvio e só descobre que construiu a coisa
errada quando o código já está todo escrito.

Mas a diferença que este toolkit faz está na etapa que a maioria dos fluxos não
tem: **prova de execução**.

"Implementado" não é "funciona". O que costuma derrubar um produto não é lógica
errada — é RLS bloqueando em silêncio, view sem `security_invoker`, grant por
coluna matando um `upsert`, PostgREST cortando a lista em 1000, ausência de dado
virando zero na tela, gate que só existe no cliente.

**Os seis passam por code review e ficam verdes em teste unitário.** Só caem
quando alguém executa como usuário real. É por isso que o `verificador` não lê
código: ele roda o sistema, com JWT de usuário — nunca com chave de serviço, que
fura RLS e faz todo teste passar.

Detalhe em [03 — Provas de execução](03-provas.md).

## 🧪 4. A prova não se joga fora

O verificador prova que o fluxo funciona **hoje**. Dois meses depois alguém altera
uma policy, quebra aquele fluxo, e ninguém roda aquela prova de novo — porque a
tarefa da vez é outra.

A skill `provas-de-regressao` grava o que acabou de ser executado em `provas/`, e
roda a suíte inteira **antes** de provar qualquer coisa nova. Prova antiga
falhando é regressão, e bloqueia o commit igual a NÃO PROVADO.

O ganho é que a suíte é feita do teste que **pega** a classe de bug certa —
banco real, JWT real, RLS de verdade. Uma suíte de mocks ficaria verde nos seis
casos acima.

## 🌊 5. Paralelismo com duas condições, não com otimismo

Despacho serial é seguro e lento. Despachar tudo de uma vez é rápido e quebra de
duas formas: dois agentes editam o mesmo arquivo e um sobrescreve o outro; dois
agentes disputam o `git commit`.

As duas causas somem **estruturalmente**, não por disciplina:

- Duas tarefas só entram na mesma onda se **nenhuma depende da outra** *e* os
  arquivos que tocam são **totalmente disjuntos**.
- **Implementador não commita.** Deixa a mudança na working tree e reporta.
  Quem commita é quem orquestra, serialmente, depois da onda inteira.

E antes de tudo isso: multiagente custa **3–10× mais token** que um agente
sozinho. Só se paga em três casos — proteção de contexto, paralelização real,
especialização genuína. Fora deles, onda é despesa sem retorno.

[04 — Ondas paralelas](04-ondas.md).

## 💸 6. Contexto é o custo

Cada tool call reenvia a conversa inteira. A 600k de contexto, um único tool call
custa cerca de **12×** o mesmo tool call a 50k.

Isso muda o que conta como otimização. Não é escrever menos mensagens — é não
carregar o que não vai ser usado: `/clear` na troca de assunto, não recarregar
arquivo já lido, `grep -n` em vez de dump de arquivo grande, e um proxy que
devolve versão enxuta de comando de leitura.

[05 — Custo](05-custo.md).

## 🚦 7. Gate aperta aos poucos, nunca de surpresa

Regra nova de lint jamais pula de "desligada" para "erro que trava a build".
Isso ou trava o trabalho da noite pro dia, ou é desligada na primeira sexta-feira
— e nenhuma das duas muda o código.

Regra nova entra como **aviso com a contagem anotada** como linha de base. O
número fica público. Quando chega a zero, vira erro e o gate fecha para sempre.

Regra que nasce com zero violação já nasce em erro. Não tem por que esperar.

[07 — Quality gates](07-quality-gates.md).

## 🌙 8. O worker que não gasta token

Um cron local roda de madrugada os gates que o projeto **já tem** e deixa um
relatório. Verde não imprime nada. Vermelho abre a primeira sessão do dia com o
aviso.

É bash puro, sem agente no meio: custo zero. O agente só entra quando você pede
o diagnóstico do que ficou vermelho.

[06 — Guarda noturna](06-guarda-noturna.md).

---

## 🚫 O que este toolkit deliberadamente não tem

- **Roster de 100+ agentes.** Número não é capacidade. Roteamento automático com
  89% de acerto significa 11% de despacho errado, e o custo de descobrir qual.
- **Swarm com consenso.** Cara em token, e o ganho não aparece num time de uma a
  cinco pessoas.
- **Grafo de conhecimento do código.** Um agente de busca no tier barato resolve
  a mesma pergunta sem infraestrutura para manter.
- **Métrica auto-reportada.** Se um número aparece aqui, ou ele foi medido nesta
  máquina ou está linkado à fonte.
