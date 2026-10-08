---
name: service-role-em-prova
enabled: true
event: file
action: block
conditions:
  - field: file_path
    operator: regex_match
    pattern: (^|/)provas/
  - field: content
    operator: regex_match
    pattern: (?i)service_role|SERVICE_ROLE_KEY|SUPABASE_SERVICE
---

⛔ **Service role numa prova.** A service key fura RLS e faz todo teste passar.

Prova roda com JWT de usuário real (ver skill `provas-de-regressao`). Se o
teardown precisa de privilégio, isole num script fora de `provas/` e diga isso
no cabeçalho da prova.
