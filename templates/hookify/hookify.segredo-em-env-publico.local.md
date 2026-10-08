---
name: segredo-em-env-publico
enabled: true
event: file
action: block
conditions:
  - field: content
    operator: regex_match
    pattern: (NEXT_PUBLIC|VITE|EXPO_PUBLIC)_[A-Z0-9_]*(SECRET|SERVICE_ROLE|PRIVATE|PASSWORD|WEBHOOK)
---

⛔ **Segredo em variável pública.** Tudo com `NEXT_PUBLIC_`, `VITE_` ou
`EXPO_PUBLIC_` vai para o bundle do navegador e qualquer um lê.

Chave secreta, service role, senha e segredo de webhook ficam só no servidor
(route handler, server action, edge function).
