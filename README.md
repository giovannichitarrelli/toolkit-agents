# Toolkit de agentes

Um time de agentes especialistas para o Claude Code, com uma regra que quase
nenhum fluxo de IA tem: **nada fecha sem alguém executar o sistema de verdade.**

Não é uma lista de plugins. São nove agentes, três skills e um punhado de
templates que existem porque cada um resolveu um jeito específico de as coisas
darem errado — a maioria deles invisível para code review e verde em teste
unitário.

```bash
git clone https://github.com/giovannichitarrelli/toolkit-agentes
cd toolkit-agentes
./instalar.sh                 # prévia: mostra o que faria
./instalar.sh --aplicar       # copia agentes e skills para ~/.claude
```

Depois adapte os três arquivos de `templates/` à mão e reinicie a sessão.
Passo a passo em [`docs/01-instalacao.md`](docs/01-instalacao.md).

---

## A ideia em um parágrafo

A sessão principal **orquestra**: entende o problema, decide, delega. Ela não
implementa. O trabalho vai para especialistas de escopo estreito, cada um com um
gatilho claro de "quando usar" e um **tier de modelo declarado** — porque busca
em arquivo não precisa do modelo mais caro, e decisão de arquitetura precisa.
No fim, um agente que **não lê código** executa o fluxo real e volta com
evidência. Sem essa evidência, a tarefa não fecha.

## O que este toolkit tem de diferente

Existem coleções maiores. Esta tem três coisas que a maioria não tem:

**1. Prova de execução, não de leitura.** O `verificador` roda o sistema com JWT
de usuário real — nunca com chave de serviço, que fura RLS e faz todo teste
passar. "Parece certo" e "o código está correto" são saídas proibidas. Se não
rodou, o veredito é NÃO PROVADO, e isso bloqueia o commit.

**2. A prova vira suíte.** A skill `provas-de-regressao` grava o que o
verificador acabou de executar em `provas/`, e roda a suíte inteira antes de
provar qualquer coisa nova. Prova de momento vira cobertura de regressão — usando
exatamente o teste que pega a classe de bug que mock não pega.

**3. Custo tratado como restrição de projeto.** Tier de modelo declarado por
agente. Subagente de busca no tier barato — sem isso ele herda o modelo do pai e
some com o orçamento lendo arquivo. Multiagente só nos três casos em que se paga.

## O time

| Agente | Tier | Quando |
|---|---|---|
| `planejador` | médio | Planeja antes de qualquer código. Entrega tabela de tarefas e de ondas |
| `executor` | **alto** | Implementa a partir de plano aprovado. O único no tier alto |
| `arquiteto-dados` | médio | Schema, migration, RLS, índice, view, RPC, grant — **antes** do executor |
| `revisor-codigo` | médio | Bug, furo de fluxo, drift de contrato, hardcode |
| `revisor-seguranca` | médio | Auditoria antes de publicar |
| `verificador` | médio | **Executa** o fluxo e volta com prova. Fecha a tarefa |
| `socio-produto` | médio | Pressiona a ideia antes de virar código |
| `seo-geo` | médio | SEO e otimização para assistentes de IA |
| `busca` | **barato** | Localiza código. Substitui `Explore` e `general-purpose` |

Adapte o elenco aos **seus** domínios. Agente para domínio que você não tem é
peso morto na tabela de roteamento — nove cobrindo o que existe vale mais que
cem cobrindo o que não existe.

## As skills

| Skill | O que faz |
|---|---|
| `ondas-paralelas` | Executa um plano em ondas: marcação `Files:`/`Depends-on:`, arquivos disjuntos, e a regra de que **implementador nunca commita** |
| `provas-de-regressao` | Persiste a prova do verificador como script re-rodável e pega regressão antes de provar coisa nova |
| `quality-gates` | Instala gates de lint com severidade decidida pela contagem real de violações, não pela preferência |

## O guarda noturna

Um cron local que roda **os gates que o seu projeto já tem** e deixa um
relatório. Bash puro: zero token. Verde não imprime nada; vermelho abre a
primeira sessão do dia com o aviso.

Na primeira execução real, num projeto de três repositórios, ele apontou cinco
vermelhos em 121 segundos. Dois eram configuração errada do próprio guarda —
que é exatamente o que uma primeira execução serve para descobrir.

[`templates/guarda-noturna/`](templates/guarda-noturna/) ·
[`docs/06-guarda-noturna.md`](docs/06-guarda-noturna.md)

## Documentação

| | |
|---|---|
| [00 — Visão geral](docs/00-visao-geral.md) | Por que cada peça existe, e o que cada uma evitou |
| [01 — Instalação](docs/01-instalacao.md) | Do zero ao fluxo rodando |
| [02 — O fluxo](docs/02-fluxo.md) | Os sete passos, e por que o sexto não é opcional |
| [03 — Provas de execução](docs/03-provas.md) | O verificador e a suíte de regressão |
| [04 — Ondas paralelas](docs/04-ondas.md) | Quando paralelizar é seguro, e quando é despesa |
| [05 — Custo](docs/05-custo.md) | Tier por agente, contexto como custo, proxy de tokens |
| [06 — Guarda noturna](docs/06-guarda-noturna.md) | O worker que não gasta token |
| [07 — Quality gates](docs/07-quality-gates.md) | Regra nova entra como aviso, nunca como erro |

Prompts prontos para colar em [`prompts/`](prompts/).

## Requisitos

- [Claude Code](https://docs.claude.com/en/docs/claude-code)
- Plugin `superpowers` — `/plugin install superpowers@claude-plugins-official`
- Plugin `context7` — documentação atual de lib, contra API alucinada
- Opcional: um proxy de tokens ([`templates/RTK.md`](templates/RTK.md))

## Créditos

A estrutura de documentação e as ideias de orquestração em ondas e de quality
gates como migração rastreada vêm do
[vibe-coding-toolkit](https://github.com/soumatheusgomes/vibe-coding-toolkit),
de Matheus Gomes, sob licença MIT. Os agentes, as skills, o guarda noturna e o
modelo de prova de execução são deste repositório.

Leitura de origem que vale ir buscar:
[Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)
e
[Multi-Agent Systems: When to Use Them](https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them),
da Anthropic — o custo de 3–10× que a regra de ondas cita sai do segundo.

## Licença

MIT — veja [LICENSE](LICENSE).
