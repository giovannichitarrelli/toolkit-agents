# Sanidade do projeto

Roda uma vez por repositório. O produto é um mapa **verificado** — não o que a
documentação afirma.

```
Faça um levantamento de sanidade deste repositório. Verifique cada item
executando, nunca lendo documentação. Não conserte nada ainda.

1. STACK REAL
   Linguagem, framework e versão do que está instalado — package.json,
   pubspec.yaml, deno.json, lock file. Compare com o que o CLAUDE.md ou o
   README afirmam e aponte cada divergência.

2. COMANDOS CANÔNICOS
   Liste os scripts que existem de verdade. Rode cada um e diga qual passa,
   qual falha e qual não existe mais. Cole o output real.

3. GATES
   Que travas automáticas existem? Lint, typecheck, teste, checagem própria,
   hook de pre-commit ou pre-push. Alguma está quebrada ou desligada?

4. FRONTEIRAS
   Onde ficam os segredos. O que é exposto ao browser. Que arquivo com
   credencial está fora do .gitignore. Que chave aparece em texto puro.

5. O QUE A DOCUMENTAÇÃO AFIRMA E NÃO É MAIS VERDADE
   Path que não existe, comando removido, app apagado que ainda é citado,
   secret listado que não está configurado.

Entregue uma tabela por seção, com âncora arquivo:linha ou output de comando
em cada afirmação. Achado sem âncora vai marcado como suspeita, com o que
falta para provar.
```
