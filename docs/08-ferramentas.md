# 🛠️ Ferramentas — o que entra e o que fica de fora

As 14 ferramentas do
[vibe-coding-toolkit](https://github.com/soumatheusgomes/vibe-coding-toolkit/tree/main/docs/tools)
comparadas com o setup deste toolkit. O critério é o mesmo dos agentes: só entra
o que resolve um problema que você **tem**. Ferramenta redundante custa contexto
em toda sessão, até quando não é usada.

**Legenda:** ✅ já está no setup · 🟢 recomendo instalar · 🟡 testar num projeto antes · ⚪ pular

## 📊 A tabela

| | Ferramenta | Status | Por quê |
|---|---|---|---|
| ⭐ | [Superpowers](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/01-superpowers.md) | ✅ | Pré-requisito. Brainstorm → plano → execução → review |
| 🌊 | [Orquestração de subagentes](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/02-subagent-orchestration.md) | ✅ | É a skill `ondas-paralelas` + o time de agentes |
| 🪙 | [RTK](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/03-rtk-token-proxy.md) | ✅ | [`templates/RTK.md`](../templates/RTK.md), com as armadilhas de contagem |
| 🧠 | [Memória do Claude](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/09-claude-memory-system.md) | ✅ | Memória automática do Claude Code + plugin `claude-mem` |
| 📚 | [Context7](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/12-context7.md) | ✅ | Obrigatório para Next 16, React 19, Tailwind v4, Flutter |
| 🧩 | [Anthropic Skills](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/13-anthropics-skills.md) | ✅ | `frontend-design`, `webapp-testing`, `skill-creator`, `mcp-builder`, docx/pdf/pptx/xlsx |
| 🚦 | [Quality gates ESLint/Biome](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/06-eslint-biome-quality-gates.md) | ✅ | Skill `quality-gates`. A divisão ESLint + Biome fica de fora até um projeto pedir velocidade de lint |
| 🪝 | [Hooks — boas práticas](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/10-hooks-best-practices.md) | 🟢 | Leitura obrigatória antes de escrever hook novo. O `hook-io` com falha segura evita o hook que trava a sessão inteira |
| 🕸️ | [Graphify](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/07-graphify.md) | 🟢 | Grafo do repositório: "o que quebra se eu mudar isso" numa consulta. Paga-se em repo grande ou multi-repo — onde o `busca` hoje roda dezenas de grep |
| 🔧 | [Chrome DevTools MCP](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/14-chrome-devtools-mcp.md) | 🟢 | Performance, rede e console ao vivo. Complementa o Claude in Chrome, que navega mas não perfila |
| 🤖 | [agent-browser](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/11-agent-browser.md) | 🟡 | Navegador headless por árvore de acessibilidade. Bom para o `verificador` provar fluxo web sem depender do seu Chrome aberto |
| 🦥 | [Ponytail](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/04-ponytail.md) | 🟡 | Escada "a solução mais simples que resolve". Combina com o `executor`, que tende a construir a mais |
| 🗣️ | [Caveman](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/05-caveman.md) | ⚪ | Redundante com o `cost-reducer` do `CLAUDE.md`. Duas regras de estilo brigando é pior que nenhuma |
| 🗂️ | [Obsidian como memória](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/08-obsidian-memory.md) | ⚪ | Terceira camada de memória sobre `MEMORY.md` + `claude-mem`. Só se você já vive no Obsidian |
| 🏗️ | aia-harness (`/aia-harness:init`) | ⚪ | Monta agentes, regras e hooks automaticamente — exatamente o que este toolkit faz à mão, com prova de execução |

## 📦 Instalar os recomendados

```bash
# 🕸️ Graphify — pacote Python, não é plugin
uv tool install graphifyy && graphify claude install

# 🤖 agent-browser — CLI npm
npm i -g agent-browser && agent-browser install
```

Dentro de uma sessão `claude`:

```
/plugin marketplace add ChromeDevTools/chrome-devtools-mcp
/plugin install chrome-devtools-mcp@chrome-devtools-plugins

/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```

## 🧭 Como testar uma ferramenta 🟡

1. Instale no **escopo do projeto**, não no global — config de um projeto em
   escopo global vale para todos (ver o aviso em `~/Projetos/CLAUDE.md`).
2. Use por uma semana em trabalho real.
3. Pergunta única: ela evitou um erro ou poupou uma volta que você consegue
   apontar? Se não, desinstale. Ferramenta que "parece útil" é custo fixo.

Para as ferramentas organizadas por área (vídeo, imagem, código, design…), veja
[`nichos/`](nichos/README.md).
