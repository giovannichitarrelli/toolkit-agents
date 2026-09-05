# Review multiagente

Para diff grande, antes de commit ou deploy. Review é só leitura, então
paralelizar é seguro.

```
Revise as mudanças [PLACEHOLDER: não commitadas | do último commit | da branch]
em paralelo, uma superfície por revisor:

- `revisor-codigo`: bug, furo de fluxo, estado quebrado, drift de contrato
  (RPC, coluna, tipo), UI fora do design system, número hardcoded.
- `revisor-seguranca`: só se o diff tocar auth, webhook, env, pagamento, RLS,
  CORS ou CSP. Se não tocar, diga que não se aplica em vez de inventar achado.
- `arquiteto-dados`: só se houver SQL ou migration no diff.

Regra para todos: toda alegação precisa de âncora — arquivo:linha ou output
real de comando. Sem prova, marque como SUSPEITA e diga o que falta para
provar. Achado sem âncora não entra no relatório.

Consolide num relatório só, ordenado por gravidade. Não conserte nada.
```
