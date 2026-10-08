# 🖥️ Tela a partir de referência

Use depois do [`06-extrair-design-system`](06-extrair-design-system.md). Junta
referência visual + tokens + componentes prontos, sem a tela inventar estilo.

```
Construa a tela [NOME DA TELA] em [ROTA/ARQUIVO].

REFERÊNCIAS em [design/referencias/]. De cada uma, use SÓ o que indico:
- [ref-01.png]: [ex.: estrutura do hero e hierarquia do título]
- [ref-02.png]: [ex.: densidade e tratamento dos cards]
- [ref-03.png]: [ex.: nada de cor — só o layout da tabela]

REGRAS
- Estilo vem do DESIGN.md e dos tokens. Referência dá estrutura, nunca cor.
- Componente: primeiro shadcn. Se for peça de vitrine (hero, pricing, bento,
  depoimentos), busque no 21st.dev Magic e adapte aos tokens.
- Zero hex, zero px fora da escala de espaçamento.
- Todos os estados: vazio, carregando, erro, sucesso.
- Mobile primeiro (375px), depois 768 e 1280.
- Copy real em pt-BR no tom do DESIGN.md — sem lorem ipsum.

ANTES DE CODAR, me mostre em lista: seções da tela, componente de cada uma e de
onde vem (shadcn / 21st / novo). Espere OK.

DEPOIS DE CODAR, rode a skill web-design-guidelines sobre a tela e me traga
screenshot em 375 e 1280, claro e escuro.
```
