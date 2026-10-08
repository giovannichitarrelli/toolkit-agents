# 📋 Prompts

Templates para colar numa sessão. `[PLACEHOLDER]` marca o que trocar.

## 🧰 Deste toolkit

| | Prompt | Quando |
|---|---|---|
| 🧼 | [Sanidade do projeto](01-sanidade-do-projeto.md) | Uma vez por repo: mapa verificado executando, não lendo doc |
| 🌊 | [Plano em ondas](02-plano-em-ondas.md) | Plano aprovado com 2+ tarefas → tabela de tarefas e ondas |
| 🔍 | [Review multiagente](03-review-multiagente.md) | Diff grande, antes de commit/deploy |
| 🌙 | [Montar o guarda noturna](04-montar-guarda.md) | Instalar o cron de gates num projeto |
| 🧪 | [Primeira prova de regressão](05-primeira-prova.md) | Logo depois de um PROVADO, para a prova virar suíte |
| 🧬 | [Extrair o design system](06-extrair-design-system.md) | Entrevista guiada: logo + referências → tokens + `DESIGN.md` |
| 🖥️ | [Tela a partir de referência](07-tela-a-partir-de-referencia.md) | Referência visual + tokens + shadcn/21st.dev → tela pronta |

Prompts de vídeo e imagem ficam dentro de cada nicho:
[🎬 vídeo](../docs/nichos/video.md#-prompt-para-começar) ·
[🖼️ imagem](../docs/nichos/imagem.md#-prompt-para-começar).

## 🎧 Do vibe-coding-toolkit (Matheus Gomes)

Copiados na íntegra de
[soumatheusgomes/vibe-coding-toolkit](https://github.com/soumatheusgomes/vibe-coding-toolkit)
(MIT — [licença](vibe-coding-toolkit/LICENSE-vibe-coding-toolkit)). Explicação
em português, bloco de prompt em inglês, como no original.

| | Prompt | Quando | Equivalente aqui |
|---|---|---|---|
| 🧼 | [Sanitização de projeto](vibe-coding-toolkit/01-project-sanitation.md) | Faxina geral medindo antes de agir | `01-sanidade-do-projeto` |
| 🔥 | [ESLint warning burndown](vibe-coding-toolkit/02-eslint-warning-burndown.md) | Zerar pilha de warnings sem refatoração silenciosa | — |
| 🔍 | [Code review multi-agente](vibe-coding-toolkit/03-multi-agent-code-review.md) | Revisores em paralelo + síntese com dedupe e ranking | `03-review-multiagente` |
| 💡 | [Brainstorm até plano](vibe-coding-toolkit/04-brainstorm-to-plan.md) | Pedido em aberto → plano com verificação por passo | agente `planejador` |
| 🌊 | [Parallel wave dispatch](vibe-coding-toolkit/05-parallel-wave-dispatch.md) | Lista de tarefas → ondas seguras | `02-plano-em-ondas` |
| 🧠 | [Memory bootstrap](vibe-coding-toolkit/06-memory-bootstrap.md) | Memória em duas camadas num projeto novo | — |
| ⚙️ | [Setup completo de ESLint](vibe-coding-toolkit/07-eslint-complete-setup.md) | `eslint.config.mjs` do zero, flat config | — |
| 🚦 | [Instalar os quality gates](vibe-coding-toolkit/08-eslint-quality-gates-install.md) | Teto de 350 linhas + medir violações | skill `quality-gates` |
| ✂️ | [Quebrar arquivos gigantes](vibe-coding-toolkit/09-file-size-refactor.md) | Dividir por responsabilidade, um arquivo por commit | — |

Onde há equivalente, os dois convivem: o daqui está acoplado ao time de agentes
(`verificador`, `ondas-paralelas`); o do Matheus é genérico e roda em qualquer
agente que leia uma URL.
