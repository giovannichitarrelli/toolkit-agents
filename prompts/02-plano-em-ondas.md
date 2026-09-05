# Plano em ondas

Use depois de ter um plano aprovado, quando ele tiver 2+ tarefas.

```
Converta o plano abaixo em ondas de execução, seguindo a skill
`ondas-paralelas`.

PLANO:
[PLACEHOLDER: cole o plano, ou aponte o arquivo]

Para cada tarefa, produza: ID curto, descrição de uma linha, `Files:` com os
caminhos EXATOS que ela cria ou modifica, `Depends-on:` e o especialista.

Regras que não se negociam:
- `Files:` vago é o mesmo que não preencher. Na dúvida, liste mais arquivos.
- Incerteza real sobre escopo ou dependência → `Depends-on: tudo acima`.
- Duas tarefas só entram na mesma onda se NENHUMA depende da outra (nem
  transitivamente) E os `Files:` forem totalmente disjuntos.
- Mesmo arquivo desqualifica mesmo em seções diferentes do arquivo.
- Duas tarefas que colidem em arquivo por coincidência: funda numa só.

Antes da tabela, responda: este plano tem paralelismo REAL, ou vai degradar
para uma tarefa por onda? Se degradar, diga e vá serial — multiagente custa
3–10x mais token e onda de uma tarefa só não paga o overhead.

Não execute nada. Só a tabela de tarefas e a tabela de ondas.
```
