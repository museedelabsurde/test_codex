# Analiza: Razdva122/clean-your-tv-lg-webos

## Doprecyzowany prompt

> **Oryginał:** „A co z tym repo? Przeanalizuj jego działanie, sprawdź opinie użytkowników i potencjalne problemy / bugi.”
>
> **Wersja doprecyzowana:** Przeanalizuj https://github.com/Razdva122/clean-your-tv-lg-webos pod kątem mojego
> LG OLED65B46LA (webOS 24, rocznik 2024). Opisz: (1) jak działa — edycje, mechanizm przejmowania przycisku Home,
> wymagania; (2) dojrzałość projektu — wiek, aktywność, autorzy, testy; (3) opinie użytkowników na podstawie
> zgłoszeń na GitHubie — co działa, na jakich modelach; (4) powtarzające się błędy i ryzyka, ze szczególnym
> uwzględnieniem modeli z webOS 24 (C4, B4, QNED 2024) oraz odinstalowania; (5) werdykt: czy instalować,
> którą edycję i jak zminimalizować ryzyko. Podaj numery zgłoszeń jako dowody. Stan na 17.11.2026.

## Werdykt dla OLED65B46LA

**Można spróbować edycji No-root, ale traktuj ją jak wersję beta.** To jedyny znaleziony sposób na własny
ekran główny na tym TV bez roota (to poprawia wniosek z [README.md](README.md), który mówił, że bez roota się nie da).
B4 nie ma na liście potwierdzonych modeli, ale bliźniaczy C4 z webOS 24 działał u kilku osób
(z drobnymi problemami). Projekt ma niecały miesiąc i bardzo dużo zgłoszeń dotyczy instalacji i — co ważniejsze —
**odinstalowania**, więc warto mieć plan wyjścia przed startem.

## Jak to działa

- **Co robi:** instaluje własny launcher („Home”) jako aplikację webOS z wybranymi aplikacjami, kolejnością,
  dockiem i motywami (Classic, Liquid Glass, Ribbon + motywy społeczności). Nie usuwa reklam z innych ekranów LG
  i nie roota TV. Oparty na launcherze Clean Your TV (Gathin23) i `webos-vibehack`.
- **Edycja No-root:** wymaga aplikacji **Developer Mode** z darmowym kontem dewelopera LG. Usługa
  **Home Helper** na TV łączy się z TV przez lokalne API (SSAP) i przechwytuje przycisk Home, przekierowując
  go do launchera. Sesja Developer Mode wygasa — trzeba ją przedłużać ręcznie (opcjonalne automatyczne
  przedłużanie jest w becie i **nie zostało potwierdzone na prawdziwym TV**). Po wygaśnięciu LG może usunąć
  zainstalowane aplikacje.
- **Edycja Root:** dla TV już zrootowanych; natywne przekierowanie Home i niezależne odzyskiwanie.
  Dla B4 nieistotna (brak znanego roota, patrz [README.md](README.md)).
- **Instalator:** aplikacje na Windows, macOS, Linux i Android (ARM64), oparte na Pythonie (`cytv`).
- **Wyjście awaryjne:** 3× Home w ciągu 2 s zatrzymuje przechwytywanie i wraca do LG Home.

## Dojrzałość projektu

| | |
|---|---|
| Pierwszy commit | 22.10.2026 (ok. 4 tygodnie) |
| Commity / wydania | ~2360 commitów, 67 tagów, aktualnie v1.23.0 (wydana 17.11.2026) |
| Autorzy | praktycznie jedna osoba (RazDva122 + konto „Dmitrii”), kilku drobnych kontrybutorów |
| Sposób pracy | duża część pracy wykonywana z agentami AI (setki commitów z gałęzi `codex/…`), rozbudowane testy i dokumentacja |
| Zgłoszenia | 182 issues w miesiąc; autor odpowiada szybko i szczegółowo |

Tempo jest ogromne (kilka wydań dziennie). To plus — błędy są szybko łatane — i minus: dokumentacja jest
przeładowana szczegółami wersji, a niektóre ścieżki (aktualizacje, odzyskiwanie) zmieniały się wielokrotnie.

## Opinie użytkowników

**Potwierdzone działające (z listy projektu):** m.in. OLED G1/B1 (webOS 6), C2, OLED55G36LA, OLED55B36LA,
OLED83G36LA, OLED65C3, C3 z webOS 26, C5 77″, NANO 2025, kilka starszych UK/UM (webOS 4–4.5).
Pozytywne zgłoszenia: #473, #406, #495, #653, #654.

**Najbliżej Twojego TV (webOS 24):**
- OLED55C46LA (C4): launcher i krótki Home działają; długie Back na chwilę pokazuje LG Home; po wyłączeniu
  pilotem launcher pojawia się ~33 s po starcie (wcześniej przez moment LG Home). Poprawki czekają na weryfikację na C4.
- OLED65C44LA (C4, #282): instalacja przeszła, ale nie dało się ustawić Home (edycja Root).
- 65QNED80T (webOS 24, 1,25 GB RAM, #10): launcher zamykał się po 0,3–4 s — naprawione.
- **B4 (OLED65B46LA): brak jakiegokolwiek zgłoszenia.** Twój raport byłby pierwszy.

## Powtarzające się problemy

1. **Odinstalowanie i odzyskiwanie** — najczęstsza kategoria (52 zgłoszenia ze słowem „uninstall”).
   Usuwanie zatrzymuje się w stanie `restart-required`/`recovery-required`, czasem po resecie fabrycznym
   blokuje je zmieniona tożsamość SSH (#664, #643, #472 — 43 komentarze, #469, #678).
2. **Wyścig z LG Home** — po starcie TV lub powrocie z aplikacji przez chwilę wygrywa LG Home
   (#500 Disney+, #687, #422); pierwszy Home z aplikacji potrafi trafić do LG Home.
3. **Home Helper przestaje działać** po wyłączeniu TV lub na starszym webOS (#487, #414, #599, #686 —
   Helper wielokrotnie przerzuca z YouTube do Home po starcie).
4. **Instalacja przerywana na kontrolach** — brak miejsca, uprawnienia katalogów zmieniane przez Developer Mode,
   niezgodne Node.js (#434, #409, #390, #653, #284, #311).
5. **Pilot** — przytrzymanie OK otwiera aplikację zamiast przenosić kafelek (#646); standardowy pilot IR
   bez Magic Remote nie zawsze jest wykrywany (#304).
6. **Przypadkowe 3× Home** wyłącza przechwytywanie; wznowienie wymaga ręcznej akcji w Home Helper (#664).
7. **Dźwięk HDMI / wejścia** — fałszywe „Connected” przy pustych HDMI (#627); eksperymentalne odzyskiwanie
   dźwięku jest domyślnie wyłączone.

## Ryzyka

- **Developer Mode:** wygaśnięcie sesji może usunąć launcher; trzeba pilnować licznika. Konto LG dewelopera
  i aplikacja z oficjalnego sklepu — to legalna, wspierana przez LG ścieżka.
- **Nie usuwa reklam LG** poza swoim ekranem; ustawienia z [README.md](README.md) nadal warto zmienić.
- **Kod z sieci z dostępem do TV:** instalator łączy się z TV przez SSH Developer Mode. Projekt jest open-source
  (MIT), ale bardzo młody i rozwijany głównie przez jedną osobę.
- **Nie instaluj Developer Mode na zrootowanym TV** (projekt wprost tego zabrania).

## Jak zminimalizować ryzyko (zalecana kolejność)

1. Najpierw [demo w przeglądarce](https://razdva122.github.io/clean-your-tv-lg-webos/demo/) — bez instalacji.
2. Zmień ustawienia reklam z [README.md](README.md) niezależnie od wszystkiego.
3. Załóż konto LG Developer, zainstaluj Developer Mode ze sklepu LG, zanotuj licznik sesji.
4. Instalator ze strony Releases (najnowszy stabilny), edycja **No-root**. Zachowaj pliki odzyskiwania.
5. Od razu przetestuj: Home, Back, wyjście z aplikacji, 3× Home, wyłączenie i włączenie pilotem,
   pełne odłączenie zasilania. Dopiero potem używaj na co dzień.
6. Przed aktualizacją firmware LG zajrzyj do `docs/LG-FIRMWARE-UPDATES.md` w repo.
7. Przy problemach: `docs/RECOVERY.md`; zgłoszenie na GitHubie bez numeru seryjnego.
