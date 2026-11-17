# Wspólne funkcje dla list-apps.sh i push-theme.sh. Nie uruchamiaj bezpośrednio.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPSTREAM="${CYT_DIR:-$HERE/.cleanyourtv}"
UPSTREAM_URL="https://github.com/Gathin23/cleanyourtv.git"

ensure_upstream() {
  if [ ! -f "$UPSTREAM/tools/theme.sh" ]; then
    echo ">> Pobieram oficjalne narzędzia Clean Your TV do $UPSTREAM" >&2
    git clone --depth 1 "$UPSTREAM_URL" "$UPSTREAM" >&2
  fi
  if [ ! -x "$UPSTREAM/tools/venv/bin/python" ] && [ ! -x "$UPSTREAM/tools/venv/Scripts/python.exe" ]; then
    echo ">> Tworzę środowisko Pythona (tools/venv)" >&2
    python3 -m venv "$UPSTREAM/tools/venv" >&2
    "$UPSTREAM/tools/venv/bin/pip" install -q -r "$UPSTREAM/tools/requirements.txt" >&2
  fi
  PY="$UPSTREAM/tools/venv/bin/python"
  [ -x "$PY" ] || PY="$UPSTREAM/tools/venv/Scripts/python.exe"
}

need_host() {
  if [ -z "${TV_HOST:-}" ]; then
    echo "Ustaw adres TV, np.: TV_HOST=192.168.1.50 $0 ..." >&2
    exit 2
  fi
}

tv() { (cd "$UPSTREAM/tools" && "$PY" -I tv.py "$@"); }
