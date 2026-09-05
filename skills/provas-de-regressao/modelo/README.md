# provas/

Provas executáveis do que já foi provado funcionar. Não é suíte de teste unitário:
cada arquivo aqui exercita o **sistema real** — banco com RLS, PostgREST, edge function —
com **JWT de usuário**, nunca com `service_role`.

Existe porque a classe de bug desta plataforma passa verde em teste com mock:
RLS bloqueando em silêncio, view sem `security_invoker`, grant por coluna matando
`upsert`, teto de 1000 do PostgREST, ausência virando zero, gate só no cliente.

## Por que não fica em `test/` ou `tests/`

`flutter test`, vitest e `deno test` descobrem esses diretórios sozinhos. Estas provas
precisam de credencial real e escrevem no banco de produção — não podem rodar por
acidente num `pnpm test` nem em CI.

## Rodar

```bash
cp provas/env.example provas/.env   # preencha; .env NÃO vai para o git
./provas/rodar.sh                   # todas as de leitura (seguras de repetir)
./provas/rodar.sh --fluxo ingresso  # só as que casam com o padrão
./provas/rodar.sh --escrita         # inclui as de escrita — ESCREVE EM PRODUÇÃO
```

Exit code: `0` passou · `1` alguma falhou (regressão) · `2` não deu para provar (falta env).

## Estrutura

- `leitura/` — só lê. Sempre seguro repetir. Roda em toda verificação.
- `escrita/` — cria e apaga. Teardown obrigatório. Só com `--escrita`, e só quando o
  diff toca aquele fluxo.
- `lib.sh` — asserções e helpers. Não reescreva por prova.
- `rodar.sh` — o runner.
