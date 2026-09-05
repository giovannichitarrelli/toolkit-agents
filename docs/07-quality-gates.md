# Quality gates

## O princípio

Regra nova **nunca** pula de "desligada" para "erro que trava a build". Isso ou
trava o trabalho da noite pro dia, ou é desligada na primeira sexta-feira — e
nenhuma das duas muda o código.

Regra nova entra como **aviso com a contagem anotada** como linha de base. O
número fica público e visível. Quando chega a zero, vira erro e o gate fecha para
sempre. Aperta aos poucos; nunca de surpresa.

**Regra que nasce com zero violação já nasce em erro.** Não tem por que esperar.

## Severidade sai da contagem, não da preferência

```
zero violações      → error
tem violação        → warn, com a contagem em comentário ao lado
poucos infratores   → error, com os arquivos na opção `ignore`
```

A contagem é a linha de base. A migração acaba quando chega a zero.

## As três regras que a skill instala

| Regra | O que pega |
|---|---|
| `quality/max-lines` | Arquivo acima do teto (padrão 350). Abaixo de ~200 vira briga com código legítimo; acima de ~500 para de exercer pressão |
| `quality/no-direct-console` | `console.*` fora do adaptador de log |
| `quality/no-direct-data-access` | Camada de apresentação importando o cliente do banco direto |

Sem módulo de dados no projeto → **remova a regra**, não invente uma fronteira
que não existe.

## Por que copiar as regras em vez de escrever

Regra de lint escrita na hora erra em silêncio: isenta arquivo de teste demais ou
de menos, não sabe que um `index.ts` que só reexporta não tem tamanho que
signifique nada, e reporta em posição errada. Nenhum desses erros aparece como
falha — aparece como regra que "não pega nada" ou "pega tudo", e alguém desliga.

Os arquivos vivem em
[`skills/quality-gates/eslint/`](../skills/quality-gates/eslint/). Copie byte a
byte. São CommonJS de propósito, para o ESLint carregar sem build step.

## Dois modos de falha completamente silenciosos

1. **Ordem dos blocos.** Um bloco que desliga uma regra precisa vir **depois** do
   que a liga. Em flat config, para um arquivo casado pelos dois, o último vence
   — um `off` antes é sobrescrito sem aviso.
2. **`except` em `no-restricted-paths`** é relativo a `from`: recorta arquivos do
   `from` e **não** isenta um importador. Para isentar importador, estreite o
   `target`.

## Proibições

- **Não conserte violação durante a instalação.** Instalar o gate e medir o que
  ele pega é o trabalho inteiro. Refatorar é trabalho separado, com review
  próprio
- **Não aumente o teto para um arquivo passar.** O teto é o ponto
- **Não ligue formatador** numa base que nunca passou por um. A primeira rodada
  gera milhares de linhas de diff sem relação com bug, e atrapalha o review

## Fora do JS/TS

O princípio vale igual. Num projeto Dart, `flutter analyze` sai com código 1 em
qualquer issue — inclusive `info`. Duas saídas honestas: limpar a dívida, ou
declarar a supressão **com o motivo escrito** no `analysis_options.yaml`. Falso
positivo conhecido de codegen é supressão legítima; aviso que você só não quer
ver, não é.
