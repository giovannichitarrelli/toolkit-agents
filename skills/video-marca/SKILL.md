---
name: video-marca
description: Gera vídeo de marca (lançamento, funcionalidade, teaser, apresentação, campanha) a partir de um brief com variáveis — formato (motion de UI, historinha com personagens, texto narrado, explicativo), narração, objetivo, energia, estilo, roteiro, CTA, trilha. Pergunta só o que falta, monta o BRIEF e executa pela skill motionmaxxing. Use quando o usuário digitar /video-marca, ou pedir "um vídeo como aquele", "vídeo de lançamento", "teaser", "vídeo para Reels/TikTok" de qualquer marca.
---

# /video-marca

Transforma pedido + variáveis num BRIEF fechado e chama a skill `motionmaxxing` para produzir (runtime próprio em HTML/GSAP, render pelo Chrome + ffmpeg — não é Remotion nem HyperFrames). O papel desta skill é **controle**: nada que o usuário fixou pode mudar; o que ele não fixou é decidido e dito.

## 1. Ler o que veio

Os argumentos podem vir como o modelo de `brief-modelo.md` (preenchido total ou parcialmente), como texto livre, ou vazios. Extraia cada variável que já estiver dita — inclusive implícita ("rápido e jovem" = TIPO animado/jovem, ENERGIA ~8). Texto entre aspas é **literal**: não reescreva.

Se o projeto atual tiver contexto de marca (CLAUDE.md, design system, memória com vídeo aprovado — ex. BAZI v2), use-o como padrão das variáveis vazias e diga isso.

## 1b. Escolher a LINGUAGEM

| LINGUAGEM | Quando | Fluxo |
|---|---|---|
| `motion-ui` (padrão) | mostrar o produto funcionando | este arquivo + motionmaxxing |
| `historinha` | pessoas numa situação que a marca resolve; emocional, captação de usuário | `formatos/historinha.md` |
| `texto-narrado` | manifesto, ideia forte, pouca UI | `formatos/texto-narrado.md` |
| `explicativo` | "como funciona", passo a passo, conceito | skill `hyperframes:faceless-explainer`, com o BRIEF como entrada |

Leia o arquivo do formato escolhido **antes** de perguntar. Qualquer `VOZ` ≠ sem → leia também `formatos/narracao.md`.

## 2. Perguntar só o que falta (no máximo 2 rodadas)

As obrigatórias — sem elas não comece: **MARCA/FONTE_DA_MARCA, OBJETIVO, LINGUAGEM, DURACAO+FORMATO, TIPO+ENERGIA, CTA_FINAL**.
As de peso alto — pergunte se faltarem: **VOZ** (se SOM = com som), **VELOCIDADE, MOMENTO_HEROI, TELAS_REAIS, TRILHA, INSTRUCAO_FINAL** (esta com a opção "sem instrução final"); em `historinha`, também **PERSONAGENS** e **ESTILO_PERSONAGEM**.
Todo o resto: decida pelo padrão abaixo, sem perguntar.

Use a ferramenta de perguntas (até 4 por chamada, opções concretas, a recomendada primeiro). Uma rodada para as obrigatórias, no máximo mais uma para as de peso alto. Nunca pergunte o que dá para descobrir lendo o projeto ou o site.

## 3. Padrões quando a variável fica vazia

| Variável | Padrão |
|---|---|
| LINGUAGEM | motion-ui (se o pedido não falar de pessoas, voz ou explicação) |
| VOZ | sem · `texto-narrado` → locução · `historinha` → locução (personagem só se pedido) |
| LEGENDA | com voz → gravada no vídeo · sem voz → não |
| ESTILO_PERSONAGEM | ilustrado nas cores da marca |
| FORMATO | 9:16 |
| DURACAO | 30 s (teaser 15 s) |
| ENERGIA | animado/jovem → 8 · sério → 4 · emocional → 3 |
| VELOCIDADE | energia ≥ 7 → acelerando · ≤ 4 → padronizada |
| CORTE_MINIMO | energia 8+ → 4 f · 5-7 → 8 f · ≤ 4 → 15 f |
| TRANSICOES | energia ≥ 7 → misto (chicote, mergulho, objeto que vira cena) · senão cortes secos + mergulho |
| ESTILO / CORES / FONTE | extraídos da marca (site ou design system); fonte de título = a do logo |
| ESTRUTURA | teaser → montagem → foco → contagem · lançamento → montagem rápida → caso real → CTA · feature → problema → feature em uso → CTA |
| FIO_CONDUTOR | um caso real (um evento, um pedido, um usuário) atravessa as cenas |
| SFX | um por ação na tela |
| CLIMAX | silêncio curto + impacto no logo |
| APROVACAO | storyboard antes do render quando DURACAO ≥ 30 s ou ≥ 5 cenas · `historinha` → fichas dos personagens antes de tudo |
| VERSOES | 1 |
| SAIDA | `~/Downloads/<MARCA>-<objetivo>-<duração>s-<formato>.mp4` |
| REVISAO | /watch (modo local) + gates do motionmaxxing |

## 4. Escrever o BRIEF

Grave `BRIEF.md` na pasta do filme (scratchpad da sessão, ou onde o usuário indicar) com TODAS as variáveis do modelo, marcando cada uma como **[usuário]** ou **[decidido: motivo em 5 palavras]**. Mostre ao usuário só as linhas **[decidido]** numa lista curta — é onde ele corrige.

## 5. Encaixar a INSTRUCAO_FINAL (último passo antes de produzir)

Se veio INSTRUCAO_FINAL, ela é a **espinha do roteiro** e vence qualquer variável [decidido] — e também ESTRUTURA, CENAS e CTA_FINAL se conflitarem (diga qual cedeu). O vídeo se adapta à copy, nunca o contrário:

1. **Quebre a copy em frases-beat**, na ordem em que foi escrita. Cada frase vira um beat; não reordene nem pule.
2. **Para cada frase, a imagem que a prova** (lei "mostre, depois diga"): "seu evento sendo buscado" = a busca achando o evento na tela; "público certo" = perfis chegando; "VAI BOMBAR" = interessados subindo + o efeito da energia; "É GRÁTIS" = o botão de criar evento. Nunca uma frase sobre fundo vazio.
3. **Texto na tela:** o que veio "entre aspas" é literal; o resto pode ser enxugado para caber no tempo de leitura, sem mudar o sentido nem o tom. CAIXA ALTA da copy = ênfase (palavra maior, impacto de som); minúsculas ficam minúsculas.
4. **Tempo:** distribua a DURACAO pelas frases segundo o peso de cada uma; a frase em CAIXA ALTA ou com a promessa principal recebe o momento herói. Se a copy não couber na duração, diga e proponha: cortar quais palavras **ou** aumentar a duração. Não decida sozinho.
5. **Afirmações da copy** ("o primeiro app", "grátis", números) entram como o usuário escreveu, mas liste-as na entrega como "afirmação do usuário, não conferida".
6. **Mostre a tabela frase → beat → imagem → tempo** junto com as linhas [decidido]. Se APROVACAO pedir storyboard, pare aqui e espere OK.

## 6. Executar

Invoque a skill `motionmaxxing` passando o BRIEF inteiro como argumento e siga-a até o fim (captura de marca, storyboard, build, gates, NOTE.md). Regras que esta skill acrescenta:

- **Variáveis [usuário] são contrato.** Se o motionmaxxing recomendar outra coisa (ex. menos confete), aplique o que o usuário pediu e anote a divergência na entrega — não troque.
- **ENERGIA → números.** 8-10: palavras 4-10 f, emoji/adesivo com pop, chicote entre cenas, um efeito de partícula no máximo em 3 momentos. 4-7: palavras 8-15 f, mergulhos, sem partícula salvo pedido. 1-3: cortes longos, câmera lenta, tipografia contida.
- **TELAS_REAIS:** captura real > reconstrução pelo design system > desenho. Toda reconstrução é declarada na entrega. Nunca usar imagem de terceiro (flyer, logo de outra marca) sem direito.
- **Formato:** siga o arquivo da LINGUAGEM; as regras dele valem por cima das do motionmaxxing (ex.: personagem gerado é permitido em `historinha`, declarado).
- **Voz e trilha:** com `ELEVENLABS_API_KEY`, `voice.py` gera locução, música e SFX (`formatos/narracao.md`); com voz, o tempo segue a fala. Sem chave: trilha sintetizada no gênero/BPM pedido, com cortes no grid de compasso, e dizer que é sintetizada.
- **VERSOES ≥ 2:** variar só a variável indicada; abrir o blind review do motionmaxxing para a escolha; registrar a escolha em `taste/verdicts.md`.

## 7. Entregar

Copie o MP4 para SAIDA e responda curto, em pt-BR:
1. caminho do arquivo;
2. roteiro em tabela (tempo · o que acontece);
3. o que foi **decidido** por você, o que é **real vs reconstruído vs gerado** (imagens de IA com prompt) e as afirmações da INSTRUCAO_FINAL não conferidas; com pessoa realista gerada, o aviso de rótulo "feito com IA" para Meta/TikTok;
4. o que conferir (ouvir a trilha; o que o /watch não vê).

Ao final, ofereça ajustar por variável ("quer ENERGIA 6? CTA diferente?") — o próximo pedido pode ser só a variável que muda.
