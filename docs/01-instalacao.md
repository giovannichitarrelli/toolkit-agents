# 📦 Instalação

## 🤖 1. Claude Code

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

## 🔌 2. Plugins

Dentro de uma sessão `claude`:

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin install superpowers@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install hookify@claude-plugins-official
```

**`superpowers`** traz as skills de processo — `brainstorming`,
`writing-plans`, `systematic-debugging`, `verification-before-completion`. O
fluxo deste toolkit pressupõe elas instaladas.

**`context7`** injeta documentação atual de biblioteca. Sem ele, o modelo inventa
API plausível para qualquer framework lançado depois do corte de conhecimento.

**`pr-review-toolkit`** traz o `silent-failure-hunter` e o `pr-test-analyzer`,
que entram no passo 5 do fluxo ao lado do `revisor-codigo`.

**`hookify`** transforma os não-negociáveis em trava. Copie as regras de
[`templates/hookify/`](../templates/hookify/) para o `.claude/` de cada projeto —
ver [🪝 Hooks](09-hooks.md).

Opcional, para testar: **Ponytail** (`/plugin marketplace add DietrichGebert/ponytail`
→ `/plugin install ponytail@ponytail`), a escada da solução mais simples.

> Se você já tinha copiado skills do superpowers à mão para `~/.claude/skills/`,
> apague as cópias antes de instalar o plugin — nomes duplicados conflitam, e a
> cópia manual não recebe atualização.

## 🧑‍🤝‍🧑 3. Agentes e skills

```bash
git clone https://github.com/giovannichitarrelli/toolkit-agents
cd toolkit-agents
./instalar.sh              # prévia
./instalar.sh --aplicar    # copia, com backup do que já existir
```

O instalador é idempotente e **não toca** em `settings.json`, `CLAUDE.md` nem
`RTK.md`. Esses são seus.

## ✍️ 4. Os três arquivos que você adapta à mão

| Template | Vai para | O que ajustar |
|---|---|---|
| `templates/CLAUDE.md.template` | `~/.claude/CLAUDE.md` | Idioma da copy, onde ficam seus projetos, seus CLIs |
| `templates/RTK.md` | `~/.claude/RTK.md` | Só se você usar um proxy de tokens |
| `templates/settings.json.example` | `~/.claude/settings.json` | Modelo, hooks, allowlist |

**Não copie por cima** de configuração que já existe — leia e junte.

## 🌙 5. Guarda noturna (opcional, por projeto)

```bash
mkdir -p <projeto>/.guarda
cp templates/guarda-noturna/guarda-noturna.sh <projeto>/.guarda/
```

Ajuste `RAIZ`, `PATH` e os `_gate` para os comandos **reais** do projeto —
descubra com `cat package.json`, não de memória. Depois agende com o plist
(macOS) ou cron, e cole o hook de `SessionStart`.

Detalhe em [06 — Guarda noturna](06-guarda-noturna.md).

## 🔄 6. Reinicie

Agentes, settings e hooks são lidos no start da sessão. Plugins entram na hora;
o resto, não.

## 🔍 Conferir

```bash
ls ~/.claude/agents/       # 9 arquivos .md
ls ~/.claude/skills/       # ondas-paralelas, provas-de-regressao, quality-gates
```

Numa sessão nova, os agentes aparecem na lista de tipos disponíveis e as skills
na listagem de skills.
