# 🧪 Testes e navegador

O `verificador` precisa **executar** o fluxo web. Três ferramentas, três
papéis — não são intercambiáveis.

| | Ferramenta | Tipo | Para quê | Status |
|---|---|---|---|---|
| 🌐 | Claude in Chrome | extensão | Navega no **seu** Chrome, com os seus logins | ✅ |
| 🎭 | `webapp-testing` ([anthropics/skills](https://github.com/anthropics/skills)) | skill | Playwright em app local: script, screenshot, log | ✅ |
| 🤖 | [agent-browser](https://github.com/vercel-labs/agent-browser) | CLI | Headless por árvore de acessibilidade, aguenta re-render | 🟡 |
| 🔧 | [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) | plugin MCP | Performance, rede, console ao vivo | 🟢 |

## 🧭 Qual usar

- Fluxo que depende de login real seu → **Claude in Chrome**.
- Prova re-rodável em `provas/` → **webapp-testing** ou **agent-browser** —
  nada que dependa de um navegador aberto na sua máquina.
- "Está lento" / "a requisição falha" → **Chrome DevTools MCP**.

## 📦 Instalação

```bash
npm i -g agent-browser && agent-browser install
```

```
/plugin marketplace add ChromeDevTools/chrome-devtools-mcp
/plugin install chrome-devtools-mcp@chrome-devtools-plugins
```
