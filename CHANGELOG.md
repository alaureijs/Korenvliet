# Changelog

## 2026-06-18

- Restored "kijk" command (redisplays current location, reverting the earlier removal)
- Fixed grammar in room 21 description: "van een riool" → "van het riool" (matches original)
- Simplified safe code generation: removed dead `ss[]`/`sflags[]` shuffling and debug prints
- Fixed "open boek"/"open klok"/"open tas" — original P2000 had a bug where
  `G = LEN(C$)+2` made `RIGHT$` return the whole command, never matching an object
- Removed sentinel `-2` pattern: `cmd_enter`/`cmd_examine` no longer return `-2`
  for "not my command"; callers strip prefixes before calling
- Replaced 26 remaining inline `printf("Ik begrijp U niet.\n"); return 1;`
  with `return fail()` — only 1 copy remains (inside `fail()` itself)
- Replaced all bare numeric returns with named constants (`RET_EXIT`, `RET_REDRAW`,
  `RET_KEEP`) — fixed `generic_take_item` returning `-1` (would exit game)
- Fixed buffer overflow in `cmd_open_safe`: truncate input to 15 chars before
  `strcpy` into the 16-byte `f1`/`f2`/`f3` buffers
- Fixed `xsnprintf` to respect `size` parameter: format into temp buffer, then
  bounded `memcpy` with null termination
- Replaced magic numbers in atmospheric probability thresholds with named constants
  (`ATMOS_R6_ADRIAAN`, `ATMOS_R3_ZOETE`, `ATMOS_R7_BEREND`, `ATMOS_R33_BAT`,
  `ATMOS_R27_SPINRAG`, `ATMOS_R25_RAT`, `ATMOS_R4_PAD`, `ATMOS_R28_GULL`,
  `ATMOS_R2_APEN`) — also replaced `rand_range(1, 10)` with `ATMOS_RNG_MAX`
- Replaced balloon altitude animation magic numbers with named constants
  (`BALLOON_Y_START`, `BALLOON_Y_END`, `BALLOON_Y_STEP`, `BALLOON_MIN_ALT`,
  `BALLOON_ASCENT`, `BALLOON_MID_Y`, `BALLOON_DIVISOR`)
- Replaced all bare room numbers (1–37) with named `ROOM_*` constants in game
  logic, `obj_data` table, `exit_data` table, and `ve_data` table
- Replaced all remaining bare `40` in game logic with `LOC_GONE`
- Fixed `l == 80` dead branch: original P2000T BASIC had `L=8`, the C64
  conversion mistakenly tokenized `8ORL` as `80` — now `l == ROOM_AFGRAVING`
- Removed `cmd_open_thing` sub-dispatcher: all "open ..." commands now go
  through the dispatch table — "open afvoer/kluis" no longer shadowed
- Replaced `rand()`/`srand()` with xorshift32 PRNG (portable, no library
  dependency, deterministic)

## 2026-06-17

- Ported the game from BASIC to C (`src/korenvliet.c`)
  - `src/main.bas` — BASICode 2 runtime library for C64/Commander X16 (original)
  - `src/korenvl.bas` — original game source for C64
- Replaced screen clears with natural scrolling text
- Replaced `wait_key()` pauses with automatic flow
- Made the code C89-compliant for Amiga compatibility
- Replaced non-portable `<strings.h>` and `<stdint.h>` with inline `xstrcasecmp`/`xstrncasecmp`
- Implemented a variadic `xsnprintf` wrapper for Amiga's missing `snprintf`
- Removed all `goto` statements; used structured control flow instead
- Removed the `cls()` stub and all `wait_seconds()` calls
- Removed the "instructions?" prompt; help text is always shown on startup
- Removed the "kijk" command (no-op screen redraw)
- Created `Makefile` with C89 flags
- Updated `.gitignore` to exclude the `korenvliet` binary
- Grouped all 15 global state variables into `struct GameState`
- Replaced magic number `40` with named constant `LOC_GONE`
- Simplified safe combination generation (removed dead shuffle, removed `ss[]`)
- Fixed safe number range to 10–99 (was 10–100, could produce 3 digits)
- Documented all location numbers (1–37) in source comment
- Unified duplicated rightmost-substring matching into `find_obj()`
- Replaced 28x `printf("Ik begrijp U niet.\n"); return 1;` with `fail()` helper
- Replaced unsafe `vsprintf` with bounded `snprintf` wrapper using temp buffer
- Refactored `cmd_enter` from 113 lines to table-driven dispatch with separate place handlers
- Replaced `handle_command` 140-line if-chain with compact table-driven dispatch (32 entries)
  - Extracted `cmd_read_book`, `cmd_help`, `cmd_cure`, `cmd_koop`, `cmd_open_thing` helpers
  - Unified all handler signatures to `int handler(char *)`
- Moved all remaining mutable globals (`obj[]`, `loc[]`, `p[][]`, `ve[]`, `n[][]`) into `struct GameState`
  - Removed fragile positional initializer; replaced with explicit `gs.room = 9` in `init_data()`
- Renumbered safe-code storage to 0-indexed (`n[0]`–`n[2]`); resized from `n[4][4]` to `n[3][4]`
- Removed dead safe-code shuffle logic (`ss[]`, `sflags[]`, debug prints)
- Removed debug print of safe code at startup
- Fixed snorkel guard to catch `"ga oost"` and bare `"o"` (was only `"ga o"`)
- Fixed `cmd_koop`: added missing room-10 and capacity checks
- Replaced magic numbers with named constants (`MAX_CARRY`, `BOAT_DROP`, `WATER_OFF`, `SEWER_MAX`, `SEWER_NEED`, `JOG_BOUND`, `WOOD_SPAWN`, `BALLOON_PARTS`, `SAFE_DIGITS`, `SAFE_MIN`, `SAFE_MAX`, `WRAP_W`, `SUFFIX_LEN`)
- Replaced all remaining bare `40` in code with `LOC_GONE`
- Fixed unreachable `"ga jog"`/`"ga trim"`/`"ga door deur"` (intercepted by generic `"ga "` prefix handler)
- Removed dead code after `generic_take_item` in `cmd_take`
