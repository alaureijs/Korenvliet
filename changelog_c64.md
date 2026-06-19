# Changelog — C64 BASIC V2 port (`src/korenvliet.bas`)

## 2026-06-18

- Created standalone C64 BASIC V2 port `src/korenvliet.bas` (382 lines) from the
  original P2000T BASIC source at `docs/originals/korenvliet_p2000t.bas`

### P2000T → C64 translation

- `CHR$(12)` (form feed) → `CHR$(147)` (C64 clear screen)
- `CHR$(131)` (reverse on) → `CHR$(18)` (C64 RVS ON)
- `USR(0)` / `INP(0)` keyboard input → `GET` loops with `ASC()` conversion
- `ON ERROR GOTO` → removed (STOP key handled via `K=3` check)
- `DEFINT A-Z`, `DEFUSR`, P2000-specific `POKE`s → removed
- `INSTR` → manual string-scan subroutine at line 1400–1402
- `MID$(var)=value` → never used (input routine rebuilds strings via
  `LEFT$`+`CHR$`+`RIGHT$`)
- P2000 cursor positioning (`CHR$(4)`+row+col) → direct `POKE 211, col: POKE 214, row`
- `OUT80,1` sound → removed (replaced with FOR/NEXT delay where needed)
- P2000 colour/attribute `CHR$(130/133/134)` → omitted
- `CHR$(4)/CHR$(24)/CHR$(1)` cursor control → omitted
- `RND(PEEK(24592))` and `RND(5)` → `RND(1)`
- Added uppercase conversion of key input (line 102) so commands match strings

### Bug fixes

- **Missing GOTO after init**: original had `NEXT:GOTO670` at end of safe-code
  shuffle loop, port was missing the `GOTO670`, causing fall-through into
  subroutines and a `RETURN WITHOUT GOSUB` error — fixed by adding `55 goto670`
- **Cursor positioning**: changed from `POKE781,ve:POKE782,ho:POKE783,0:SYS65520`
  (unreliable KERNAL PLOT) to direct `POKE211,ho:POKE214,ve` (standard C64
  technique, sets zero-page cursor column/row directly)
- **FOR loop exits**: all early-jump paths in take, drop, examine, direction,
  afvoer, and winkel sections set `x=19:next` (or equivalent) before GOTO to
  prevent stack corruption from unclosed FOR loops
- **Line number limit**: renumbered `65430`–`65432` → `9000`–`9002` (C64 BASIC
  V2 max line number is 63999)

### Code style

- **Whitespace**: added spaces after all keywords, around operators, after
  commas, and between colon-separated statements for readability
- **Case**: all keywords and variables lowercased
- **DATA quoting**: all DATA entries containing whitespace quoted with `""`

### Build & tooling

- **Makefile**: added `make prg` target using `petcat -w2` to produce
  `korenvliet.prg` (tokenized C64 BASIC executable)
- **`.gitignore`**: added `*.prg` to exclude generated PRG files

### Preservation

- All 37 room names, 33 objects with flags, 3 exit directions per room,
  3 prefix strings, and 8 sewer-vent locations exactly as in P2000 DATA
- Original game logic, puzzles, map, and room descriptions verbatim
- No `ELSE` statements (C64 BASIC V2 does not support them)

### Known issues

- `STR$()` on C64 prepends a leading space for positive numbers;
  `RIGHT$(STR$(Z),2)` correctly extracts the 2-digit safe code
- `POS(0)` returns cursor column on C64 and is used for word-wrap at column 38

## 2026-06-19

- **Uppercase→lowercase conversion**: changed `k - 32` → `k + 32` (line 102)
   since all single-key checks expect lowercase PETSCII values
- **Instructions flow**: added `goto 1000` after `gosub 7500` (line 680) so
   instructions proceed to main game instead of falling through to j/n check
- **Stop prompt**: fixed line 9001 to loop until `j` is pressed instead of
   falling through to end unconditionally
- **Single-key input rewrite**: replaced `k = asc(k$)` / `k`-based comparisons
   with `p = asc(k$) and 127 : k$ = chr$(p)` / `k$`-based comparisons, matching
   the working pattern from `src/main.bas`:
   - `gosub 100` now returns the key character in `k$` instead of numeric `k`
   - Callers compare `k$="j" or k$="J"` etc. instead of `k=106`
   - Uppercase/lowercase handled by dual checks at each call site
   - Removed unused `ts` variable
- **Bare string after colon**: fixed 11 occurrences of `print "...": "..."`
   (valid P2000, syntax error in C64 BASIC V2) → `print "...": print "..."`
   in lines 2690, 3305, 6200, 7505–7560
- **Copyright message**: re-added original P2000 copyright block (lines
   65520-65525), renumbered to 8990-8995 to fit C64 max line number 63999:
   `Nat.Lab. P2000 Computer Club`, `programma nr 48`, `KORENVLIET`,
   `versie U6 dd 02-06-83`, `vrijgegeven dd 04-07-83`, `copyright Hans Pennings`
- **Centered title screen**: title and instructions prompt now vertically and
   horizontally centered using cursor positioning
- **SID beep**: replaced `chr$(7)` beeps with proper SID beep at lines 160/400-408
   (sets frequency, gate, envelope, delay, then gate off) — 4 call sites:
   line input overflow, invalid j/n, "ik begrijp u niet", stop prompt
- **GOSUB target line ordering**: moved SID beep body (lines 400-408) from
   after line 1402 to correct numeric position (between 195 and 670) to ensure
   C64 linked-list search finds the target
- **Cursor positioning**: switched from direct `poke 211,ho:poke 214,ve` to
   KERNAL PLOT via `poke 781,ve:poke 782,ho:poke 783,0:sys 65520` with bounds
   checking against `oc`/`ol`, matching `main.bas:110-114`

## 2026-06-19 (later)

### 80-column compliance

- **Cursor routine**: split line 6500 into 7 short lines (6500-6506) with
  bounds checking against `oc`/`ol` before KERNAL PLOT call
- **Instructions**: split lines 7500-7560 to one statement per line, all under
  80 columns
- **Initialisation**: split line 15 into 15-17 (`h$`, `j$`, `oc`, `ol` on 15;
  `dim` on 16; `l`, `i` on 17)
- **Backspace handler**: split line 132 into 132-133 (backspace check + PRINT
  CHR$(20) on separate lines)
- **Screen draw**: split lines 1000-1003 and 1010-1015 (location/exits display
  and FOR loop on separate lines)
- **Safe combination** (vault): split lines 7045-7048, 7070-7073, 7100-7107
  into one statement per line, all under 80 columns
- **Object DATA**: split original 2-line DATA block (8000-8180) into one
  group-of-3 per line (33 objects, lines 8000-8083), using gaps between
  original line numbers (8000-8002, 8005-8007, etc.)

### C64 BASIC V2 compatibility

- **`STRING$` removal**: replaced `STRING$(41, 42)` with
  `for x = 1 to 39: print "*";: next` in lines 7200-7201 and 7290-7291
  (`STRING$` is not available in C64 BASIC V2)
- **`SPC` removal**: removed `SPC(38)` from testament display lines 7210-7290
  (C64 has only 40 columns, not 80)
- **Direction-parsing split**: split line 1135's `g = len(c$) - 7` /
  `mid$(... "naar" ...)` logic into 1135-1137, then reverted to single line
- **Putdeksel OR chain**: split line 5230's long `OR` chain into 4 individual
  `IF` statements (5230-5233), each under 80 cols

### Bug fixes

- **Variable `k` overloading**: changed line-input temp from `k` to `t`
  (lines 130-135) — `k` was used both as the door-unlocked flag and as the
  ASCII temp in the line-input routine, meaning every command entry
  clobbered the door state and made the locked door at location 16
  permanently impassable
- **Putdeksel spacing**: restored trailing space after "putdeksel." in lines
   5230-5233 so "afvoer." appears on the same line
- **Variable `i` overloading**: renamed inventory count from `i` to `ic`
   (13 call sites) — `i` was used both as the inventory count and as the FOR
   loop counter in the `INSTR` replacement subroutine (`gosub 1400`, lines
   124-126), meaning any command containing `"panter"` would corrupt the
   carry-capacity count
- **Variable `h` overloading**: renamed space-position temp from `h` to `hp`
   in the drop routine (lines 2191-2195) — `h` was used both as the
   `balloon_built` flag and as a temp for finding the space in `"leg X"`,
   meaning dropping any item after building the balloon would corrupt the flag
- **Unclosed FOR loop in drop routine**: added `x = 19: next` before
   `goto 1000` at line 2280 — dropping a non-rubberboot item at water
   locations (28/29) leaked a FOR frame on the stack
- **"open boek/klok/tas" broken**: changed `g = len(c$) + 2` to
   `g = len(c$) - 5` at line 2845 — original P2000t bug where
   `RIGHT$(c$, g)` with `g > len(c$)` returned the full command instead of
   just the object name, never matching an object in the examine loop
