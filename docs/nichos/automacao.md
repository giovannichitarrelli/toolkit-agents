# ⚡ Automação

| | Peça | Tipo | Para quê | Status |
|---|---|---|---|---|
| 🔗 | [n8n-skills](https://github.com/czlonkowski/n8n-skills) | 7 skills | Padrões de workflow, expressões, Code node JS/Python, validação | ✅ |
| 🌙 | Guarda noturna | template (daqui) | Cron local que roda os gates. Zero token | ✅ |
| ⏰ | `/schedule` e `/loop` | nativo do Claude Code | Agente na nuvem em cron / tarefa recorrente na sessão | ✅ |

## 🧭 Qual usar

- Integração entre sistemas (webhook → planilha → WhatsApp) → **n8n**. O agente
  desenha e valida o workflow; quem roda é o n8n, não o modelo.
- Checagem que não precisa de raciocínio → **guarda noturna** (bash).
- Tarefa recorrente que precisa de raciocínio → `/schedule`.

A regra: se dá para fazer sem modelo, faça sem modelo.
[`06-guarda-noturna.md`](../06-guarda-noturna.md).

## 📦 Instalação

```
/plugin install czlonkowski/n8n-skills
```

Pré-requisito: o servidor [n8n-mcp](https://github.com/czlonkowski/n8n-mcp)
configurado no `.mcp.json` do projeto que usa n8n.
