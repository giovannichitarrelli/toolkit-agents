# 🧭 Nichos — o mapa do "e agora, o que eu uso?"

Cada nicho é uma página autocontida: o kit, quando usar cada peça, instalação e
um prompt para começar.

| | Nicho | O que tem |
|---|---|---|
| 💻 | [Código](codigo.md) | Superpowers, ondas, provas, quality gates, Context7, Graphify, Supabase |
| 🎨 | [Design e UI](design-ui.md) | shadcn, 21st.dev, bibliotecas de componente, inspiração, boas práticas |
| 🎬 | [Vídeo](video.md) | Remotion, HyperFrames, Higgsfield, Veo/Seedance, ElevenLabs, claude-video |
| 🖼️ | [Imagem](imagem.md) | Nano Banana 2, Canva, Higgsfield, canvas-design |
| 🧪 | [Testes e navegador](testes-navegador.md) | Claude in Chrome, Playwright, agent-browser, DevTools MCP |
| ✍️ | [Conteúdo e SEO](conteudo-seo.md) | `seo-geo`, humanizer |
| 📄 | [Documentos](documentos.md) | docx, pdf, pptx, xlsx |
| ⚡ | [Automação](automacao.md) | n8n, guarda noturna, `/schedule` |

## 🚦 Preciso de… → faça isto

| Preciso de… | Comece por |
|---|---|
| 🆕 Feature nova | agente `planejador` → [fluxo](../02-fluxo.md) |
| 🐛 Consertar bug | skill `systematic-debugging` → `verificador` |
| 🗄️ Mexer em tabela, RLS, RPC | agente `arquiteto-dados` **antes** do código |
| 🚀 Publicar / deploy | `revisor-seguranca` + `verificador` |
| 🧬 Identidade visual de um projeto | prompt [`06-extrair-design-system`](../../prompts/06-extrair-design-system.md) |
| 🖥️ Tela ou landing nova | [Design e UI](design-ui.md) → prompt [`07`](../../prompts/07-tela-a-partir-de-referencia.md) |
| 👀 Referência visual | [Dribbble, Behance, Mobbin, Godly…](design-ui.md#-inspiração) |
| 🧱 Componente bonito pronto | [shadcn / 21st.dev / Magic UI](design-ui.md#-bibliotecas-de-componente) |
| 🎬 Vídeo de produto / demo | [Remotion ou HyperFrames](video.md) + narração ElevenLabs |
| ✨ Vídeo ou imagem gerados por IA | [Higgsfield / Veo](video.md) · [Nano Banana 2](imagem.md) |
| 📱 Post, carrossel, peça de marca | [Canva](imagem.md) com template |
| 🎙️ Narração, voz, efeito sonoro | [ElevenLabs](video.md#-instalação) |
| 👁️ Claude assistir / resumir um vídeo | [claude-video `/watch`](video.md) |
| ✍️ Artigo de blog | agente `seo-geo` → skill `humanizer` |
| 📄 Proposta, contrato, deck, planilha | [Documentos](documentos.md) |
| ⚡ Integrar sistemas sem código | [n8n](automacao.md) |
| 🧹 Repo bagunçado / herdado | prompt [`01-sanidade-do-projeto`](../../prompts/01-sanidade-do-projeto.md) |
| 🔥 Pilha de warnings de lint | skill `quality-gates` → prompt [burndown](../../prompts/vibe-coding-toolkit/02-eslint-warning-burndown.md) |
| 🐢 Site lento / requisição falhando | [Chrome DevTools MCP](testes-navegador.md) |
| 💸 Sessão cara | [Custo](../05-custo.md) · `/clear` ao trocar de assunto |
| 🔌 Ferramenta nova que vi por aí | [critério de entrada](../08-ferramentas.md#-como-testar-uma-ferramenta-) |
