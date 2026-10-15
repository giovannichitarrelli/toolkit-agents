# Narração (vale para qualquer LINGUAGEM com VOZ ≠ sem)

Ferramentas já existem no motionmaxxing (`references/sound-sync.md`, `references/tools.md`). Aqui só as regras da marca.

## Roteiro da voz
- **Tamanho:** pt-BR a ~2,5 palavras/s. 15 s ≈ 35 palavras · 30 s ≈ 70 · 60 s ≈ 140. Passou? Diga e proponha cortar palavras **ou** aumentar a duração — não decida sozinho.
- Uma frase curta por beat, no TOM_DE_VOZ do brief. Escreva como fala, depois corte metade.
- Com INSTRUCAO_FINAL, a voz **é** a copy (literal onde houver aspas). Texto na tela não repete a voz palavra por palavra: mostra a palavra-chave da frase.
- NUNCA_DIZER vale para a voz igual ao texto.

## Voz
- `VOZ: locução` → narrador da marca, `--voice <nome|id>` com `eleven_multilingual_v2` (fala pt-BR com qualquer voz). Escolha pela energia e diga qual; gere 2 frases de teste antes do roteiro inteiro se o usuário não fixou a voz.
- Chave sem `voices_read` (comum em chave restrita): `voice.py voices` dá 401 e o `vo` cai na tabela de vozes prontas (padrão Brian). Para usar voz da biblioteca, o usuário passa o id.
- `VOZ: personagem` → só na LINGUAGEM `historinha`: uma voz por personagem, fixa no BRIEF (`PERSONAGENS`).
- Sem chave ElevenLabs: `voice.py vo-local` (macOS `say`) **só como rascunho de tempo**, e diga isso. Não entregue `say` como final.

## Execução
```bash
python3 "$SKILL/scripts/voice.py" vo --script film/vo.txt --out film/audio/vo.mp3
node "$SKILL/scripts/sync.mjs" film/audio/vo.words.json --fps 30 --lead 2 --out film/beats.json
python3 "$SKILL/scripts/mix.py" --duration <s> --vo film/audio/vo.mp3@0 --music film/audio/music.wav --duck --out film/audio/mix.wav
```
- **Com voz, o tempo segue a fala**, não o compasso: cada beat começa no `beats.json`; a música se ajusta (`music-fit`).
- Palavra na tela entra 0-2 quadros antes de ser ouvida.

## Legenda
`LEGENDA` padrão com voz = **sim, gravada no vídeo** (a maioria assiste Reels no mudo). Uma linha, ≤ 5 palavras por vez, da `vo.words.json`, posicionada fora da UI e do rosto. Legenda não conta como texto de cena para o lint (declare em NOTE.md).
