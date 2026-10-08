# 🌙 Guarda noturna

Um cron local que roda **os gates que o seu projeto já tem** e deixa um
relatório. Bash puro, sem agente no meio: **custo zero de token**. O agente só
entra quando você pede o diagnóstico do que ficou vermelho.

## 🏠 Por que local e não agente na nuvem

Um agente agendado na nuvem não tem o seu `node_modules`, nem o SDK da
plataforma, nem o `provas/.env` com as credenciais — que é gitignorado e local. E
cobraria token para rodar o que já é um script determinístico.

A suíte de gates de um projeto **já é** bash com exit code. Só falta agendar.

## ⚙️ O que ele roda

Os comandos reais do projeto — descubra com `cat package.json`, não de memória.
Um gate que não existe vira vermelho eterno, e vermelho eterno vira papel de
parede.

Um exemplo de projeto com três repositórios:

```
web        typecheck · lint · test · build · os :check próprios
backend    deno check functions/*/index.ts · deno test
app        analyze · test
provas     provas/rodar.sh (só leitura)
público    GET na URL de produção esperando 200
```

**Nada escreve em produção.** Provas de escrita ficam de fora de propósito — só
rodam quando você chama com `--escrita`.

## 🔧 Detalhes que decidem se funciona

**`PATH` absoluto no script.** `launchd` e `cron` não herdam o PATH do seu shell.
Resolva com `command -v node pnpm deno flutter` e crave os diretórios.

**Timeout por gate.** O macOS não traz `timeout`. O script usa o `alarm` do perl:

```bash
/usr/bin/perl -e 'alarm shift @ARGV; exec @ARGV' 300 bash -c "npm test"
```

Estouro sai com 142, que o script trata como "estourou o limite". Build 900s,
testes 600s, o resto 300s. Nenhum gate trava a madrugada.

**Não para no primeiro erro.** Roda todos e reporta a lista completa.

**Flags de permissão importam.** `deno test` que mexe em `Deno.env` sem
`--allow-env` morre com `NotCapable` e **parece regressão**. Não é — é o comando
errado. Isso custou uma investigação inteira no caminho de pagamento antes de
alguém olhar a flag.

## 👀 Como você vê o resultado

Um hook de `SessionStart` lê a primeira linha do relatório:

- **Verde** → não imprime nada. Custo zero de contexto
- **Vermelho** → a primeira sessão do dia abre com o aviso e o caminho do
  relatório

## 💬 A conversa que você vai ter na primeira execução

Ela vai achar coisa. Numa primeira execução real, cinco vermelhos em 121
segundos — e dois eram configuração errada do próprio guarda.

Separe em três baldes:

| Balde | O que fazer |
|---|---|
| **Configuração do guarda** | Flag errada, comando que não existe. Conserte o guarda |
| **Dívida conhecida** | Lint acumulado, ferramenta desatualizada. Ou limpa agora, ou vira linha de base explícita |
| **Falha de verdade** | Teste vermelho, gate quebrado. Fica rígido desde já |

O balde do meio é o que mata um gate: se ele fica vermelho toda noite, o aviso
vira ruído e você para de ler. Ou você limpa, ou registra a contagem como linha
de base — a mesma lógica dos [quality gates](07-quality-gates.md).

## 📁 Arquivos

[`templates/guarda-noturna/`](../templates/guarda-noturna/) — o script, o plist
do launchd e o hook de `SessionStart`.
