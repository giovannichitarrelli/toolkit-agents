#!/usr/bin/env bash
# Guarda noturna — roda os gates que o projeto JÁ TEM e deixa um relatório.
#
# Bash puro: não chama o agente, não gasta token. O agente só entra se o
# relatório ficar vermelho e você pedir.
#
# NÃO escreve em produção. Só checagem estática, teste local e um GET público.
#
# ── Como adaptar ──────────────────────────────────────────────────────────
# 1. Ajuste RAIZ e PATH abaixo.
# 2. Troque os `_gate` de exemplo pelos comandos REAIS do seu projeto.
#    Descubra-os: `cat package.json`, `cat Makefile`, `cat deno.json`.
#    Não copie lista decorada — gate que não existe vira vermelho eterno.
# 3. Agende: veja `instalar-launchd.sh` (macOS) ou use cron (Linux).

set -uo pipefail

# ── PLACEHOLDER: ajuste ────────────────────────────────────────────────────
RAIZ="[PLACEHOLDER: /caminho/absoluto/do/projeto]"
URL_PUBLICA="[PLACEHOLDER: https://seu-dominio.com]"   # deixe vazio para pular

# launchd e cron NÃO herdam o PATH do seu shell. Resolva os binários reais com
# `command -v node pnpm deno flutter` e cole os diretórios aqui.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# ───────────────────────────────────────────────────────────────────────────

GUARDA="$RAIZ/.guarda"
LOGS="$GUARDA/logs"
RELATORIO="$GUARDA/ultimo-relatorio.md"

mkdir -p "$LOGS"
rm -f "$LOGS"/*.log 2>/dev/null

vermelhos=(); verdes=(); pulados=()
inicio=$(date +%s)

# _gate <nome> <timeout_s> <diretório> <comando>
_gate() {
  local nome="$1" limite="$2" dir="$3" cmd="$4"
  local log="$LOGS/${nome//[^a-zA-Z0-9]/-}.log"

  if [ ! -d "$dir" ]; then
    pulados+=("$nome — diretório não existe: $dir")
    return
  fi

  # `alarm` do perl faz o papel do `timeout`, que o macOS não traz.
  ( cd "$dir" && /usr/bin/perl -e 'alarm shift @ARGV; exec @ARGV' "$limite" bash -c "$cmd" ) \
    >"$log" 2>&1
  local codigo=$?

  if [ $codigo -eq 0 ]; then
    verdes+=("$nome")
  elif [ $codigo -eq 142 ] || [ $codigo -eq 14 ]; then
    vermelhos+=("$nome|estourou o limite de ${limite}s|$log")
  else
    vermelhos+=("$nome|exit $codigo|$log")
  fi
}

# ── PLACEHOLDER: seus gates ────────────────────────────────────────────────
# Exemplos de projeto web (troque pelos reais):
_gate "web: typecheck"  300 "$RAIZ"  "npm run typecheck"
_gate "web: lint"       300 "$RAIZ"  "npm run lint"
_gate "web: test"       600 "$RAIZ"  "npm test"
_gate "web: build"      900 "$RAIZ"  "npm run build"

# Exemplo de backend Deno / edge functions:
# _gate "backend: check" 300 "$RAIZ/backend" "deno check functions/*/index.ts"
# _gate "backend: test"  300 "$RAIZ/backend" "deno test --allow-env functions/_shared/"
#   ⚠️ As flags de permissão do Deno importam. Teste que mexe em `Deno.env`
#      sem `--allow-env` morre com NotCapable e PARECE regressão — não é.

# Exemplo de app mobile:
# _gate "app: analyze" 300 "$RAIZ/app" "flutter analyze"
# _gate "app: test"    600 "$RAIZ/app" "flutter test"
# ───────────────────────────────────────────────────────────────────────────

# Provas de regressão — só leitura, seguras de repetir (skill provas-de-regressao)
if [ -x "$RAIZ/provas/rodar.sh" ] && [ -n "$(ls -A "$RAIZ/provas/leitura" 2>/dev/null)" ]; then
  _gate "provas: leitura" 600 "$RAIZ" "./provas/rodar.sh"
else
  pulados+=("provas: leitura — nenhuma prova gravada ainda")
fi

# Superfície pública no ar
if [ -n "$URL_PUBLICA" ] && [[ "$URL_PUBLICA" != \[PLACEHOLDER* ]]; then
  codigo_http=$(/usr/bin/curl -sS -o /dev/null -w '%{http_code}' \
    --max-time 20 "$URL_PUBLICA" 2>/dev/null || echo "erro")
  if [ "$codigo_http" = "200" ]; then
    verdes+=("público: $URL_PUBLICA (200)")
  else
    vermelhos+=("público: $URL_PUBLICA|devolveu '$codigo_http', esperado 200|—")
  fi
fi

# ── Relatório ──────────────────────────────────────────────────────────────
duracao=$(( $(date +%s) - inicio ))
if [ ${#vermelhos[@]} -eq 0 ]; then status="VERDE"; else status="VERMELHO"; fi

{
  echo "STATUS: $status"
  echo ""
  echo "# Guarda noturna"
  echo ""
  echo "\`$(date '+%d/%m/%Y %H:%M')\` · ${duracao}s · ${#verdes[@]} verde(s) · ${#vermelhos[@]} vermelho(s) · ${#pulados[@]} pulado(s)"

  if [ ${#vermelhos[@]} -gt 0 ]; then
    echo ""; echo "## Vermelho"
    for v in "${vermelhos[@]}"; do
      IFS='|' read -r nome motivo log <<< "$v"
      echo ""; echo "### $nome — $motivo"
      if [ -f "$log" ]; then echo ""; echo '```'; tail -n 15 "$log"; echo '```'; fi
    done
  fi

  if [ ${#pulados[@]} -gt 0 ]; then
    echo ""; echo "## Pulado"
    for p in "${pulados[@]}"; do echo "- $p"; done
  fi

  echo ""; echo "## Verde"
  for v in "${verdes[@]}"; do echo "- $v"; done
  echo ""; echo "Log completo de cada gate em \`.guarda/logs/\`."
} > "$RELATORIO"

[ ${#vermelhos[@]} -eq 0 ] && exit 0 || exit 1
