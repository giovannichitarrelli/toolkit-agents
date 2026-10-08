# 💻 Código

O núcleo do toolkit. Tudo aqui serve ao fluxo planejar → executar → revisar →
**provar** ([`02-fluxo.md`](../02-fluxo.md)).

## ⚙️ Processo

| | Peça | Tipo | Para quê | Status |
|---|---|---|---|---|
| ⭐ | [Superpowers](https://github.com/anthropics/claude-plugins-official) | plugin | Brainstorm, plano, TDD, debugging sistemático, review | ✅ |
| 🌊 | `ondas-paralelas` | skill (daqui) | Plano em ondas com arquivos disjuntos | ✅ |
| 🧪 | `provas-de-regressao` | skill (daqui) | A prova do verificador vira suíte | ✅ |
| 🚦 | `quality-gates` | skill (daqui) | Teto de linhas, sem console, fronteira de camada | ✅ |
| 🦥 | [Ponytail](https://github.com/DietrichGebert/ponytail) | plugin | Para na solução mais simples que resolve | ✅ em teste |
| 🔇 | `pr-review-toolkit` | plugin | Caça falha silenciosa e teste fraco no review | ✅ |
| 🚫 | `hookify` + [regras](../../templates/hookify/) | plugin | Não-negociáveis viram trava automática | ✅ |

## 📚 Contexto e conhecimento

| | Peça | Tipo | Para quê | Status |
|---|---|---|---|---|
| 📚 | Context7 | plugin | Doc atual de lib — contra API alucinada | ✅ |
| 🧠 | [claude-mem](https://github.com/thedotmack/claude-mem) | plugin | Memória entre sessões, busca no histórico | ✅ |
| 🕸️ | [Graphify](https://github.com/Graphify-Labs/graphify) | CLI | Grafo do repo: dependência e impacto numa consulta | 🟢 |

## 🗄️ Banco e backend

| | Peça | Tipo | Para quê | Status |
|---|---|---|---|---|
| 🐘 | `supabase-postgres-best-practices` ([supabase/agent-skills](https://github.com/supabase/agent-skills)) | skill | Query, índice, schema, RLS | ✅ |
| 🔌 | MCP do Supabase | MCP (por projeto) | SQL, migrations, advisors, logs | ✅ |
| 🛠️ | `mcp-builder` ([anthropics/skills](https://github.com/anthropics/skills)) | skill | Escrever servidor MCP próprio | ✅ |
| 🧬 | [TypeSafe](https://github.com/typesafe-ai/skills) | plugin | Julgamento de IA tipado como primitiva de código | ✅ |

## 💰 Custo

| | Peça | Para quê | Status |
|---|---|---|---|
| 🪙 | [RTK](../../templates/RTK.md) | Proxy que compacta saída de comando | ✅ |
| ✂️ | `cost-reducer` | Regras de resposta curta no `CLAUDE.md` | ✅ |

## 📦 Instalação

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin install superpowers@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install hookify@claude-plugins-official
```

```bash
npx skills add supabase/agent-skills
npx skills add anthropics/skills
uv tool install graphifyy && graphify claude install
```

Agentes e skills deste repositório: `./instalar.sh --aplicar`
([`01-instalacao.md`](../01-instalacao.md)).
