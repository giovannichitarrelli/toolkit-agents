# 💸 Custo

## 🎚️ Tier por agente, declarado

Todo agente tem `model:` no frontmatter. Nenhum herda.

```
alto    executor                      só ele
médio   planejador, arquiteto-dados, revisores, verificador,
        socio-produto, seo-geo
barato  busca
```

**`Explore`, `general-purpose` e `fork` herdam o modelo do pai.** Sem `model`
explícito, sobem no tier mais caro — para tarefas que só leem arquivo. Num
período medido, isso foi **20% do consumo total**.

Por isso existe o agente `busca`: mesmo trabalho, tier barato, e uma instrução
explícita no `CLAUDE.md` para nunca usar os genéricos.

Tier é decisão **da tarefa**, não do nome do agente. O mesmo especialista pode
rodar barato numa tarefa trivial e intermediário numa complexa.

## 🧠 Contexto é o custo, não o número de mensagens

Cada tool call reenvia a conversa inteira. A 600k, um tool call custa cerca de
**12×** o mesmo tool call a 50k.

O que isso muda na prática:

- **`/clear` na troca de assunto.** O gatilho é o assunto mudar, não um número
- **Não recarregar arquivo já lido** na sessão
- **`grep -n` em vez de dump** de arquivo grande
- **Janela de contexto ampliada só quando a tarefa exige** ler um repo inteiro de
  uma vez — e voltar depois

## 🪙 Proxy de tokens

Um proxy intercepta comandos de leitura repetitivos e devolve versão enxuta. Para
o agente é transparente.

Duas armadilhas que valem mais que o ganho, se você não souber delas — contagem
silenciosamente errada e uma métrica que nunca sobe. Estão em
[`templates/RTK.md`](../templates/RTK.md).

## 🚫 O que não fazer

- **Ligar o contexto de 1M por padrão.** Você paga pelo que carrega
- **Rodar swarm porque é impressionante.** 3–10× de custo por trabalho que um
  agente faz sozinho
- **Confiar em métrica auto-reportada de ferramenta.** Meça na sua máquina
