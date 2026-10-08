---
name: git-add-env
enabled: true
event: bash
action: block
pattern: git\s+add\s+[^|;&]*\.env(?!\.example)
---

⛔ **`.env` indo para o git.** Arquivo de credencial nunca é commitado.

Confira o `.gitignore`. Se precisa documentar as variáveis, use `.env.example`
sem valores.
