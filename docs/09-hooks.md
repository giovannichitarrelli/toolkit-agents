# 🪝 Hooks

Regra escrita no `CLAUDE.md` vale quando o modelo lembra. Hook vale **sempre**:
quem dispara é o Claude Code, não o modelo. Por isso os não-negociáveis que dá
para checar por padrão de texto viram hook.

## 🚫 As travas (hookify)

O plugin oficial `hookify` lê regras em markdown de `.claude/hookify.*.local.md`
**no diretório onde a sessão foi aberta**. Não existe versão global: copie as
regras para o `.claude/` de cada projeto.

| | Regra | Bloqueia |
|---|---|---|
| 🔓 | [`bloquear-desligar-rls`](../templates/hookify/hookify.bloquear-desligar-rls.local.md) | `DISABLE ROW LEVEL SECURITY` em qualquer arquivo escrito |
| 🌍 | [`segredo-em-env-publico`](../templates/hookify/hookify.segredo-em-env-publico.local.md) | `NEXT_PUBLIC_`/`VITE_`/`EXPO_PUBLIC_` + `SECRET`/`SERVICE_ROLE`/`PRIVATE`/`PASSWORD`/`WEBHOOK` |
| 🧪 | [`service-role-em-prova`](../templates/hookify/hookify.service-role-em-prova.local.md) | Service role dentro de `provas/` — prova roda com JWT de usuário |
| 🔑 | [`git-add-env`](../templates/hookify/hookify.git-add-env.local.md) | `git add` de `.env*` (exceto `.env.example`) |

```
/plugin install hookify@claude-plugins-official
```

```bash
cp templates/hookify/*.local.md /caminho/do/projeto/.claude/
```

Efeito imediato, sem reiniciar. `/hookify:list` mostra o que está ativo;
`/hookify` sem argumento lê a conversa e propõe regra a partir do que você
corrigiu.

> [!WARNING]
> Use o campo **`content`** nas condições de arquivo, não `new_text`. O
> `new_text` só lê `Edit`: num `Write` ele vem vazio e a regra nunca dispara.
> Descoberto testando — a regra parecia certa e passava tudo.

As quatro regras foram testadas no motor do hookify com 9 entradas (bloqueia o
caso errado, deixa passar o vizinho legítimo, como `NEXT_PUBLIC_SUPABASE_ANON_KEY`
e `.env.example`).

> [!NOTE]
> Hookify cobre `Bash`, `Write` e `Edit`. SQL enviado pelo MCP do Supabase não
> passa por ele — ali quem segura é o `arquiteto-dados` e o review.

## 🛟 Hook seu: falhar aberto

Hook que quebra pode trancar a sessão — um `SessionStart` que lança exceção
impede a sessão de começar, e não sobra sessão de onde consertar. Regra:

- Sai com `0` (libera) ou com o código de bloqueio designado (`2`). **Só.**
- Qualquer erro interno → degrada em silêncio, a ação segue.
- Exceção: trava de segurança real (ler arquivo de credencial) pode falhar
  **fechado**. Decida e escreva qual é qual.

### 🐛 O bug que passa em review: `null` é JSON válido

```python
try:
    entrada = json.load(sys.stdin)
except ValueError:
    return
caminho = entrada.get("transcript_path")   # quebra se stdin for "null"
```

`json.load` de `null` devolve `None` **sem lançar** — o `except` nunca roda e o
`.get` quebra na linha seguinte. Mesmo bug em JS: `JSON.parse("null")`. O
conserto é uma linha:

```python
if not isinstance(entrada, dict):
    return
```

Este toolkit tinha exatamente esse bug no `aviso-contexto.py` — achado lendo o
[guia de hooks do vibe-coding-toolkit](https://github.com/soumatheusgomes/vibe-coding-toolkit/blob/main/docs/tools/10-hooks-best-practices.md),
que tem a versão JS pronta (`hook-io.mjs`).

### ✅ Teste antes de registrar

```bash
for i in 'null' '[]' '' '{}'; do printf '%s' "$i" | python3 meu-hook.py; echo "[$i] exit=$?"; done
```

Todas as entradas precisam sair `0` sem traceback.
