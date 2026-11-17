# TV Home Builder

Narzędzie do własnego ekranu głównego na Android TV / Google TV, zbudowane na
[Clean Your TV](https://github.com/Gathin23/cleanyourtv) i aplikacji
[cleanyourtv-app](https://github.com/udhaykumarbala/cleanyourtv-app).
Doprecyzowane zadanie, od którego to wyszło: [PROMPT.md](PROMPT.md).

> **Tylko Android TV / Google TV.** Telewizory LG (webOS), Samsung (Tizen) i Roku nie są obsługiwane —
> dla LG zobacz [`../lg-webos/`](../lg-webos/).

## Analiza: czy da się to zrobić samym repo?

**Tak, w dużej części.** `cleanyourtv-app` to aplikacja na telefon z Androidem, która przez ADB po Wi-Fi:
1. wyłącza reklamy i zbędne aplikacje (`pm disable-user`, nic nie jest odinstalowywane, jest punkt przywracania),
2. instaluje i ustawia jako domyślny ekran główny **launcher Clean Your TV** (`com.gathin.tvhome`),
3. pozwala z telefonu zmienić **dock** (kolejność aplikacji) i **„Look”** (gotowe style, własne zdjęcie, kilka przełączników).

Ograniczenia aplikacji:
- nowy ekran główny dostają tylko TV, na których społeczność potwierdziła, że podmiana przetrwa restart
  (większość Xiaomi, część Sony, TCL, Philips, Hisense…). Na większości Google TV, Fire TV i Androidzie ≤ 7
  aplikacja robi tylko czyszczenie, a ekran główny zostaje fabryczny;
- w aplikacji dostępna jest tylko część ustawień launchera.

**Pełna kontrola** jest w projekcie bazowym: launcher czyta motyw z pliku `config.json` (ok. 100 kluczy:
dock, ukryte aplikacje, kolumny, rzędy, kolory, tapety z rotacją, styl podświetlenia, pasek górny, zegar,
wygaszacz, przyciski pilota…) wysyłanego na TV skryptem `tools/theme.sh` — **bez przebudowy APK**.
Brakuje tylko wygodnego sposobu, żeby taki plik złożyć i zobaczyć efekt przed wysłaniem. To robi to narzędzie.

## Co jest w środku

| Plik | Do czego |
|---|---|
| `index.html` | Konfigurator w przeglądarce (offline, bez instalacji): ~50 najważniejszych opcji, podgląd ekranu TV na żywo, szablony, import/eksport `config.json`, ostrzeżenia o sprzecznych ustawieniach. |
| `list-apps.sh` | Wypisuje aplikacje z TV (nazwy pakietów) do `apps.txt` — do wklejenia w pola „Dock”, „Ukryte” itd. |
| `push-theme.sh` | Składa motyw (`themes/<nazwa>/`: `config.json` + tapeta) i wysyła go oficjalnym `tools/theme.sh`. `--reset` przywraca domyślny wygląd. |

Skrypty przy pierwszym uruchomieniu klonują `Gathin23/cleanyourtv` do `.cleanyourtv/` i tworzą tam
środowisko Pythona (`adb-shell`), więc nie potrzebujesz nawet binarki `adb`.

## Krok po kroku

**Wymagania:** TV z zainstalowanym launcherem Clean Your TV (przez aplikację na telefon albo `PROMPT.md`
projektu bazowego), włączone debugowanie sieciowe (ADB, port 5555), komputer z `git`, `bash` i Pythonem 3
w tej samej sieci Wi-Fi.

```bash
cd tv-home-builder

# 1. Nazwy aplikacji z TV (przy pierwszym połączeniu potwierdź na TV „Zezwól na debugowanie”)
./list-apps.sh 192.168.1.50

# 2. Otwórz index.html w przeglądarce, ustaw wygląd, kliknij „Pobierz config.json”

# 3. Wyślij na TV (ekran główny uruchomi się raz ponownie)
TV_HOST=192.168.1.50 ./push-theme.sh moj-motyw ~/Pobrane/config.json            # bez tapety
TV_HOST=192.168.1.50 ./push-theme.sh moj-motyw ~/Pobrane/config.json tlo.jpg    # jedna tapeta
TV_HOST=192.168.1.50 ./push-theme.sh moj-motyw ~/Pobrane/config.json ~/Zdjecia/tv  # folder = rotacja

# Cofnięcie do domyślnego wyglądu
TV_HOST=192.168.1.50 ./push-theme.sh --reset
```

Przy tapetach z folderu ustaw w konfiguratorze „Zmiana tapety co (min)” > 0. Duże zdjęcia najpierw zmniejsz:
`.cleanyourtv/tools/venv/bin/python -I .cleanyourtv/tools/wallpaper_prep.py ~/Zdjecia/tv ./male`
(wymaga `pip install -r .cleanyourtv/tools/requirements-photos.txt`).

## Bezpieczeństwo i ograniczenia

- Narzędzie zmienia **tylko wygląd launchera Clean Your TV**. Niczego nie wyłącza ani nie odinstalowuje.
- Nieznany lub błędny klucz w `config.json` launcher ignoruje, więc motyw nie może zepsuć ekranu głównego.
- Ustawienia zmienione później na samym TV (Ustawienia launchera) obowiązują do następnej wysyłki motywu.
- Podgląd w przeglądarce jest przybliżony (kafelki to kolorowe zastępniki banerów).
- Klucze spoza formularza (np. mapowanie przycisków pilota, wejścia HDMI) dopisz ręcznie do `config.json` —
  pełna lista: [`themes/README.md`](https://github.com/Gathin23/cleanyourtv/blob/main/themes/README.md).
  Import zachowuje tylko klucze obsługiwane przez formularz i wypisuje pominięte.
