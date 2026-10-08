---
name: mcp-sql-desligar-rls
enabled: true
event: all
action: block
tool_matcher: mcp__supabase__execute_sql|mcp__supabase__apply_migration|mcp__claude_ai_Supabase__execute_sql|mcp__claude_ai_Supabase__apply_migration
conditions:
  - field: query
    operator: regex_match
    pattern: (?i)disable\s+row\s+level\s+security|no\s+force\s+row\s+level\s+security
---

⛔ **RLS desligado via MCP do Supabase.** Esse caminho vai direto ao banco,
sem arquivo, sem migration versionada e sem review — o pior lugar para isso.

Não-negociável: nunca desabilitar RLS. Se a query está bloqueada, o conserto é
a policy. Chame o `arquiteto-dados`.
