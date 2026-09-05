#!/usr/bin/env bash
# Roda a suíte de provas. Sem flag: só as de leitura (sempre seguras de repetir).
#   ./provas/rodar.sh                    todas as de leitura
#   ./provas/rodar.sh --escrita          leitura + escrita (escreve em PRODUÇÃO)
#   ./provas/rodar.sh --fluxo ingresso   só as provas cujo nome casa com o padrão

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

[[ -f .env ]] && set -a && . ./.env && set +a

com_escrita=0; padrao='*'
while (($#)); do
  case "$1" in
    --escrita) com_escrita=1 ;;
    --fluxo) padrao="*$2*"; shift ;;
    *) echo "flag desconhecida: $1" >&2; exit 64 ;;
  esac
  shift
done

alvos=(leitura/$padrao.sh)
((com_escrita)) && alvos+=(escrita/$padrao.sh)

passou=0; falhou=0; pulou=0; falhas=()
for p in "${alvos[@]}"; do
  [[ -f "$p" ]] || continue
  bash "$p"; c=$?
  case $c in
    0) passou=$((passou+1)) ;;
    2) pulou=$((pulou+1)) ;;
    *) falhou=$((falhou+1)); falhas+=("$p") ;;
  esac
done

echo
echo "provas: $passou passou · $falhou falhou · $pulou não deu para provar"
if ((falhou)); then
  printf 'REGRESSÃO em:\n'; printf '  %s\n' "${falhas[@]}"
  exit 1
fi
((com_escrita)) || echo "(provas de escrita não rodaram — use --escrita)"
exit 0
