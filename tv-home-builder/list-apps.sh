#!/usr/bin/env bash
# Wypisuje aplikacje z TV (nazwy pakietów), żeby wkleić je do TV Home Builder.
# Użycie: ./list-apps.sh <IP_TV>     albo   TV_HOST=<IP_TV> ./list-apps.sh
# Wynik trafia też do apps.txt.
source "$(dirname "$0")/_common.sh"
[ $# -ge 1 ] && TV_HOST="$1"
need_host; export TV_HOST
ensure_upstream

echo ">> Aplikacje z ikoną na ekranie TV (LEANBACK_LAUNCHER):" >&2
RAW="$(tv 'cmd package query-activities --brief -a android.intent.action.MAIN -c android.intent.category.LEANBACK_LAUNCHER' 2>/dev/null || true)"
APPS="$(printf '%s\n' "$RAW" | grep -oE '^[[:space:]]*[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z0-9_]+)+/' | tr -d ' /' | sort -u || true)"
if [ -z "$APPS" ]; then
  echo ">> (TV nie obsługuje query-activities – pokazuję wszystkie włączone pakiety)" >&2
  APPS="$(tv 'pm list packages -e' | sed -n 's/^package://p' | tr -d '\r' | sort -u)"
fi
printf '%s\n' "$APPS" | tee "$HERE/apps.txt"
echo ">> Zapisano $(printf '%s\n' "$APPS" | grep -c .) pozycji do $HERE/apps.txt" >&2
