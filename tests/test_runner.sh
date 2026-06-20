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

    output=$(printf "%b" "$input" | timeout 2 "$GAME" 2>/dev/null || true)

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

# ── Movement ─────────────────────────────────────────────────────
# Start at HOOFDSTRAAT (9). Exits: z→BOS, n→TERREIN

run_test "go south"                 'ga z\nstop\n'              'in een bos'
run_test "go north"                 'ga n\nstop\n'              'braakliggend terrein'
run_test "single-letter direction"  'z\nstop\n'                  'in een bos'
run_test "multiple moves"           'z\nz\no\nstop\n'           'glibberige kanaalkant'

# ── Object interaction ──────────────────────────────────────────

run_test "take invalid object"      'neem niets\nstop\n'        'Ik begrijp U niet'

# ── Examine ─────────────────────────────────────────────────────
run_test "examine at location"      'bekijk landhuis\nstop\n'   'Korenvliet'

# ── Jogging ─────────────────────────────────────────────────────
run_test "buy and jog"              \
    'ga in winkel\nkoop sportschoenen\nu\nga joggen\nstop\n' \
    'Pfff'

# ── Read testament (without safe open) ─────────────────────────
run_test "read testament fail"      'lees testament\nstop\n'    'Ik begrijp U niet.'

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
exit $FAIL
