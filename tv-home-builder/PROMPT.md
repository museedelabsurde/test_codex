# Doprecyzowany prompt

> **Oryginał:** „Sprawdź to repo (https://github.com/udhaykumarbala/cleanyourtv-app). Czy możemy stworzyć
> narzędzie, bądź użyć samego repo, aby dostosować ekran główny w TV wg własnego uznania?”

---

**Kontekst.** Mam telewizor z Android TV / Google TV. Chcę, żeby ekran główny wyglądał i działał tak, jak
ja chcę: własna kolejność aplikacji w docku, ukryte aplikacje, liczba kolumn, kolory, tapeta, zegar,
pasek górny — bez reklam i bez ponownego budowania czegokolwiek przy każdej zmianie.

**Zadanie.**

1. **Analiza.** Przeanalizuj `udhaykumarbala/cleanyourtv-app` oraz projekt, na którym bazuje
   (`Gathin23/cleanyourtv`, podmoduł `third_party/cleanyourtv`). Ustal:
   - jak podmieniany jest launcher (ekran główny) na TV i jakie są ograniczenia (które TV, wersje Androida),
   - co da się zmienić z poziomu samej aplikacji na telefon (dock, „Look”),
   - jaki jest mechanizm motywów (`config.json`, lista kluczy, sposób wysyłki na TV) i co daje ponad aplikację.
2. **Werdykt.** Odpowiedz krótko: czy wystarczy repo „jak jest”, czy warto dobudować narzędzie — i dlaczego.
3. **Narzędzie.** Jeśli warto, zbuduj w tym repozytorium (`tv-home-builder/`) lekkie narzędzie, które:
   - pozwala w przeglądarce, bez instalacji, ustawić najważniejsze opcje launchera z podglądem na żywo,
   - generuje poprawny `config.json` zgodny z `themes/README.md` (tylko klucze różne od domyślnych,
     z zakresami wartości z dokumentacji), z importem istniejącego pliku,
   - ma skrypty: listowanie aplikacji z TV przez ADB (żeby znać nazwy pakietów) oraz wysyłkę motywu
     na TV przez oficjalny `tools/theme.sh` (bez pisania własnej logiki zapisu na TV),
   - nie dotyka niczego poza launcherem Clean Your TV i daje prosty sposób cofnięcia (`--reset`).
4. **Bezpieczeństwo.** Żadnego wyłączania/odinstalowywania pakietów w tym narzędziu — to robi aplikacja
   lub `tools/disable.sh` z kopią zapasową. Wszystko odwracalne.
5. **Dokumentacja.** README po polsku: wymagania, krok po kroku, ograniczenia.

**Wynik.** Commit na gałęzi roboczej + krótkie podsumowanie po polsku.
