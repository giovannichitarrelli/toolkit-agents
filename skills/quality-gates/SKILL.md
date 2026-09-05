---
name: quality-gates
description: Instala gates de qualidade de lint (teto de linhas por arquivo, proibição de console direto, proibição de a camada de apresentação importar o cliente do banco) num projeto JS/TS, com severidade decidida pela contagem real de violações. Use quando quem pediu pedir para instalar/configurar ESLint, gates de qualidade, teto de tamanho de arquivo, ou quando um projeto novo entrar sem lint configurado. Não conserta violação — instala e mede.
---

# Quality gates de lint

## Princípio

Regra nova **nunca** pula de "desligada" para "erro que trava a build". Isso ou trava o trabalho da noite pro dia, ou é desligada na primeira sexta-feira — e nenhuma das duas muda o código.

Regra nova entra como **`warn` com a contagem de violações anotada como linha de base**. O número fica público e visível. Quando chega a zero, a regra vira `error` — e o gate fecha para sempre. Aperta aos poucos; nunca de surpresa.

**Regra que nasce com zero violação já nasce em `error`.** Não tem por que esperar.

## As três regras

Os arquivos já existem, já foram testados, e ficam em `eslint/` ao lado deste SKILL.md:

```
eslint/eslint-rules/utils.cjs
eslint/eslint-rules/core-rules.cjs
eslint/eslint-rules/index.cjs
eslint/eslint.config.mjs.example
eslint/eslint.typed.config.mjs.example
eslint/verify.mjs
```

| Regra | O que pega |
|---|---|
| `quality/max-lines` | Arquivo acima do teto (padrão **350**). Abaixo de ~200 vira briga com código legítimo; acima de ~500 para de exercer pressão. `index.ts` que só reexporta é isento. |
| `quality/no-direct-console` | `console.*` fora do adaptador de log do projeto. |
| `quality/no-direct-data-access` | Camada de apresentação importando o cliente do banco direto. Sem módulo de dados no projeto → **remova a regra**, não invente uma fronteira que não existe. |

**Copie os `.cjs` byte a byte.** Não reformate, não converta para ESM, não funda em um arquivo só, não "melhore". São CommonJS de propósito, para o ESLint carregar sem build step. Regra de lint escrita na hora erra em silêncio: isenta arquivo de teste demais ou de menos, e reporta em posição errada — aparece como regra que "não pega nada" ou "pega tudo", e alguém desliga.

## Passos

### 1. Ler o projeto antes de mudar qualquer coisa

Reporte o que achou antes de continuar:
- gerenciador de pacote, script de lint existente, versão do ESLint
- é TypeScript? quais path aliases o `tsconfig.json` define?
- raiz do código: `src/`, `app/`, `lib/` ou a raiz do repo
- camada de apresentação: quais diretórios têm UI ou entrypoint de rota
- módulo de dados: qual arquivo exporta o cliente do banco/ORM, e com que nome
- adaptador de log: por qual módulo o projeto já loga, se existir

**ESLint 8 ou anterior → pare e diga.** O config usa `defineConfig` e `globalIgnores` de `eslint/config`, que não existem antes do ESLint 9.

### 2. Dependências

```
<pm> i -D eslint@^9 @eslint/js@^9
<pm> i -D typescript-eslint                                    # se TS
<pm> i -D eslint-plugin-import-x eslint-import-resolver-typescript   # se for impor fronteira de import
```

Fixe `@eslint/js` no mesmo major do `eslint`. Sem pin, o instalador pega `@eslint/js@10`, cujo peer range exige `eslint@10`, e o install quebra com `ERESOLVE`.

### 3. Adaptar `eslint.config.mjs`

Cada item é uma edição real contra o que o passo 1 achou, não uma revisão:
- globs de `files`, se a raiz do código não é `src/`
- `quality/max-lines`: `max` = teto escolhido (350)
- `quality/no-direct-data-access`: `modules` = specifier real do módulo de dados; `bindings` = nome real do cliente exportado; `layers` = diretórios reais de apresentação; `extensions` = extensão de componente (remova `extensions` em projeto não-React)
- zonas do `import-x`: reescreva para as camadas reais, **ou apague o bloco inteiro** se o projeto ainda não tem camadas. Apagou → apague também os dois imports do topo e as duas entradas no bloco de arquivos de teste, senão o ESLint falha com regra desconhecida
- bloco que desliga `quality/no-direct-console`: aponte para o adaptador de log real, ou apague se não houver
- `globals`: adicione o que o runtime do projeto realmente oferece
- `globalIgnores`: adicione os diretórios de build

**Dois modos de falha completamente silenciosos:**
1. Um bloco que desliga uma regra precisa vir **depois** do bloco que a liga. Em flat config, para um arquivo casado pelos dois, o último bloco vence — um `off` antes é sobrescrito sem aviso nenhum.
2. `except` dentro de uma zona `no-restricted-paths` é relativo a `from`: ele recorta arquivos do `from` e **não** consegue isentar um importador. Para isentar importador, estreite o `target`.

### 4. Scripts

```json
"lint": "eslint .",
"lint:fix": "eslint . --fix",
"lint:types": "eslint --config eslint.typed.config.mjs ."
```

Sem `lint:types` em projeto JS. Mantenha o tier type-aware fora do script rápido e fora de qualquer pre-commit hook: ele constrói o programa TypeScript inteiro — lento o bastante para as pessoas burlarem o hook, e pesado o bastante para estourar a heap num runner pequeno de CI.

### 5. Verificar que a cópia sobreviveu

```
node verify.mjs
```

Esperado: três linhas terminando em `: ok`, exit code 0. Qualquer outra coisa = cópia quebrada, conserte antes de seguir. Apague `verify.mjs` depois, ou ligue no script de teste — não deixe largado sem explicação.

**Rode isso antes de acreditar em qualquer contagem de violação.** Se as regras chegaram quebradas, um lint limpo não quer dizer nada.

### 6. Rodar e MEDIR

```
<pm> run lint
```

Reporte a contagem por regra. Severidade sai da contagem, não da preferência:
- zero violações → fica em `error`
- tem violação → cai para `warn` com a contagem anotada em comentário ao lado. Essa contagem é a linha de base; a migração acaba quando chega a zero e a regra volta para `error`
- `quality/max-lines` com poucos infratores → mantenha em `error` e liste os arquivos na opção `ignore`. Lista curta e explícita vence regra que ninguém confia

### 7. Reportar

Quais regras foram instaladas, quais foram puladas e por quê, contagem por regra, quais estão em `warn` com linha de base, a lista de arquivos acima do teto ordenada por tamanho, e os comandos exatos para rodar o linter.

## Proibições

- **Não conserte nenhuma violação encontrada.** Instalar o gate e medir o que ele pega é o trabalho inteiro. Refatorar é trabalho separado, com review próprio.
- **Não aumente o teto para um arquivo passar.** O teto é o ponto. Use `ignore` para um infrator conhecido, ou deixe reportado.
- **Não ligue preset de framework só porque existe.** Descomente bloco só para framework que o projeto realmente usa.
- **Não ligue formatador** numa base que nunca passou por um. A primeira rodada gera milhares de linhas de diff só de formatação, sem relação com bug, e atrapalha o review de verdade.

## Instalação parcial

As três regras são independentes. Projeto grande → instale só `quality/max-lines` primeiro, um gate de cada vez.
