# 🖼️ Imagem

| | Ferramenta | Tipo | Para quê | Status |
|---|---|---|---|---|
| 🍌 | `nano-banana-2` ([inference.sh](https://github.com/inference-sh/skills)) | skill | Gemini 3.1 Flash Image: gerar, editar, até 14 imagens de referência | ✅ instalada |
| 🎨 | [Canva](https://www.canva.com) | conector MCP | Criar design, preencher template, exportar PNG/PDF, buscar designs seus | 🟢 recomendo |
| 🌀 | [Higgsfield](https://higgsfield.ai) | conector + CLI | Imagem com estética de campanha, mesmos créditos do vídeo | ✅ conectado |
| 🖌️ | `canvas-design` ([anthropics/skills](https://github.com/anthropics/skills)) | skill | Pôster e peça estática em PNG/PDF a partir de código, sem modelo generativo | 🟡 testar |

## 🧭 Qual usar

- **Peça de marca recorrente** (post, carrossel, story) → **Canva** com template.
  A identidade fica no template, não no prompt; o agente só preenche.
- **Imagem que não existe** (cena, produto em contexto, mockup) →
  **Nano Banana 2** ou **Higgsfield**.
- **Editar uma foto real** (trocar fundo, ajustar produto) → **Nano Banana 2**,
  passando a imagem como referência.
- **Arte tipográfica / layout preciso** → `canvas-design`. Modelo generativo erra
  texto; código não.

## 📦 Instalação

```bash
# 🎨 Canva — MCP remoto oficial, autentica por OAuth no primeiro uso
claude mcp add --transport http canva https://mcp.canva.com/mcp

# 🍌 Nano Banana 2 (e as demais skills da inference.sh)
npx skills add inference-sh/skills

# 🖌️ Skills de referência da Anthropic
npx skills add anthropics/skills
```

> [!NOTE]
> No Canva, gerar, editar e exportar funciona em qualquer plano. Redimensionar
> pede Pro; autofill de template e brand kit pedem Enterprise.

## 💬 Prompt para começar

```
Crie um carrossel de 5 slides para Instagram (1080x1350) sobre [TEMA], usando o
template [NOME] do meu Canva. Texto em pt-BR, no máximo 20 palavras por slide.
Se precisar de imagem que não existe no template, gere com Nano Banana 2 e me
mostre antes de inserir. Exporte em PNG.
```
