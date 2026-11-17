# LG OLED65B46LA (webOS 24): własny ekran główny

## Doprecyzowany prompt

> **Oryginał:** „Sprawdź teraz integrację z GitHub. Poza tym na zdjęciu masz mój model TV.”
>
> **Wersja doprecyzowana:** Sprawdź, czy wypychanie na GitHub już działa, i wypchnij czekający commit.
> Na zdjęciu tabliczki znamionowej jest mój telewizor (LG OLED65B46LA, rocznik 2024, wyprodukowany 01/2025).
> Ustal, czy `tv-home-builder` (Clean Your TV) zadziała na tym modelu. Jeśli nie, opisz, co realnie da się
> zrobić z ekranem głównym tego TV: od ustawień fabrycznych, przez tryb dewelopera, po root — z ryzykiem
> każdej drogi. Nie zapisuj numeru seryjnego w repozytorium.

## Werdykt

**Clean Your TV i `tv-home-builder/` nie działają na tym telewizorze.** Seria B4 z 2024 r. ma system
**LG webOS 24**, a nie Android TV. Clean Your TV wymaga ADB i podmiany launchera Androida; na LG nie ma ani
jednego, ani drugiego (projekt sam odsyła właścicieli LG do strony
[cleanyour.tv/not-android](https://cleanyour.tv/not-android)).

**Aktualizacja:** istnieje projekt [clean-your-tv-lg-webos](https://github.com/Razdva122/clean-your-tv-lg-webos),
który daje własny ekran główny także **bez roota** (przez LG Developer Mode). Analiza i ryzyka:
[clean-your-tv-lg-webos.md](clean-your-tv-lg-webos.md).

Do wyboru są cztery drogi, od najbezpieczniejszej:

## 1. Ustawienia TV (bez ryzyka, 5 minut)

Nazwy menu mogą się nieco różnić zależnie od wersji oprogramowania.

| Co | Gdzie |
|---|---|
| Reklamy/promocje na ekranie głównym | Ustawienia → Wszystkie ustawienia → Ogólne → System → Ustawienia dodatkowe → Ustawienia ekranu głównego → **Promocja na ekranie głównym: Wył.** |
| Polecane treści | tamże → **Rekomendacje treści: Wył.** |
| Reklamy w wygaszaczu | Ustawienia → Ustawienia dodatkowe → **Promocja wygaszacza ekranu: Wył.** |
| Śledzenie / reklamy personalizowane | Ogólne → System → Prywatność (lub „Umowy użytkownika”): wyłącz **Live Plus / ACR**, reklamy oparte na zainteresowaniach i zgody na przetwarzanie danych oglądania |
| Kolejność i usuwanie aplikacji | Na ekranie głównym przytrzymaj OK na kafelku → **Edytuj**: przesuń, ukryj lub usuń aplikację |

## 2. Blokada reklam po DNS (bez roota, cała sieć)

Pi-hole lub AdGuard Home (albo AdGuard DNS w routerze) z listami blokującymi domeny reklamowe/telemetrii LG.
Usuwa część banerów i śledzenie bez dotykania TV. Uwaga: zbyt agresywna lista potrafi zepsuć aktualizacje
lub sklep LG — w razie problemów wyłącz blokadę dla adresu TV.

## 3. Clean Your TV for LG webOS, edycja No-root (umiarkowane ryzyko)

Własny launcher, kolejność aplikacji, dock i motywy przez Developer Mode, bez roota. Szczegóły i znane błędy:
[clean-your-tv-lg-webos.md](clean-your-tv-lg-webos.md).

## 4. Root + Homebrew Channel (pełna kontrola, ryzyko)

Dopiero root pozwala chować kafelki systemowe, wyłączać preinstalowane usługi i reklamy u źródła
(np. [webos-debloat](https://gist.github.com/lucataco/7c303b443934008a9031a55cfca552ec)) oraz instalować
aplikacje z [Homebrew Channel](https://reverseengineer.nl/en/projects/webos-homebrew-channel/).

Stan na listopad 2026:
- **Brak potwierdzonego exploita dla B4.** [chronomaly-webos](https://github.com/AnalyticETH/chronomaly-webos)
  (CVE-2025-38352) był testowany na C2, C4, C5, G4 — B4 nie ma na liście, a błąd zgłoszono LG w lutym 2026,
  więc nowsze oprogramowanie najpewniej go łata.
- [faultmanager-autoroot](https://github.com/throwaway96/faultmanager-autoroot) obsługuje webOS 4.0+, ale na
  webOS 24 bez telnetu; zależy od wersji firmware.
- RootMyTV i podobne starsze metody są w większości załatane.

Zanim spróbujesz: **wyłącz automatyczne aktualizacje** (Ogólne → Informacje o TV), sprawdź wersję
oprogramowania i porównaj ją z listami zgodności w repozytoriach powyżej. Root może naruszać warunki
gwarancji, a nieudana próba może wymagać przywrócenia ustawień fabrycznych.

## Czego nie da się zrobić

- Zainstalować launchera Clean Your TV ani innego launchera Androida.
- Usunąć reklam LG poza własnym launcherem bez roota (No-root zmienia tylko ekran główny).
