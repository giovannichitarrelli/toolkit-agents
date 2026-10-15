# Narração (vale para qualquer LINGUAGEM com VOZ ≠ sem)

Ferramentas já existem no motionmaxxing (`references/sound-sync.md`, `references/tools.md`). Aqui só as regras da marca.

## Roteiro da voz
- **Tamanho:** pt-BR a ~2,5 palavras/s. 15 s ≈ 35 palavras · 30 s ≈ 70 · 60 s ≈ 140. Passou? Diga e proponha cortar palavras **ou** aumentar a duração — não decida sozinho.
- Uma frase curta por beat, no TOM_DE_VOZ do brief. Escreva como fala, depois corte metade.
- Com INSTRUCAO_FINAL, a voz **é** a copy (literal onde houver aspas). Texto na tela não repete a voz palavra por palavra: mostra a palavra-chave da frase.
- NUNCA_DIZER vale para a voz igual ao texto.

## Voz
- `VOZ: locução` → narrador da marca, `--voice <nome|id>` com `eleven_multilingual_v2` (fala pt-BR com qualquer voz). Escolha pela energia e diga qual; gere 2 frases de teste antes do roteiro inteiro se o usuário não fixou a voz.
- Chave sem `voices_read` (comum em chave restrita): `voice.py voices` dá 401 e o `vo` cai na tabela de vozes prontas (padrão Brian). Para usar voz da biblioteca, o usuário passa o id — e isso só funciona pelo conector (abaixo).
- `VOZ: personagem` → só na LINGUAGEM `historinha`: uma voz por personagem, fixa no BRIEF (`PERSONAGENS`).
- Sem chave ElevenLabs: `voice.py vo-local` (macOS `say`) **só como rascunho de tempo**, e diga isso. Não entregue `say` como final.

## Voz da biblioteca → conector ElevenLabs (obrigatório)
Voz da biblioteca (ex.: Mário `YU8EsJtXFMyKMxYtheDk`, Roberta `RGymW84CSmfVugnA5tvA`) **só sai pelo conector oficial da ElevenLabs no Claude**, não pela API com chave. A chave de conta gratuita bloqueia voz da biblioteca; o conector usa os Flows do app, que aceitam voz da biblioteca gastando créditos da conta conectada, sem plano Pro.
- **Antes de prometer a voz:** confira se a sessão tem `creative_generate_speech` (conector `ElevenLabs`). Não tem → pare e peça para conectar: claude.ai → Settings → Connectors, ou `+` → Connectors na sessão. Não caia em silêncio para a chave nem para voz pronta.
- **Fluxo:** `creative_create_flow` → `creative_generate_speech` (modelo `eleven_v4`, `voice_id` do usuário ou de `creative_list_voices`) → poll de `creative_get_flow_run_status` até concluir → baixar o áudio para `film/audio/vo.mp3`. Nunca repita a chamada de geração para "tentar de novo": cobra outra vez.
- **Ajuste que funcionou:** Stability ~45%, Similarity ~75%, Style baixo, Speaker boost ligado. Escreva como se fala o que sai errado ("Simples Vét", "I-A").
- **Custo:** ~13-16 créditos por segundo de fala (824 créditos para 64 s; 328 para ~20 s). Diga a estimativa antes de gerar narração longa.
- **Tempo:** o conector não devolve `vo.words.json`. Gere com `creative_transcribe_audio` ou separe as frases pelas pausas do áudio antes do `sync.mjs`.

## Execução
```bash
python3 "$SKILL/scripts/voice.py" vo --script film/vo.txt --out film/audio/vo.mp3  # só voz pronta; biblioteca → conector
node "$SKILL/scripts/sync.mjs" film/audio/vo.words.json --fps 30 --lead 2 --out film/beats.json
python3 "$SKILL/scripts/mix.py" --duration <s> --vo film/audio/vo.mp3@0 --music film/audio/music.wav --duck --out film/audio/mix.wav
```
- **Com voz, o tempo segue a fala**, não o compasso: cada beat começa no `beats.json`; a música se ajusta (`music-fit`).
- Palavra na tela entra 0-2 quadros antes de ser ouvida.

## Legenda
`LEGENDA` padrão com voz = **sim, gravada no vídeo** (a maioria assiste Reels no mudo). Uma linha, ≤ 5 palavras por vez, da `vo.words.json`, posicionada fora da UI e do rosto. Legenda não conta como texto de cena para o lint (declare em NOTE.md).
