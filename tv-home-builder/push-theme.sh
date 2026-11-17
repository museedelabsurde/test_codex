#!/usr/bin/env bash
# Wysyła motyw na TV oficjalnym skryptem tools/theme.sh z Clean Your TV.
#
# Użycie:
#   TV_HOST=<IP> ./push-theme.sh <nazwa> <config.json> [wallpaper.jpg | folder_z_tapetami]
#   TV_HOST=<IP> ./push-theme.sh <istniejący_folder_motywu>
#   TV_HOST=<IP> ./push-theme.sh --reset          # przywraca domyślny wygląd launchera
#
# Motyw jest składany w themes/<nazwa>/ obok tego skryptu (config.json + wallpaper.jpg lub wallpapers/).
# Skrypt zmienia tylko wygląd launchera Clean Your TV; niczego nie wyłącza ani nie odinstalowuje.
source "$(dirname "$0")/_common.sh"
need_host; export TV_HOST

if [ "${1:-}" = "--reset" ]; then
  ensure_upstream
  exec "$UPSTREAM/tools/theme.sh" --reset
fi

[ $# -ge 1 ] || { sed -n '2,10p' "$0" >&2; exit 2; }

if [ -d "$1" ] && [ $# -eq 1 ]; then
  THEME="$(cd "$1" && pwd)"
else
  NAME="$1"; CONFIG="${2:-}"; WP="${3:-}"
  [[ "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "Nazwa motywu: małe litery, cyfry i myślniki (np. moj-motyw)." >&2; exit 2; }
  [ -f "$CONFIG" ] || { echo "Nie ma pliku config.json: '$CONFIG'" >&2; exit 2; }
  python3 -c 'import json,sys; o=json.load(open(sys.argv[1])); assert isinstance(o,dict)' "$CONFIG" 2>/dev/null \
    || { echo "$CONFIG nie jest poprawnym obiektem JSON." >&2; exit 2; }
  THEME="$HERE/themes/$NAME"
  mkdir -p "$THEME"
  cp "$CONFIG" "$THEME/config.json"
  rm -rf "$THEME/wallpaper.jpg" "$THEME/wallpapers"
  if [ -n "$WP" ]; then
    if [ -d "$WP" ]; then
      mkdir -p "$THEME/wallpapers"
      find "$WP" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -exec cp {} "$THEME/wallpapers/" \;
      echo ">> Skopiowano $(ls "$THEME/wallpapers" | wc -l) tapet. Ustaw w konfiguratorze 'Zmiana tapety co' > 0." >&2
    elif [ -f "$WP" ]; then
      cp "$WP" "$THEME/wallpaper.jpg"
    else
      echo "Nie znaleziono tapety: '$WP'" >&2; exit 2
    fi
    echo ">> Wskazówka: duże zdjęcia zmniejsz przez $UPSTREAM/tools/wallpaper_prep.py (1280x720, <300 KB)." >&2
  fi
fi

ensure_upstream
echo ">> Wysyłam $THEME na $TV_HOST (ekran główny uruchomi się ponownie)" >&2
exec "$UPSTREAM/tools/theme.sh" "$THEME"
