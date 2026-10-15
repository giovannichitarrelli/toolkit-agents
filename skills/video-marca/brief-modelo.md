# Modelo de BRIEF — /video-marca

Preencha o que importa; o vazio é decidido e informado. Texto "entre aspas" é literal.

```
═══ 1. CONTEXTO ═══
MARCA:            [nome]
FONTE_DA_MARCA:   [URL | pasta de assets | "criar identidade"]
PRODUTO:          [app | site | SaaS | produto físico | serviço | evento]
TELAS_REAIS:      [caminho de screenshots | URL para capturar | "reconstruir pelo design system" | "sem UI"]

LINGUAGEM:        [motion-ui | historinha | texto-narrado | explicativo]

═══ 2. OBJETIVO ═══
OBJETIVO:     [lançamento do produto | lançamento de funcionalidade | apresentação institucional |
               campanha/promoção | teaser | tutorial | captação B2B]
PUBLICO:      [quem + onde assiste]
ACAO_DESEJADA:[baixar | lista de espera | visitar site | lembrar o nome | agendar demo]
EMOCAO:       [de ___ para ___]

═══ 3. FORMATO ═══
DURACAO:      [6 | 15 | 30 | 45 | 60 s]
FORMATO:      [9:16 | 1:1 | 4:5 | 16:9]
SOM:          [com som | pensado para o mudo]

═══ 4. TIPO E RITMO ═══
TIPO:         [animado/jovem | sério/premium | divertido | técnico | emocional]
ENERGIA:      [1-10]
VELOCIDADE:   [padronizada | acelerando | desacelerando | rampa]
CORTE_MINIMO: [2-15 quadros]
TRANSICOES:   [cortes secos | zoom/mergulho | chicote com borrão | objeto vira a próxima cena | misto]
RESPIRO:      [sim | não]

═══ 5. ESTILO VISUAL ═══
ESTILO:       [da marca | minimalista | colorido/pop | escuro | editorial | 3D]
CORES:        primária [#] · secundária [#] · fundo [#] · destaque [#]
FONTE:        [da marca | nome | "sugira"]
CAIXA:        [CAIXA ALTA | minúscula | frase normal | misto]
EFEITOS_SIM:  [confete | emoji | partículas | 3D | grão | borrão de movimento]
EFEITOS_NAO:  [...]

═══ 6. ROTEIRO ═══
ESTRUTURA:    [gancho→demo→CTA | problema→solução→prova→CTA | montagem→caso→CTA | contagem (teaser) | livre]
GANCHO:       [frase/imagem | "decida"]
CENAS:
  1. [ação na tela] | texto: "[...]" | tempo: [s]
  2. ...
PERSONAGENS:  [só historinha — até 3: idade · estilo · roupa · traço · voz]
ESTILO_PERSONAGEM:[ilustrado | 3D estilizado | quadrinho | fotorrealista (exige rótulo de IA)]
FIO_CONDUTOR: [objeto/caso que atravessa tudo | nenhum]
MOMENTO_HEROI:[cena principal]
CTA_FINAL:    [frases → logo]
TOM_DE_VOZ:   [informal | formal | gírias: ___ | proibidas: ___]
NUNCA_DIZER:  [números não confirmados, cidades, promessas, concorrentes]

═══ 7. SOM ═══
TRILHA:       [gênero + BPM | arquivo: caminho | sem música]
SFX:          [por ação | só momentos-chave | nenhum]
VOZ:          [sem | locução: tom ___ | personagem (historinha) | texto: "..."]
LEGENDA:      [gravada no vídeo | não]
CLIMAX:       [silêncio + impacto | crescendo | fade]

═══ 8. CONTROLE E ENTREGA ═══
APROVACAO:    [direto | storyboard antes | 6 quadros antes do render]
VERSOES:      [1 | 2-3 variando ___]
REFERENCIAS:  [links (Pinterest ok) + o que gosto neles — só estilo; pessoa de terceiro nunca entra no vídeo]
SAIDA:        [pasta/nome.mp4]
REVISAO:      [/watch + gates | só gates]

═══ 9. INSTRUÇÃO FINAL (manda em tudo) ═══
INSTRUCAO_FINAL: [a copy/ideia que o vídeo inteiro tem que contar, em texto livre.
                  O roteiro se adapta a ela, não o contrário. "Entre aspas" = literal na tela.]
```

## Exemplo mínimo

```
/video-marca MARCA: BAZI · OBJETIVO: lançamento de funcionalidade (Clube) · DURACAO: 15s
TIPO: animado/jovem · ENERGIA: 8 · MOMENTO_HEROI: cupom do Clube no ingresso
CTA_FINAL: "SÓCIO DO ROLÊ" → logo · APROVACAO: storyboard antes
```

## Exemplo com instrução final

```
/video-marca MARCA: BAZI · OBJETIVO: captação de organizador · DURACAO: 30s · ENERGIA: 8
INSTRUCAO_FINAL: imagina só o seu evento, sendo buscado em um app 100% nichado, pelo público
certo. só tem que ter certeza: VAI BOMBAR. A Bazi é o primeiro app de busca de eventos, e pra
criar seu evento na bazi É GRÁTIS. não perca tempo.
```

Vira, por exemplo: "imagina só o seu evento" (o evento do organizador nasce na tela) → busca no app
acha ele → "pelo público certo" (perfis chegando) → "VAI BOMBAR" (contador de interessados + confete)
→ "o primeiro app de busca de eventos" → "criar é GRÁTIS" (o botão de criar evento) → "não perca tempo" → logo.

## Exemplo historinha narrada

```
/video-marca MARCA: BAZI · LINGUAGEM: historinha · DURACAO: 30s · ENERGIA: 6
PERSONAGENS: Ana, 24, cabelo cacheado, jaqueta amarela · Léo, 26, boné, camiseta listrada
VOZ: locução, tom de amigo · REFERENCIAS: pinterest.com/... (cor e enquadramento)
INSTRUCAO_FINAL: sexta-feira, nenhum plano. abriu a BAZI. "BORA?"
```
