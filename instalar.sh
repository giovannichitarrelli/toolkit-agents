#!/usr/bin/env bash
# Instala os agentes e as skills deste repositório em ~/.claude.
#
#   ./instalar.sh              mostra o que faria, sem tocar em nada
#   ./instalar.sh --aplicar    copia de verdade, com backup do que existir
#
# NÃO sobrescreve settings.json, CLAUDE.md nem RTK.md — esses são seus. O que
# está em templates/ é para você ler e adaptar à mão, não para ser copiado por
# cima de configuração existente.

set -uo pipefail

AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESTINO="${CLAUDE_HOME:-$HOME/.claude}"
APLICAR=0
[ "${1:-}" = "--aplicar" ] && APLICAR=1

if [ ! -d "$DESTINO" ]; then
  echo "não achei $DESTINO — o Claude Code está instalado?" >&2
  exit 1
fi

carimbo=$(date +%Y%m%d-%H%M%S)
BACKUP="$DESTINO/backups/toolkit-$carimbo"

novos=(); substituidos=()

_planejar() { # _planejar <origem> <destino-relativo>
  local origem="$1" rel="$2"
  local alvo="$DESTINO/$rel"
  if [ -e "$alvo" ]; then
    if diff -rq "$origem" "$alvo" >/dev/null 2>&1; then return; fi
    substituidos+=("$rel")
  else
    novos+=("$rel")
  fi
}

for f in "$AQUI"/agents/*.md; do
  _planejar "$f" "agents/$(basename "$f")"
done
for d in "$AQUI"/skills/*/; do
  _planejar "$d" "skills/$(basename "$d")"
done

echo "destino: $DESTINO"
echo ""
if [ ${#novos[@]} -gt 0 ]; then
  echo "NOVOS (${#novos[@]}):"
  printf '  + %s\n' ${novos[@]+"${novos[@]}"}
fi
if [ ${#substituidos[@]} -gt 0 ]; then
  echo "SUBSTITUÍDOS (${#substituidos[@]}) — o atual vai para o backup:"
  printf '  ~ %s\n' ${substituidos[@]+"${substituidos[@]}"}
fi
if [ ${#novos[@]} -eq 0 ] && [ ${#substituidos[@]} -eq 0 ]; then
  echo "nada a fazer — já está tudo igual."
  exit 0
fi

if [ $APLICAR -eq 0 ]; then
  echo ""
  echo "Isto foi só a prévia. Para aplicar:  ./instalar.sh --aplicar"
  exit 0
fi

mkdir -p "$BACKUP"
for rel in ${substituidos[@]+"${substituidos[@]}"}; do
  mkdir -p "$BACKUP/$(dirname "$rel")"
  cp -R "$DESTINO/$rel" "$BACKUP/$rel"
done

mkdir -p "$DESTINO/agents" "$DESTINO/skills"
cp "$AQUI"/agents/*.md "$DESTINO/agents/"
for d in "$AQUI"/skills/*/; do
  nome=$(basename "$d")
  rm -rf "$DESTINO/skills/$nome"
  cp -R "$d" "$DESTINO/skills/$nome"
done
find "$DESTINO/skills" -name "*.sh" -exec chmod +x {} \; 2>/dev/null

echo ""
echo "instalado."
[ ${#substituidos[@]} -gt 0 ] && echo "backup do que foi substituído: $BACKUP"
cat <<'FIM'

Falta a parte que NÃO é copiada automaticamente — leia e adapte à mão:

  templates/CLAUDE.md.template   →  ~/.claude/CLAUDE.md
  templates/RTK.md               →  ~/.claude/RTK.md
  templates/settings.json.example→  ~/.claude/settings.json
  templates/guarda-noturna/      →  um por projeto

Reinicie a sessão: agentes e settings são lidos no start.
FIM
