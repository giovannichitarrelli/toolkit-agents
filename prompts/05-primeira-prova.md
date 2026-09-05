# Primeira prova de regressão

Use logo depois de um veredito PROVADO, para a prova não ser jogada fora.

```
Grave a verificação que você acabou de fazer como prova re-rodável, seguindo
a skill `provas-de-regressao`.

Se `provas/` ainda não existe neste repositório, monte a pasta a partir do
modelo da skill — copiando `lib.sh` e `rodar.sh` byte a byte, sem reescrever.
Assertion escrita na hora erra em silêncio, e o modo de falha é uma prova que
fica verde sem provar nada.

A prova precisa cobrir as quatro:
- a escrita gravou (contando linha afetada ou relendo o efeito — `error ==
  null` NÃO é prova)
- quem não pode: o mesmo passo com outro usuário e como anônimo, esperando 0
- o caso sem dado: o que o sistema devolve quando não existe nada
- o contrato: a RPC ou coluna chamada existe com a assinatura chamada

Cabeçalho obrigatório: FLUXO, TIPO (leitura|escrita), CRIADA, PROVA, USUÁRIO,
ESPERADO, TEARDOWN.

Credencial sempre de env, nunca no arquivo. Antes de gravar, confirme que
`provas/.env` está no .gitignore e me mostre a confirmação.

Se o fluxo não for re-rodável, diga isso em vez de gravar uma prova que vai
falhar amanhã por motivo errado.
```
