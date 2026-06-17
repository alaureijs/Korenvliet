# Korenvliet — Walkthrough

## Goal
Open de kluis van oom Wout in het landhuis Korenvliet en lees zijn testament.

## Inventory limit
Je kunt maximaal **4 voorwerpen** tegelijk dragen. Laat onnodige dingen vallen met `leg <voorwerp>`.

---

## Fase 1 — Voorbereiding (sportschoenen, bijl, boek, tas, snorkel, bril)

1. **Start** op locatie 9 (Hoofdstraat).
   `ga in supermarkt` → **10** (Supermarkt)

2. `koop sportschoenen` — neem object 11
   `koop bijl` — neem object 12
   *(`koop` omzeilt de winkeldiefstal-check)*

3. `ga uit` → **9** (Hoofdstraat)

4. `ga in landhuis` → **12** (Foyer)
   `zuid` → **13** (Huiskamer)
   `oost` → **14** (Studeerkamer)

5. `neem boek` — object 17, lees later voor ballon-recept

6. `bekijk klok` → "Er zit een duikbril in."
   `neem bril` — object 13 (zwembril)

7. `zuid` → **16** (Overloop)

8. `neem tas` — object 7 (grote tas)
   `bekijk tas` → "Er zit een snorkel in."
   `neem snorkel` — object 19

9. Ga terug naar de overloop (16) en bewaar de tas en snorkel voor later.

---

## Fase 2 — Joggen (afvallen voor het riool)

1. Ga naar het bos: **16** → `noord` → **14** → `west` → **13** → `noord` → **12** → `uit` → **9**
   `zuid` → **2** (Bos)

2. `ga trimmen` of `ga jog` (met sportschoenen in bezit) → w=1
   "Pfff... Klaar!" — je bent nu slank genoeg voor het riool.

3. Hak hout: `hak boom` of `snij bomen` met de bijl
   → houtblokken verschijnen op locatie 2
   `neem houtblokken` — object 4

---

## Fase 3 — de 6 ballon-onderdelen verzamelen

Voor de heteluchtballon heb je 6 voorwerpen nodig (objecten 1 t/m 6):

| Nr | Voorwerp | Locatie |
|----|----------|---------|
| 1  | ballon   | **3** (Weiland) |
| 2  | kachel   | **1** (Binnenplein) |
| 3  | mand     | **12** (Foyer) |
| 4  | houtblokken | **2** (Bos — na hakken) |
| 5  | koord    | **17** (Atrium) |
| 6  | lucifers | **15** (Tuinkamer) |

Oogst ze in deze volgorde:

1. **2** (Bos) → `neem houtblokken` (als je die net gehakt hebt)
2. **2** → `noord` → **9** (Hoofdstraat) → `ga in landhuis` → **12** (Foyer)
   `neem mand` — object 3
   `zuid` → **13** (Huiskamer) → `oost` → **14** (Studeerkamer) → `oost` → **15** (Tuinkamer)
   `neem lucifers` — object 6
3. Terug: **15** → `west` → **14** → `zuid` → **16** (Overloop)
   `west` → **17** (Atrium)
   `neem koord` — object 5
   `uit` → **1** (Binnenplein)
   `neem kachel` — object 2
4. **1** → `zuid` → **4** (Kanaalkant) → `west` → **3** (Weiland)
   `neem ballon` — object 1

Je hebt nu alle 6 onderdelen. Breng ze naar locatie **8** (Afgraving).

Route: **3** → `oost` → **4** → `noord` → **1** → `oost` → **2** → `oost` → **6** (Terrein) → `oost` → **7** (Rotspaadje) → `oost` → **8** (Afgraving)

`lees bord` op locatie 8 → "Een goede plaats." (bevestiging)

`bouw ballon` of `blaas ballon op` → de ballon is klaar (h=1).

*Optioneel: leg de mand en andere spullen die je niet nodig hebt op locatie 8.*

---

## Fase 4 — Rubberboot en de vijver

1. `neem rubberboot` — object 8 (ligt op locatie 1, Binnenplein)

   Route: **8** → `west` → **7** → `west` → **6** → `zuid` → **9** → (sla af)
   Of direct: **8** → `west` → **7** → `west` → **6** → `west` → **3** → `oost` → **4** → `oost` → **5** (Vijveroever)

2. `leg rubberboot` — leg boot op de oever
   `blaas boot op` → boot opgeblazen (r=1)

3. `ga in vijver` → **28** (Vijver)

4. `duik` — als je snorkel bij je hebt → **30** (Onder water)
   `zuid` → **31** (Water)
   `oost` → **32** (Ondergrondse stroom)
   `west` → **33** (Grot)

5. `neem fles` — object 16 (lege champagnefles)
   `bekijk fles` → "binnenin is een briefje met nummer <X>"
   (noteer dit getal — het is het eerste cijfer van de kluiscombinatie)

6. Terug: **33** → `oost` → **32** → `west` → **31** → `noord` → **30** → `uit` → **28** (Vijver)
   `noord` → **29** (Zuidbaai)
   `neem zalm` — object 14 (voor de panter)

---

## Fase 5 — Riool en wijnkelder

1. Ga naar **13** (Huiskamer in het landhuis):
   **29** → `noord` → **28** → `uit` → **5** (Vijveroever) → `west` → **4** → `noord` → **1** (Binnenplein)
   **1**: `ga in landhuis` → **17** (Atrium) → `noord` → **13** (Huiskamer)

   Of via Hoofdstraat: **9** → `ga in landhuis` → **12** → `zuid` → **13**

2. `verwijder deksel` → c1=1 (rooster in huiskamer open)

3. `ga in afvoer` → **21** (Riooluitlaat)

4. Riool navigeren naar locatie **27**:
   **21** → `zuid` → **22** (Rioolbocht)
   **22** → `oost` → **23** (Vertakking)
   **23** → `zuid` → **25** (Rioolbocht)
   **25** → `west` → **26** (Riooluitlaat)
   **26** → `omlaag` → **27** (Riooluitlaat)

5. `verwijder deksel` → c4=1 (rooster bij wijnkelder open)

6. `ga uit` → **18** (Wijnkelder West)

7. Panter voeren:
   `voer panter` of `geef zalm`
   → Panter ontsnapt met de zalm (v=1, panter weg)

8. `ga oost` → **19** (Wijnkelder Oost)
   `neem beker` — object 15
   `bekijk beker` → "binnenin is een briefje met nummer <Y>"
   (noteer — dit is het tweede cijfer)

9. `ga omhoog` → **20** (Trap)
   `ga door deur` → **16** (Overloop), deur is nu ontgrendeld (k=1)

---

## Fase 6 — Kluis openen

1. Op locatie **16** (Overloop):
   `bekijk schilderij` → "Er zit een kluis achter!" (e=1, kluis verschijnt)

2. `open kluis` of `maak kluis open`
   → kluis staat op locatie 16, vraagt om 3 getallen

   De combinatie staat op:
   - Briefje in de **fles** (gevonden in de grot) → eerste getal
   - Briefje in de **beker** (wijnkelder Oost) → tweede getal
   - Briefje op de **tafel** → derde getal (in de schuur op het plateau)

   Om bij de schuur te komen:
   - Ga met de heteluchtballon naar het plateau
   - `vlieg met ballon` of `zeil met ballon` op locatie 34 → **35** (Plateau-ballon)
   - `uit` → **36** (Plateau)
   - `ga in schuur` → **37** (Schuur)
   - `bekijk tafel` → "Er ligt een briefje met het nummer <Z>"
   (noteer — dit is het derde cijfer)

3. Voer de 3 getallen in bij de kluis.
   Als alle drie correct zijn: *"Klik........ Er zit een testament in."* (f=1)

---

## Fase 7 — Winnen

`lees testament` → het testament wordt getoond, gevolgd door **GEFELICITEERD!**
Het spel stopt.

---

## Belangrijke commando's

| Commando | Werking |
|----------|---------|
| `ga <richting>` | N=noord, O=oost, Z=zuid, W=west, U=uit, H=omhoog, L=omlaag |
| `neem <voorwerp>` | Pak iets op |
| `leg <voorwerp>` | Leg iets neer |
| `bekijk <voorwerp>` | Onderzoek iets |
| `inventaris` | Toon je bezittingen |
| `kijk` | Bekijk de omgeving opnieuw |
| `help` | Toon instructies |
| `koop <iets>` | Koop in de supermarkt (omzeilt diefstal-check) |

## Objectenoverzicht

| ID | Naam | Startlocatie |
|----|------|-------------|
| 1  | ballon | 3 — Weiland |
| 2  | kachel | 1 — Binnenplein |
| 3  | mand | 12 — Foyer |
| 4  | houtblokken | 40 → hak bomen in bos (2) |
| 5  | koord | 17 — Atrium |
| 6  | lucifers | 15 — Tuinkamer |
| 7  | tas | 16 — Overloop |
| 8  | rubberboot | 1 — Binnenplein |
| 9  | bord | 8 — Afgraving |
| 10 | visnet | 7 — Rotspaadje |
| 11 | sportschoenen | 10 — Supermarkt |
| 12 | bijl | 10 — Supermarkt |
| 13 | zwembril | 40 → in de klok (14) |
| 14 | zalm | 29 — Zuidbaai |
| 15 | beker | 19 — Wijnkelder Oost |
| 16 | fles | 33 — Grot |
| 17 | boek | 14 — Studeerkamer |
| 18 | schilderij | 16 — Overloop |
| 19 | snorkel | 40 → in de tas (16) |
| 25 | kluis | 40 → na bekijken schilderij op 16 |
| 26 | kist | 18 — Wijnkelder West |
| 30 | panter | 18 — Wijnkelder West |
