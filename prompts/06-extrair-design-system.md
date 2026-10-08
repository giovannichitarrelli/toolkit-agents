# 🧬 Extrair o design system

Use no início de um projeto, ou quando cada tela está inventando a própria
paleta. É uma **entrevista**: o agente pergunta um bloco por vez e só gera
arquivo no fim. Tenha à mão a logo e 3 a 5 referências visuais.

Funciona para web (Next/Tailwind/shadcn) e app (Flutter) — o passo 6 adapta a
saída à stack que ele encontrar.

```
Você vai montar o design system deste projeto comigo, por entrevista.

REGRAS DA ENTREVISTA
- Uma rodada por vez, no máximo 4 perguntas por rodada. Espere minha resposta.
- Toda pergunta vem com opções concretas (A/B/C) + "outra". Nunca pergunta aberta
  do tipo "qual estilo você quer?".
- Se eu mandar imagem, EXTRAIA dela antes de perguntar: diga o que viu (hex,
  peso de fonte provável, raio, densidade) e peça só confirmação.
- O que eu não souber responder, você propõe e marca como [PROPOSTO].
- Não escreva nenhum arquivo antes da rodada 6.

RODADA 0 — LEVANTAMENTO (sem perguntar nada)
Leia o projeto: stack, tailwind.config / globals.css / theme.dart,
components.json, cores e fontes já em uso (grep por hex e font-family). Me
mostre o que já existe e o que está inconsistente (ex.: 7 tons de cinza soltos).

RODADA 1 — MARCA
- Me peça a LOGO (arquivo ou caminho). Extraia dela: cor primária, cores de
  apoio, se é geométrica/orgânica/serifada, e se funciona em fundo escuro.
- Nome do produto, público (quem é, idade, B2B ou B2C) e 3 adjetivos da marca.
- Concorrentes ou marcas que admira — e uma que NÃO quer parecer.

RODADA 2 — REFERÊNCIAS
- Me peça as referências (prints, links de Dribbble/Behance/Mobbin/sites).
- Para cada uma, diga em uma linha o que dá para aproveitar (cor, tipografia,
  densidade, tratamento de card, movimento) e pergunte se é isso que eu gostei.

RODADA 3 — COR
- Proponha paleta: primária, secundária, acento, neutros (escala 50–950),
  e semânticas (sucesso, alerta, erro, info), derivadas da logo.
- Light e dark mode. Mostre o contraste de cada par texto/fundo (AA ≥ 4.5).
- Pergunte: dark mode é obrigatório, opcional ou fora?

RODADA 4 — TIPOGRAFIA E FORMA
- 2 ou 3 pares de fonte (display + texto) do Google Fonts, com o porquê.
- Escala tipográfica (ex.: 12/14/16/20/24/32/48).
- Raio de borda: reto (0–4), suave (8–12) ou arredondado (16+/pill).
- Sombra: nenhuma, sutil, ou elevação marcada. Borda: com ou sem.
- Densidade: compacta (dashboard) ou arejada (landing/app de consumo).

RODADA 5 — VOZ E MOVIMENTO
- Tom de copy: formal, próximo, divertido? Você ou tu? Exemplo de botão
  primário e de mensagem de erro no tom escolhido.
- Movimento: nenhum, funcional (só transição de estado) ou expressivo.
- Ícones: Lucide (padrão), Phosphor, ou outro.

RODADA 6 — CONFIRMAÇÃO
Mostre o resumo completo numa tabela, com o que é [PROPOSTO] destacado. Só
depois do meu OK, gere:

1. TOKENS na stack real:
   - Tailwind v4 / shadcn → variáveis CSS em globals.css (`@theme` e
     `:root`/`.dark`), nomes compatíveis com o shadcn (--primary,
     --primary-foreground, --radius…).
   - Flutter → ThemeData + ColorScheme + TextTheme em lib/theme/.
   - Outra → JSON de tokens + instrução de onde plugar.
2. DESIGN.md na raiz: princípios (3–5 frases), paleta com hex e uso, fontes,
   escala, raio, sombra, espaçamento, tom de voz com exemplos, o que NÃO fazer.
3. Uma página/tela de amostra (/design ou DesignPreviewScreen) com todos os
   tokens aplicados: botões nos 4 estados, input, card, alerta, tipografia.
4. Uma linha no CLAUDE.md do projeto: "UI segue DESIGN.md; cor e espaçamento
   só por token, nunca hex/px solto."

Não substitua tokens existentes sem me mostrar o diff antes. Não commite.
```

## ✅ Depois

- Abra a página de amostra no navegador (claro **e** escuro) antes de aceitar.
- Daqui em diante, o `revisor-codigo` trata hex solto como achado.
- Para gerar telas presas a esses tokens: [`07-tela-a-partir-de-referencia`](07-tela-a-partir-de-referencia.md).
