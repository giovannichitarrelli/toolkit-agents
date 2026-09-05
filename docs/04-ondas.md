# Ondas paralelas

Despacho serial é seguro e lento. Despachar tudo de uma vez é rápido e quebra de
duas formas: dois agentes editam o mesmo arquivo e um sobrescreve o outro; dois
agentes disputam o `git commit`.

## Antes de tudo: isso se paga?

Multiagente custa **3–10× mais token** que um agente resolvendo sozinho
([Anthropic, jan/2026](https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them)).
Só se paga em três casos:

- **Proteção de contexto** — isolar investigação ruidosa fora da janela principal
- **Paralelização real** — trabalho genuinamente independente
- **Especialização genuína** — a tarefa exige checklist que um generalista não
  carrega

Fora deles, vá serial. Onda é despesa sem retorno.

**Anti-padrões** — não decomponha assim:

- por área temática ("um agente pro banco, um pro front") em vez de por fronteira
  de contexto isolável
- plano / implementação / teste como agentes separados: compartilham o mesmo
  contexto, são uma unidade
- separar componentes fortemente acoplados só porque são "duas partes"
- trabalho sobre estado mutável compartilhado — se A precisa ler o que B escreve
  enquanto B escreve, é uma tarefa só fingindo ser duas

## Marcação

Toda tarefa do plano precisa de dois campos:

- **`Files:`** — os caminhos exatos que cria ou modifica. `Files:` vago é o mesmo
  que não preencher
- **`Depends-on:`** — IDs das tarefas cujo resultado consome, ou `nenhuma`

**Fail-safe:** campo ausente, caminho vago ou incerteza real → a tarefa depende de
**tudo que veio antes**. O erro seguro (perder paralelismo) é o único permitido.

## Formação de onda

Duas tarefas entram na mesma onda **se e somente se as duas condições valerem**:

1. Nenhuma está na cadeia `Depends-on:` da outra — nem transitivamente
2. Os conjuntos `Files:` são **totalmente disjuntos**

Mesmo arquivo desqualifica **mesmo em seções diferentes** do arquivo. A regra é
por arquivo, não por linha.

Plano linear degrada para uma tarefa por onda — igual ao serial. Não há
regressão, só ganho quando o plano realmente tem independência.

Duas tarefas que colidem em arquivo por coincidência: **funda numa só** antes de
montar as ondas. Evita até o commit extra.

## Loop de execução

1. Um brief por tarefa da onda
2. **Todos os executores da onda numa única mensagem** — o único ponto onde o
   paralelismo acontece
3. **Executor não commita.** Deixa na working tree e reporta os arquivos tocados
4. Espere a onda inteira terminar
5. **Você commita**, uma tarefa por commit, na ordem — capturando o `HEAD`
   **imediatamente antes de cada commit**. Capturar uma vez no início da onda é o
   erro clássico: depois do primeiro commit ele já está velho
6. Revisores da onda juntos — seguro porque review é só leitura
7. **Um** registro de progresso por onda, nunca um por tarefa

## Válvula de escape

Duas tarefas que genuinamente precisam do mesmo arquivo: isole cada executor em
`isolation: "worktree"`. Commitar sozinho volta a ser seguro, porque não existe
índice compartilhado.

Caro: disco e reinstalação de dependência por agente. Último recurso.

## O que isto não muda

Só a orquestração. O contrato de cada executor e revisor continua idêntico, e o
passo de prova do fluxo continua obrigatório antes de qualquer commit.
