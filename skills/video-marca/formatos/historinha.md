# LINGUAGEM: historinha

Pessoas vivendo uma situação em que a marca resolve. Personagens **reais** (foto de banco gratuito) ou **gráficos** (ilustrados), animados em camadas (estilo quadrinho/motion comic) pelo runtime do motionmaxxing.

## Regras que não cedem
- **Pessoa de terceiro nunca entra no quadro.** Pinterest, Google, Instagram = só REFERENCIAS de pose, enquadramento, roupa e clima. Nada de recortar, decalcar ou passar foto de pessoa real como referência de rosto.
- **Personagem é personagem.** Nunca apresentar como usuário real, nunca depoimento ("eu usei e…") com nome e rosto inventados — é publicidade enganosa (CONAR/CDC).
- **Sempre pergunte ESTILO_PERSONAGEM: real ou gráfico.** Não existe padrão; não decida sozinho.
  - **Real** → foto de **Pexels ou Unsplash**, nada mais. Não gere pessoa realista (nem `nano-banana-2`, nem outro gerador).
  - **Gráfico** → Open Peeps (flat, 3D estilizado ou quadrinho, nas cores da marca).
- UI do app, logo e texto **nunca** são gerados: vêm de captura real ou do código, como no `motion-ui`.

## 1. Elenco (antes do storyboard)
Do brief: `PERSONAGENS` (até 3). Para cada um, fixe numa linha: idade aparente, estilo, roupa, um traço marcante, voz (se `VOZ: personagem`). Diversidade coerente com o PUBLICO.

Gráfico: gere a **ficha** de cada personagem: uma imagem com frente, 3/4, perfil e 3 expressões (neutro, surpreso, feliz), fundo liso. Real: a ficha é a **série de fotos** escolhida (ver 0b). Mostre as fichas ao usuário e **espere OK** — o rosto aprovado aqui é o rosto do vídeo inteiro.

## 2. Cenas
Para cada beat: um prompt de cena que **reusa a ficha como referência** + a mesma linha de estilo (paleta, luz, lente). Personagem e fundo em imagens separadas quando a cena tiver movimento de câmera (personagem com fundo transparente, ou recortado depois).

Fonte das pessoas, em ordem (as duas primeiras custam zero):
0a. **Open Peeps** (openpeeps.com, CC0): personagem ilustrado montado por partes — mesma cabeça/roupa em todas as cenas, troca só pose e expressão. Padrão para ESTILO_PERSONAGEM ilustrado. Recolorir nas cores da marca.
   Receita testada: `historinha-peeps.cjs` (react-peeps → SVG por cena, corpo inteiro, ficha fixa de cabelo/acessório/cor). Limites medidos:
   - **Pose carrega traço de corpo** (ex.: `ShirtBW` tem prótese de perna). Fixe por personagem as poses permitidas e confira cada uma na folha de contato — trocar pose pode trocar o personagem.
   - **Uma cor de preenchimento** pinta pele **e** calça. Use tom de pele real; a cor da marca vai no fundo, no celular e nos objetos — nunca no personagem (some no fundo roxo).
   - Poses de pé: Blazer, CrossedArms, Easing, PointingFinger, Resting, RoboDance, Shirt(Pants), Walking (BW/WB); sentadas: ClosedLeg, CrossedLegs, HandsBack, Medium, OneLegUp, Bike, Wheelchair. Rosto: 35 expressões (Tired, Awe, SmileBig, SmileLol, Concerned…).
   - Não segura objeto: o celular é camada própria sobre a mão (PointingFinger serve).
0b. **Pexels/Unsplash** — único caminho quando ESTILO_PERSONAGEM = real. Licença livre comercial, com limites:
   - **Mesma pessoa em todas as cenas** = mesma sessão de fotos (mesmo fotógrafo, mesmo modelo, mesma roupa). Procure pelo perfil do fotógrafo/coleção, não foto avulsa. Sem sessão com cenas suficientes → diga ao usuário e proponha menos cenas ou gráfico; não misture modelos parecidos.
   - A pessoa **vive a situação**, mas não fala: sem depoimento, sem fala em primeira pessoa, sem nome — a licença proíbe sugerir que ela endossa a marca. Voz = locução em terceira pessoa.
   - Registre em `film/cast/creditos.md` o link e o autor de cada foto.
Geração (paga, ~US$ 0,05–0,15/imagem, saldo em app.inference.sh): **nunca para pessoa real**; só para personagem gráfico com estilo próprio que o Open Peeps não cubra.
1. `nano-banana-2` (`belt app run google/gemini-3-1-flash-image-preview`, até 14 imagens de referência) — a única com consistência de rosto boa. Exige `belt login`; sem login, peça ao usuário `! belt login`.
2. `motionmaxxing/scripts/imagegen.py` (Codex) se instalado, com `refs` = ficha.
3. Canva `generate-image` + `remove-background`: sem referência, consistência fraca — só para fundos e objetos, nunca para o personagem.

Confira cada cena contra a ficha (rosto, cabelo, roupa). Divergiu → regere aquela cena, não o vídeo.

## 3. Animação (motionmaxxing)
- Camadas: fundo, personagem, objeto, UI. Parallax e câmera entre elas; personagem com respiração/balanço sutil, piscada, troca de expressão por corte (usa as 3 da ficha).
- A **tela do app aparece na mão ou no balão** do personagem — a marca entra na história, não depois dela. Prova = captura real (lei "mostre, depois diga").
- Fala de personagem: balão ou legenda; com `VOZ: personagem`, seguir `narracao.md`. Sem lip-sync (fica para formato de vídeo gerado, fora desta skill).
- ESTRUTURA padrão: situação (o problema na vida real) → virada (a marca na tela) → resultado (a pessoa vivendo o resultado) → CTA.

## 4. Entrega
Além do padrão: fichas aprovadas em `film/cast/`, lista de imagens geradas com prompt, e `film/cast/creditos.md` quando real.
