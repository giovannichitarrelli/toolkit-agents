# 🗺️ O fluxo

Toda feature nova ou tarefa não-trivial:

| # | Passo | Quem |
|---|---|---|
| 1 | Planejar — tabela de tarefas (`Files:`, `Depends-on:`, especialista) e tabela de ondas | `planejador` |
| 2 | Mostrar o plano, aguardar OK | você |
| 3 | Tocou banco? Desenhar schema/RLS/migration **antes** do código que consome | `arquiteto-dados` |
| 4 | Implementar a partir do plano aprovado | `executor` |
| 5 | Revisar. Tocou auth/webhook/env/pagamento/RLS → segurança em paralelo. Tratamento de erro/fallback → caçador de falha silenciosa | `revisor-codigo` + `revisor-seguranca` + `silent-failure-hunter` |
| 6 | **Provar** — executar o fluxo real e voltar com evidência | `verificador` |
| 7 | Só com PROVADO e sem regressão a tarefa fecha e o commit é proposto | você |

Bug isolado → `systematic-debugging` direto, e ainda assim passa pelo passo 6.
Ajuste trivial → executa direto.

## 🗄️ Por que o passo 3 vem antes do 4

Desenho de banco depois do código que o consome é retrabalho garantido. O
`arquiteto-dados` devolve o SQL e o teste de RLS **como proposta** — quem aplica
é o executor, a partir do plano aprovado. Ele projeta e reporta; não altera
produção.

## ⚠️ Por que o passo 6 não é opcional

Está em [03 — Provas de execução](03-provas.md), e é a razão de este toolkit
existir. Resumo: os bugs que derrubam produto passam por code review e ficam
verdes em teste unitário.

## 🌊 Quando o passo 4 vira ondas

Plano com 2+ tarefas independentes → skill `ondas-paralelas`. As regras e o
custo de multiagente estão em [04 — Ondas paralelas](04-ondas.md).

O passo 6 roda **uma vez, no fim de todas as ondas** — nunca por onda. Prova por
onda mede pedaço, e o que quebra costuma ser a junção.

## 📬 O que cada agente entrega

**`planejador`** — plano com veredito de desafio no topo (é a abordagem mais
escalável? existe alternativa 10× melhor?), tabela de tarefas e critério de
pronto **escrito como prova executável**. Se você não consegue escrever a prova,
o passo ainda não está planejado.

**`executor`** — o que mudou, o rastro de prova (que escritas faz, que contratos
mudou, quem não pode acessar, o que a tela mostra sem dado, como subir o fluxo) e
o que ficou pendente. Ele **não** declara a tarefa concluída.

**`revisor-codigo`** — só o que está errado, com âncora `arquivo:linha` ou output
real. Achado sem âncora não entra no relatório; vira "suspeita" com o que falta
para provar.

**`verificador`** — veredito, regressão, prova gravada, sujeira deixada.
