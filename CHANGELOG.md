# Changelog

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
