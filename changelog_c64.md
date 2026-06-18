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
