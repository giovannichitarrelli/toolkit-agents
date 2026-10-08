---
name: bloquear-desligar-rls
enabled: true
event: file
action: block
conditions:
  - field: content
    operator: regex_match
    pattern: (?i)disable\s+row\s+level\s+security|no\s+force\s+row\s+level\s+security
---

⛔ **RLS desligado.** Não-negociável: nunca desabilitar RLS.

Se uma query está sendo bloqueada, o conserto é a policy, não tirar a trava.
Chame o `arquiteto-dados` para desenhar a policy certa.
