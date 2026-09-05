# Montar o guarda noturna

```
Instale o guarda noturna neste projeto, a partir de
`templates/guarda-noturna/` do toolkit.

1. DESCUBRA os gates reais — `cat package.json`, `cat Makefile`, `cat
   deno.json`, o que existir. Não copie lista decorada: gate que não existe
   vira vermelho eterno, e vermelho eterno vira papel de parede.

2. RODE cada gate uma vez, agora, e me diga quais passam. Os que já falham
   são dívida existente, não regressão — separe.

3. RESOLVA os binários com `command -v` e crave os caminhos absolutos no
   PATH do script. launchd e cron não herdam o meu shell.

4. AJUSTE os `_gate`: timeout maior para build, menor para checagem estática.
   Nenhum gate escreve em produção. Provas de escrita ficam de fora.

5. AGENDE com o plist (macOS) ou cron, e cole o hook de SessionStart no
   settings.local.json do projeto.

6. RODE o guarda inteiro uma vez e me traga o relatório. Separe o resultado
   em três baldes: configuração errada do próprio guarda, dívida conhecida, e
   falha de verdade.

Não commite nada.
```
