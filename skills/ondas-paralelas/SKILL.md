---
name: ondas-paralelas
description: Executa um plano aprovado disparando subagentes em ondas paralelas com segurança. Use quando um plano tem 2+ tarefas e pelo menos duas parecem independentes entre si — antes de despachar qualquer executor. Define marcação Files/Depends-on, formação de ondas, e a regra de que implementador nunca commita. Ative também quando quem pediu pedir para "rodar em paralelo", "acelerar o plano" ou "disparar vários agentes".
---

# Ondas paralelas

Despacho serial (um executor, uma tarefa, um commit) é seguro e lento. Despachar tudo de uma vez é rápido e quebra de duas formas: dois agentes editam o mesmo arquivo e um sobrescreve o outro; dois agentes disputam o `git commit`.

Esta skill remove as duas causas **estruturalmente** — não por disciplina.

## 1. Marcação (no plano, antes de despachar)

Toda tarefa do plano precisa de dois campos:

- `Files:` — os caminhos exatos que a tarefa cria ou modifica. Caminho real, não "vários arquivos de front".
- `Depends-on:` — IDs das tarefas cujo resultado ela consome, ou `nenhuma`.

**Fail-safe:** campo ausente, caminho vago ou qualquer incerteza real sobre o escopo → a tarefa passa a depender de **tudo que veio antes**. Nunca chute um escopo mais estreito do que você sabe. O erro seguro (perder paralelismo) é o único permitido.

## 2. Formação de onda

Duas tarefas entram na mesma onda **se e somente se as duas condições valerem**:

1. Nenhuma está na cadeia `Depends-on:` da outra — nem transitivamente.
2. Os conjuntos `Files:` são **totalmente disjuntos**.

Falhou uma condição, mesmo que só uma → ondas diferentes. Mesmo arquivo desqualifica **mesmo que sejam seções diferentes** do arquivo — a regra é por arquivo, não por linha.

Plano linear (T2 depende de T1, T3 de T2...) degrada para uma tarefa por onda — igual ao serial. Não há regressão, só ganho quando o plano realmente tem independência.

Quando duas tarefas colidem em arquivo por coincidência, **fundir as duas numa tarefa só** costuma ser melhor que separar em ondas — evita até o commit extra.

Mostre a tabela de ondas antes de executar:

| Onda | Tarefas | Agente | Arquivos |
|---|---|---|---|

## 3. Loop de execução por onda

1. Escreva um brief por tarefa da onda (objetivo, `Files:`, critério de pronto).
2. Despache **todos os executores da onda numa única mensagem**. É o único ponto onde o paralelismo acontece.
3. **Executor não commita.** Deixa a mudança na working tree e reporta quais arquivos tocou.
4. Espere a onda inteira terminar.
5. **Você commita**, uma tarefa por commit, na ordem da onda — capturando o `HEAD` atual **imediatamente antes de cada commit**. Capturar o HEAD uma vez no início da onda é o erro clássico: depois do primeiro commit ele já está velho.
   Commit só com autorização de quem pediu, como sempre.
6. Despache os revisores da onda juntos — seguro porque review é só leitura, cada um no range de commit da própria tarefa.
7. **Um** registro de progresso por onda, nunca um por tarefa. Dois agentes escrevendo no mesmo log é a mesma classe de bug que dois agentes disputando commit.
8. `verificador` roda **no fim de todas as ondas**, sobre o fluxo completo — nunca por onda.

## 4. Válvula de escape

Duas tarefas que genuinamente não dão para separar (precisam do mesmo arquivo) e dividir mais destruiria o sentido de paralelizar: isole cada executor em `isolation: "worktree"`. Aí commitar sozinho volta a ser seguro, porque não existe índice compartilhado.

Caro: disco e reinstalação de dependência por agente. Último recurso, nunca o padrão.

## 5. Quando NÃO usar

Multiagente custa **3–10× mais token** que um agente resolvendo sozinho (Anthropic, *Multi-Agent Systems: When to Use Them*, jan/2026). Só se paga em três casos:

- **Proteção de contexto** — isolar investigação ruidosa fora da janela principal.
- **Paralelização real** — trabalho genuinamente independente.
- **Especialização genuína** — a tarefa exige checklist que um generalista não carrega.

Fora disso, onda é despesa sem retorno — vá serial.

Anti-padrões (não decomponha assim):
- Por área temática ("um agente pro banco, um pro front") em vez de por fronteira de contexto isolável.
- Plano / implementação / teste como agentes separados — compartilham o mesmo contexto, são uma unidade.
- Separar componentes fortemente acoplados só porque são "duas partes".
- Trabalho sobre estado mutável compartilhado — se A precisa ler o que B escreve enquanto B escreve, é uma tarefa só fingindo ser duas.

## 6. O que isto NÃO muda

Só a orquestração. O contrato de cada executor e revisor continua idêntico: ler antes de editar, parar e reportar se o plano estiver errado, autorrevisar antes de reportar, status explícito no fim. E o passo 5 do workflow global (`verificador` com prova real) continua obrigatório antes de qualquer commit.
