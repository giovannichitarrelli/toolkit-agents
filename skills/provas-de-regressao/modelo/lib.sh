#!/usr/bin/env bash
# Biblioteca das provas. Não edite por prova — se faltar algo, adicione aqui.
# Contrato de exit code: 0 = passou · 1 = FALHOU · 2 = não deu para provar.

set -uo pipefail

_falhas=0
_prova_nome="$(basename "${BASH_SOURCE[1]:-prova}" .sh)"

prova_requer_env() {
  local faltando=()
  for v in "$@"; do [[ -n "${!v:-}" ]] || faltando+=("$v"); done
  if ((${#faltando[@]})); then
    echo "SKIP  $_prova_nome — falta env: ${faltando[*]}" >&2
    exit 2
  fi
}

# Chamada PostgREST como usuário real. O Authorization manda; a apikey só identifica o projeto.
rest_como() { # rest_como <jwt> <método> <path> [body]
  local jwt="$1" metodo="$2" path="$3" body="${4:-}"
  local args=(-sS -X "$metodo" "${SUPABASE_URL}/rest/v1/${path}"
    -H "apikey: ${SUPABASE_ANON_KEY}" -H "Authorization: Bearer ${jwt}"
    -H "Content-Type: application/json" -H "Prefer: return=representation")
  [[ -n "$body" ]] && args+=(-d "$body")
  curl "${args[@]}"
}

rest_anon() { rest_como "$SUPABASE_ANON_KEY" "$@"; }

# service_role: SÓ para montar cenário e limpar. Nunca para provar que algo funciona.
setup_sql() {
  curl -sS -X POST "${SUPABASE_URL}/rest/v1/rpc/exec_sql" \
    -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
    -H "Content-Type: application/json" -d "$(jq -Rn --arg q "$1" '{q:$q}')"
}

conferir() { # conferir <descrição> <esperado> <obtido>
  if [[ "$2" == "$3" ]]; then
    echo "  ok   $1"
  else
    echo "  FALHA $1 — esperado <$2>, obtido <$3>"; _falhas=$((_falhas+1))
  fi
}

conferir_diferente() {
  if [[ "$2" != "$3" ]]; then echo "  ok   $1"
  else echo "  FALHA $1 — não deveria ser <$2>"; _falhas=$((_falhas+1)); fi
}

# Escrita se prova contando linha afetada ou relendo o efeito. error==null não é prova.
conferir_linhas() { # conferir_linhas <descrição> <mínimo> <json de resposta>
  local n; n=$(jq 'if type=="array" then length else 0 end' <<<"$3" 2>/dev/null || echo 0)
  if (( n >= $2 )); then echo "  ok   $1 ($n linhas)"
  else echo "  FALHA $1 — esperado >=$2 linhas, obtido $n"; _falhas=$((_falhas+1)); fi
}

registrar_teardown() { trap "$1" EXIT; }

encerrar() {
  if (( _falhas > 0 )); then echo "FALHOU $_prova_nome — $_falhas asserção(ões)"; exit 1; fi
  echo "PASSOU $_prova_nome"; exit 0
}
