#!/bin/sh
# Integration test suite for Korenvliet
# Feeds commands via stdin, greps for expected output phrases.

set -u

GAME=./korenvliet
PASS=0
FAIL=0

run_test() {
    local name="$1"
    local input="$2"
    local expected="$3"
    local to=${4:-3}

    output=$(printf "%b" "$input" | timeout "$to" "$GAME" 2>&1 || true)

    if echo "$output" | grep -Fq "$expected"; then
        echo "  PASS  $name"
        PASS=$((PASS + 1))
    else
        echo "  FAIL  $name  (expected: '$expected')"
        echo "--- output tail ---"
        echo "$output" | tail -10
        echo "-------------------"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== Korenvliet test suite ==="
echo ""

# Rebuild to catch source changes
make clean
make; ec=$?; if [ $ec -ne 0 ]; then echo "Build failed (exit $ec)"; exit 1; fi

# ── Basic commands ──────────────────────────────────────────────

run_test "stop"                     'stop\n'                    'Stoppen'
run_test "help"                     'help\nstop\n'              'Richtingen'
run_test "empty inventory"          'inventaris\nstop\n'        'Inventaris:'
run_test "invalid command"          'xyzzy\nstop\n'             'Ik begrijp U niet.'
run_test "unknown direction"        'ga q\nstop\n'              'Richting niet duidelijk'
run_test "kijk"                     'kijk\nstop\n'              'Plaats'

# ── Movement ─────────────────────────────────────────────────────
# Start at HOOFDSTRAAT (9). Exits: z→BOS, n→TERREIN

run_test "go south"                 'ga z\nstop\n'              'in een bos'
run_test "go north"                 'ga n\nstop\n'              'braakliggend terrein'
run_test "single-letter direction"  'z\nstop\n'                  'in een bos'
run_test "multiple moves"           'z\nz\no\nstop\n'           'glibberige kanaalkant'

# ── Object interaction ──────────────────────────────────────────

run_test "take invalid object"      'neem niets\nstop\n'        'Ik begrijp U niet'
run_test "take too much"            \
    'ga in winkel\nkoop sportschoenen\nkoop bijl\nu\nz\no\nneem rubberboot\nneem kachel\nw\nz\nneem ballon\nstop\n' \
    'teveel'

# ── Examine ─────────────────────────────────────────────────────
run_test "examine at location"      'bekijk landhuis\nstop\n'   'Korenvliet'
run_test "read sign"                'n\no\no\nlees bord\nstop\n' 'Een goede plaats'

# ── Entry limits ────────────────────────────────────────────────
run_test "enter winkel with items"   \
    'ga in winkel\nkoop sportschoenen\nu\nga in winkel\nstop\n' \
    'niet binnen'

# ── Jogging ─────────────────────────────────────────────────────
run_test "buy and jog"              \
    'ga in winkel\nkoop sportschoenen\nu\nga joggen\nstop\n' \
    'Pfff'

# ── Drop ────────────────────────────────────────────────────────
run_test "drop not carried"         'leg mand\nstop\n'          'Ik begrijp U niet'
run_test "drop carried item"        \
    'ga in winkel\nkoop sportschoenen\nu\nleg sportschoenen\nstop\n' \
    'sportschoenen'

# ── Enter buildings ────────────────────────────────────────────
run_test "enter ziekenhuis"         'ga in ziekenhuis\nstop\n'  'in het ziekenhuis'

# ── Boat ────────────────────────────────────────────────────────
run_test "boat crossing"            \
    'z\no\nneem rubberboot\nz\no\nblaas boot op\nga in vijver\nstop\n' \
    'op de vijver'  6
run_test "boat already inflated"    \
    'z\no\nneem rubberboot\nz\no\nblaas boot op\nblaas boot op\nstop\n' \
    'al opgeblazen'  6
run_test "boat drifts away"         \
    'z\no\nneem rubberboot\nz\no\nblaas boot op\nga in vijver\nz\nleg rubberboot\nstop\n' \
    'drijft weg'  6

# ── Sewer entry ────────────────────────────────────────────────
run_test "sewer entry"              \
    'ga in winkel\nkoop sportschoenen\nu\nga joggen\nga in landhuis\nz\nverwijder deksel\nga in afvoer\nstop\n' \
    'uitlaat van het riool'  6

# ── Canal / health ──────────────────────────────────────────────
run_test "fall in canal"            \
    'z\nz\no\nga in kanaal\nstop\n' 'U gleed uit en viel.'
run_test "get cured"                \
    'z\nz\no\nga in kanaal\nwordt beter\nstop\n' 'Genezen.'

# ── Door at overloop ───────────────────────────────────────────
run_test "open door locked"         \
    'ga in landhuis\nz\no\nz\nopen deur\nstop\n' 'vergrendeld'
run_test "go through door locked"   \
    'ga in landhuis\nz\no\nz\nga door deur\nstop\n' 'op slot'

# ── Object special cases ───────────────────────────────────────
run_test "take klok"                \
    'ga in landhuis\nz\no\nneem klok\nstop\n' 'Te zwaar'
run_test "take kluis"               \
    'ga in landhuis\nz\no\nz\nbekijk schilderij\nneem kluis\nstop\n' \
    'aan de muur vast'  6
run_test "take zalm without net"    \
    'z\no\nneem rubberboot\nz\no\nblaas boot op\nga in vijver\nz\nneem zalm\nstop\n' \
    'glipte'  6

# ── Read testament (without safe open) ─────────────────────────
run_test "read testament fail"      'lees testament\nstop\n'    'Ik begrijp U niet.'

# ── Walkthrough: balloon speedrun ──────────────────────────────
# Collect all 6 balloon parts, build balloon at AFGRAVING, fly it.
BALLOON_BUILD='ga in winkel\nkoop bijl\nu\nz\nhak boom\nneem houtblokken\nz\nneem ballon\nn\no\nneem kachel\nw\nn\nn\no\no\nleg bijl\nleg ballon\nleg kachel\nleg houtblokken\nw\nw\nz\nga in landhuis\nneem mand\nz\nz\nneem koord\nn\no\no\nneem lucifers\nw\nw\nz\nu\nw\nn\nn\no\no\nleg mand\nleg koord\nleg lucifers\nbouw ballon'
BALLOON_FLIGHT='\nga in ballon\nvlieg met ballon'
run_test "balloon speedrun"         "${BALLOON_BUILD}${BALLOON_FLIGHT}\nstop\n"  'Ballon op hoogte'  12

# ── Safe number from tafel ─────────────────────────────────────
# Build balloon, fly to PLATEAU, enter schuur, examine tafel.
run_test "examine tafel in schuur"  "${BALLOON_BUILD}${BALLOON_FLIGHT}\nu\nga in schuur\nbekijk tafel\nstop\n"  'Er ligt een briefje met het nummer'  15

# ── Walkthrough: exploration ───────────────────────────────────
# Enter landhuis from HOOFDSTRAAT, explore rooms, take items, go upstairs.
EXPLORE='ga in landhuis\nbekijk mand\nz\no\no\nneem boek\nw\nw\nn\nz\nu\nstop\n'
run_test "exploration"              "$EXPLORE"                  'Friese staartklok' 9

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
