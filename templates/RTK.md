# Proxy de tokens — copie para `~/.claude/RTK.md`

> Importado pelo `CLAUDE.md` global com `@RTK.md`, então carrega em toda sessão.
> Mantenha curto.

Um proxy de CLI intercepta comandos de leitura repetitivos (`status`, `diff`,
`log`, `grep`, `find`, listar arquivo) e devolve uma versão enxuta em vez da
saída bruta. Para o agente é transparente: o comando volta mais barato, sem
instrução extra para lembrar.

A implementação concreta usada aqui é o [`rtk`](https://github.com/rtk-ai/rtk),
ligado por um hook `PreToolUse` em `Bash`. Qualquer proxy equivalente serve — o
que importa são as duas armadilhas abaixo.

## Comandos que valem saber

```bash
rtk gain              # quanto já foi economizado, medido pelo próprio binário
rtk gain --history    # histórico por comando
rtk discover          # o que ainda passa sem filtro
rtk proxy <cmd>       # roda sem filtro nenhum (depuração)
```

## Armadilha 1 — a reescrita pode devolver contagem errada, em silêncio

`grep -c` sobre 8 arquivos devolveu "1 matches in 1F"; o real era **22
ocorrências em 8 arquivos**. O `-c` perde a semântica e nada é sinalizado.

**Quando o número importa** — contagem, tamanho, diff exato — use caminho
absoluto: `/usr/bin/grep`, `/usr/bin/wc`, `/usr/bin/diff`. Caminho absoluto
escapa do hook. Para leitura exploratória, o proxy está ok.

Compactação que muda o resultado não é economia: é resposta errada com cara de
certa.

## Armadilha 2 — o `discover` não enxerga o hook

O transcript grava **as duas formas**: o comando original em `input.command` e o
reescrito em `PreToolUse.updatedInput.command`. O `rtk discover` lê só o
primeiro.

Consequência: a linha **"Already using RTK: N (1%)"** conta apenas o que foi
digitado já começando com `rtk`, e **nunca vai subir**. Não é falha de
configuração; não abra issue por causa disso.

O número confiável é o do **`rtk gain`**, medido pelo binário quando ele roda.

## Permissões

O `rtk rewrite` devolve exit 3 (*ask*) em todo comando, sempre — o hook nunca
auto-aprova, por design. Quem faz o comando reescrito passar sem ida ao
classificador é a allowlist. Em `~/.claude/settings.json`:

```json
"Bash(rtk read:*)", "Bash(rtk grep:*)", "Bash(rtk ls:*)", "Bash(rtk find:*)",
"Bash(rtk wc:*)", "Bash(rtk du:*)", "Bash(rtk git status:*)",
"Bash(rtk git diff:*)", "Bash(rtk git log:*)", "Bash(rtk tsc:*)", "Bash(rtk lint:*)"
```

**Não use `Bash(rtk:*)`** — isso liberaria `rtk proxy rm -rf` e `rtk git push`.
Só os subcomandos de leitura.
