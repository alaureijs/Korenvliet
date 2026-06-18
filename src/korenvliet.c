/* korenvliet.c -- Dutch text adventure
 * Ported from BASIC (C64/Commander X16) to C.
 * Instead of clearing the screen, text scrolls naturally.
 *
 * Original (c) 1983 Hans Pennings
 * C port (c) 2026
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdarg.h>

/* Portable case-insensitive string comparison (Amiga-safe) */
static int xstrcasecmp(const char *a, const char *b)
{
    while (*a && *b) {
        int ca = tolower((unsigned char)*a);
        int cb = tolower((unsigned char)*b);
        if (ca != cb) return ca - cb;
        a++; b++;
    }
    return tolower((unsigned char)*a) - tolower((unsigned char)*b);
}
static int xstrncasecmp(const char *a, const char *b, size_t n)
{
    while (n > 0 && *a && *b) {
        int ca = tolower((unsigned char)*a);
        int cb = tolower((unsigned char)*b);
        if (ca != cb) return ca - cb;
        a++; b++; n--;
    }
    if (n == 0) return 0;
    return tolower((unsigned char)*a) - tolower((unsigned char)*b);
}

#define strcasecmp  xstrcasecmp
#define strncasecmp xstrncasecmp

/* Return value convention for command handlers */
#define RET_EXIT    -1   /* Exit game loop */
#define RET_REDRAW   0   /* Redraw location description */
#define RET_KEEP     1   /* Keep prompt, no redraw */

static int fail(void)
{
    printf("Ik begrijp U niet.\n");
    return RET_KEEP;
}

static int xsnprintf(char *buf, size_t size, const char *fmt, ...)
{
    char tmp[256];
    int n;
    size_t copy;
    va_list ap;
    va_start(ap, fmt);
    n = vsprintf(tmp, fmt, ap);
    va_end(ap);
    if (n < 0) return n;
    if (size == 0) return n;
    copy = (size_t)n;
    if (copy >= size) copy = size - 1;
    memcpy(buf, tmp, copy);
    buf[copy] = '\0';
    return n;
}
#define snprintf xsnprintf

/* ------------------------------------------------------------------ */
/*  Data sizes                                                         */
/* ------------------------------------------------------------------ */
#define MAX_OBJ   33
#define MAX_LOC   37
#define MAX_INV   19       /* only objects 1..19 can be carried */
#define MAX_EXITS  3
#define LOC_GONE  40      /* object is used/destroyed/gone */
#define WRAP_W    38      /* display column width for word-wrap */
#define SUFFIX_LEN 2      /* strlen of ". " appended to object names */
#define MAX_CARRY 4       /* max items player can carry */
#define BOAT_DROP 5       /* location 5 (vijveroever) when boat drops */
#define WATER_OFF 2       /* room offset: surface (28/29) -> underwater (30/31) */
#define SEWER_MAX 8       /* number of sewer entrance locations */
#define SEWER_NEED 4      /* objects 1..4 required for sewer entry */
#define JOG_BOUND 9       /* rooms 1..9 are outdoors for jogging */
#define WOOD_SPAWN 2      /* room where houtblokken appear after cutting */
#define BALLOON_PARTS 6   /* objects 1..6 needed to build balloon */
#define SAFE_DIGITS 3     /* number of safe-code digits */
#define SAFE_MIN 10       /* safe code lower bound */
#define SAFE_MAX 99       /* safe code upper bound */

/* Atmospheric description probability thresholds */
#define ATMOS_RNG_MAX    10
#define GULL_THRESH       5

/* Balloon altitude animation parameters */
#define BALLOON_Y_START    5   /* loop start */
#define BALLOON_Y_END     29   /* loop end */
#define BALLOON_Y_STEP     6   /* loop step */
#define BALLOON_MIN_ALT    3   /* minimum altitude at midpoint */
#define BALLOON_ASCENT     5   /* ascent rate */
#define BALLOON_MID_Y     17   /* midpoint y = (START+END)/2 */
#define BALLOON_DIVISOR    6   /* altitude slope divisor (== Y_STEP) */

/* Location number constants */
enum {
    LOCATION_BINNENPLEIN = 1,
    LOCATION_BOS,
    LOCATION_WEILAND,
    LOCATION_KANAALKANT,
    LOCATION_VIJVEROEVER,
    LOCATION_TERREIN,
    LOCATION_ROTSPAD,
    LOCATION_AFGRAVING,
    LOCATION_HOOFDSTRAAT,
    LOCATION_SUPERMARKT,
    LOCATION_ZIEKENHUIS,
    LOCATION_FOYER,
    LOCATION_HUISKAMER,
    LOCATION_STUDEERKAMER,
    LOCATION_TUINKAMER,
    LOCATION_OVERLOOP,
    LOCATION_ATRIUM,
    LOCATION_WIJNKELDER_WEST,
    LOCATION_WIJNKELDER_OOST,
    LOCATION_TRAP,
    LOCATION_RIOOL_21,
    LOCATION_RIOOL_22,
    LOCATION_RIOOL_23,
    LOCATION_RIOOL_24,
    LOCATION_RIOOL_25,
    LOCATION_RIOOL_26,
    LOCATION_RIOOL_27,
    LOCATION_VIJVER,
    LOCATION_ZUIDBAAI,
    LOCATION_ONDERWATER_30,
    LOCATION_ONDERWATER_31,
    LOCATION_STROOM,
    LOCATION_GROT,
    LOCATION_BALLON_STRAAT,
    LOCATION_BALLON_PLATEAU,
    LOCATION_PLATEAU,
    LOCATION_SCHUUR
};

/* Object number constants */
enum {
    OBJ_BALLON = 1,
    OBJ_KACHEL,
    OBJ_MAND,
    OBJ_HOUTBLOKKEN,
    OBJ_KOORD,
    OBJ_LUCIFERS,
    OBJ_TAS,
    OBJ_RUBBERBOOT,
    OBJ_BORD,
    OBJ_VISNET,
    OBJ_SPORTSCHOENEN,
    OBJ_BIJL,
    OBJ_ZWEMBRIL,
    OBJ_ZALM,
    OBJ_BEKER,
    OBJ_FLES,
    OBJ_BOEK,
    OBJ_SCHILDERIJ,
    OBJ_SNORKEL,
    OBJ_LANDHUIS_STRAAT,
    OBJ_LANDHUIS_PLEIN,
    OBJ_SCHUUR,
    OBJ_TAFEL,
    OBJ_KLOK,
    OBJ_KLUIS,
    OBJ_KIST,
    OBJ_BOMEN,
    OBJ_DEUR_TRAP,
    OBJ_DEUR_OVERLOOP,
    OBJ_PANTER,
    OBJ_WINKEL,
    OBJ_TRAP,
    OBJ_ZIEKENHUIS
};

/* ------------------------------------------------------------------ */
/*  Object                                                             */
/* ------------------------------------------------------------------ */
typedef struct {
    const char *short_name;
    const char *desc;
    unsigned char loc;      /* 0 = carried, 1..37 = location, LOC_GONE = gone */
} Object;

/* ------------------------------------------------------------------ */
/*  Exit descriptor                                                    */
/* ------------------------------------------------------------------ */
typedef struct {
    char dir;               /* n,o,z,w,u,l,h,- */
    unsigned char dest;
} Exit;

/* ------------------------------------------------------------------ */
/*  Location                                                           */
/* ------------------------------------------------------------------ */
typedef struct {
    const char *desc;
    Exit exits[MAX_EXITS];
} Location;

/* ------------------------------------------------------------------ */
/*  Game state                                                         */
/* ------------------------------------------------------------------ */
static Object  obj[MAX_OBJ + 1];      /* 1-indexed */
static Location loc[MAX_LOC + 1];     /* 1-indexed */

static unsigned char l  = 9;   /* current location */
static unsigned char i  = 0;   /* # items carried */
static unsigned char h  = 0;   /* balloon built */
static unsigned char r  = 0;   /* rubber boat inflated */
static unsigned char w  = 0;   /* jogging done (weight loss) */
static unsigned char k  = 0;   /* door unlocked */
static unsigned char v  = 0;   /* panther fed */
static unsigned char f  = 0;   /* safe opened, testament readable */
static unsigned char e  = 0;   /* painting examined, safe revealed */
static unsigned char c1 = 0, c2 = 0, c3 = 0, c4 = 0;
static unsigned char s  = 0;   /* sick / injured */
static unsigned char hb = 0;   /* balloon part counter */

static const char * const p[3] = {
    "uitlaat is afgedekt",
    "er past iets niet",
    "binnenin is een briefje met nummer"
};
static const int ve[9] = {
    0, LOCATION_HUISKAMER, LOCATION_STUDEERKAMER, LOCATION_ATRIUM,
    LOCATION_WIJNKELDER_WEST, LOCATION_RIOOL_21, LOCATION_RIOOL_24,
    LOCATION_RIOOL_26, LOCATION_RIOOL_27
};
static char n[3][3];             /* random numbers (2-digit strings) */

/* ------------------------------------------------------------------ */
/*  Help text                                                          */
/* ------------------------------------------------------------------ */
static const char *help_text[] = {
    "",
    "Welkom in Rittenburg. U heeft onlangs",
    "vernomen dat Uw excentrieke oom Wout is",
    "overleden. Het gerucht gaat dat deze",
    "oude zonderling het landhuis Korenvliet",
    "heeft nagelaten aan degene die zijn",
    "kluis vindt en weet te openen.",
    "",
    "Om het spel te spelen moet U objecten",
    "in Uw omgeving onderzoeken en manipu-",
    "leren door het gebruik van eenvoudige",
    "opdrachten, zoals:",
    "",
    "  neem mand, ga zuid, leg iets, stop,",
    "  ga door deur, ga in vijver, inventaris,",
    "  bekijk iets, ga uit landhuis, help,",
    "  open deur, verwijder deksel, ga naar",
    "  winkel.",
    "",
    "Richtingen mogen worden afgekort:",
    "  ga N,W,O,Z; U=uit, L=omlaag, H=omhoog",
    NULL
};

/* ------------------------------------------------------------------ */
/*  Helpers                                                            */
/* ------------------------------------------------------------------ */

/* xorshift32 PRNG state */
static unsigned int rng_state;

/* Return random integer in [lo, hi] */
static int rand_range(int lo, int hi)
{
    rng_state ^= rng_state << 13;
    rng_state ^= rng_state >> 17;
    rng_state ^= rng_state << 5;
    return lo + (int)(rng_state % (unsigned int)(hi - lo + 1));
}

/* Remove trailing newline from a string */
static void chomp(char *str)
{
    size_t len = strlen(str);
    while (len > 0 && (str[len-1] == '\n' || str[len-1] == '\r'))
        str[--len] = '\0';
}

/* ------------------------------------------------------------------ */
/*  Print direction name                                               */
/* ------------------------------------------------------------------ */
static void print_dir_name(char d)
{
    switch (d) {
    case 'n': printf("noord");   break;
    case 'o': printf("oost");    break;
    case 'z': printf("zuid");    break;
    case 'w': printf("west");    break;
    case 'u': printf("uit");     break;
    case 'h': printf("(om)hoog"); break;
    case 'l': printf("(om)laag"); break;
    default:  printf("?");       break;
    }
}

/* ------------------------------------------------------------------ */
/*  Display current location, exits, objects                           */
/* ------------------------------------------------------------------ */
static void display_location(void)
{
    int x, n_exits;
    int col;

    printf("\n---\n");
    printf("Plaats    : %s.\n", loc[l].desc);
    printf("Uitgangen : ");
    n_exits = 0;
    for (x = 0; x < MAX_EXITS; x++) {
        if (loc[l].exits[x].dir != '-') {
            if (n_exits > 0) printf(" ");
            print_dir_name(loc[l].exits[x].dir);
            printf(".");
            n_exits++;
        }
    }
    printf("\n");

    printf("U ziet    : ");
    if (obj[OBJ_ZWEMBRIL].loc != 0 && (l == LOCATION_ONDERWATER_30 || l == LOCATION_ONDERWATER_31)) {
        printf("Niets bijzonders.\n");
        printf("\n");
        return;
    }

    col = 0;
    for (x = 1; x <= MAX_OBJ; x++) {
        if (obj[x].loc == l) {
            if (col + (int)strlen(obj[x].desc) > WRAP_W) {
                printf("\n             ");
                col = 0;
            }
            printf("%s. ", obj[x].desc);
            col += (int)strlen(obj[x].desc) + 2;
        }
    }
    if (col == 0) printf("Niets bijzonders.\n");
    printf("\n");

    /* Special location descriptions */
    if (obj[OBJ_ZWEMBRIL].loc == 0 && l == LOCATION_ONDERWATER_31)
        printf("Een tunnel onder water.\n");
    if ((l == LOCATION_HUISKAMER && c1) || (l == LOCATION_STUDEERKAMER && c2) || (l == LOCATION_ATRIUM && c3) || (l == LOCATION_WIJNKELDER_WEST && c4))
        printf("putdeksel. ");
    if (l == LOCATION_HUISKAMER || l == LOCATION_STUDEERKAMER || l == LOCATION_ATRIUM || l == LOCATION_WIJNKELDER_WEST)
        printf("afvoer.\n");
    if (h && (l == LOCATION_AFGRAVING || l == LOCATION_PLATEAU))
        printf("hetelucht ballon.\n");

    /* Random atmospheric descriptions */
    {
        int ai, z = rand_range(1, ATMOS_RNG_MAX);
        static const struct { int room; int zval; char cmp; const char *text; } at[] = {
            {LOCATION_TERREIN,   1, '=', "Adriaan met twee staven dynamiet."},
            {LOCATION_WEILAND,   3, '=', "Zoete met een koppel bloedhonden."},
            {LOCATION_ROTSPAD,   5, '=', "Berend met een bulldozer."},
            {LOCATION_GROT,      5, '<', "Er vliegt een vleermuis langs."},
            {LOCATION_RIOOL_27,  3, '<', "Er zit spinrag in Uw haar."},
            {LOCATION_RIOOL_25,  3, '<', "Een rat strijkt langs Uw been."},
            {LOCATION_KANAALKANT,7, '=', "Een pad springt in het kanaal."},
            {LOCATION_BOS,       8, '=', "Een aapachtig figuur kijkt op U neer."},
        };
        for (ai = 0; ai < (int)(sizeof(at)/sizeof(at[0])); ai++) {
            if (l == at[ai].room &&
                ((at[ai].cmp == '=' && z == at[ai].zval) ||
                 (at[ai].cmp == '<' && z < at[ai].zval)))
                printf("%s\n", at[ai].text);
        }
        if (l == LOCATION_VIJVER && obj[OBJ_ZALM].loc == 0 && z < GULL_THRESH)
            printf("Een hongerige meeuw cirkelt rond.\n");
    }
}

/* ------------------------------------------------------------------ */
/*  Command handlers - each returns: 0 = redisplay, 1 = prompt only    */
/*  (no location redisplay), -1 = exit game                            */
/* ------------------------------------------------------------------ */

static int cmd_stop(void)
{
    printf("Stoppen...\n");
    return RET_EXIT;
}

static int cmd_inventory(void)
{
    int x, col = 0;
    printf("Inventaris:\n");
    for (x = 1; x <= MAX_INV; x++) {
        if (obj[x].loc == 0) {
            if (col + (int)strlen(obj[x].desc) > WRAP_W) {
                printf("\n");
                col = 0;
            }
            printf("%s. ", obj[x].desc);
            col += (int)strlen(obj[x].desc) + 2;
        }
    }
    printf("\n");
    return RET_KEEP;
}

/* Helper: find object by rightmost substring match on short_name.
 * Returns object index (1..33) or 0 if not found. */
static int find_obj_by_name(const char *name, int max_idx)
{
    int x;
    size_t nlen = strlen(name);
    for (x = 1; x <= max_idx; x++) {
        size_t slen = strlen(obj[x].short_name);
        int g = (int)nlen;
        if (g > (int)slen) g = (int)slen;
        if (g > 0 && strcasecmp(name + nlen - g, obj[x].short_name + slen - g) == 0)
            return x;
    }
    return 0;
}

/* Helper: generic take item (after name match). Returns 0=ok, 1=error. */
static int generic_take_item(int idx)
{
    if (idx == 0) return RET_EXIT;
    if (obj[idx].loc == 0) { printf("Dat heeft U al.\n"); return RET_KEEP; }
    if (obj[idx].loc == l) { obj[idx].loc = 0; i++; return RET_REDRAW; }
    return RET_EXIT;
}

static int cmd_take(char *arg)
{
    if (strncasecmp(arg, "pak ", 4) == 0)
        memmove(arg, arg + 4, strlen(arg) - 3);
    else if (strncasecmp(arg, "neem ", 5) == 0)
        memmove(arg, arg + 5, strlen(arg) - 4);

    /* Specific checks before generic handling */
    if (strcasecmp(arg, "zalm") == 0 && l == LOCATION_ZUIDBAAI && obj[OBJ_VISNET].loc != 0) {
        printf("Die glipte uit Uw vingers.\n");
        return RET_KEEP;
    }
    if (strcasecmp(arg, "schilderij") == 0 && l == LOCATION_OVERLOOP) {
        printf("Te kostbaar.\n");
        return RET_KEEP;
    }
    if (l == LOCATION_SUPERMARKT) {
        printf("Pleeg geen winkeldiefstal!\n");
        return RET_KEEP;
    }
    if (strcasecmp(arg, "tafel") == 0 && l == LOCATION_SCHUUR) {
        printf("Die zit vastgespijkerd.\n");
        return RET_KEEP;
    }
    if (i >= 4) {
        printf("U draagt teveel bij U.\n");
        return RET_KEEP;
    }

    /* Bril (zwembril, obj 13) */
    if (strcasecmp(arg, "bril") == 0) {
        if (obj[OBJ_ZWEMBRIL].loc == 0) { printf("Heeft U al.\n"); return RET_KEEP; }
        if (obj[OBJ_ZWEMBRIL].loc == LOC_GONE && l == LOCATION_STUDEERKAMER) { obj[OBJ_ZWEMBRIL].loc = 0; i++; return RET_REDRAW; }
        if (obj[OBJ_ZWEMBRIL].loc == l) { obj[OBJ_ZWEMBRIL].loc = 0; i++; return RET_REDRAW; }
        return fail();
    }

    /* Snorkel (obj 19) */
    if (strcasecmp(arg, "snorkel") == 0) {
        if (obj[OBJ_SNORKEL].loc == 0) { printf("Heeft U al.\n"); return RET_KEEP; }
        if (obj[OBJ_SNORKEL].loc == LOC_GONE && (obj[OBJ_TAS].loc == 0 || obj[OBJ_TAS].loc == l)) {
            obj[OBJ_SNORKEL].loc = 0; i++; return RET_REDRAW;
        }
        if (obj[OBJ_SNORKEL].loc == l) { obj[OBJ_SNORKEL].loc = 0; i++; return RET_REDRAW; }
        return fail();
    }

    /* Generic take */
    {
        int idx = find_obj_by_name(arg, MAX_INV);
        if (idx == 0) {
            if (strcasecmp(arg, "panter") == 0 && obj[OBJ_PANTER].loc == l) {
                printf("U had nog net genoeg kracht om\nweg te komen.\n");
                s = 1; l = LOCATION_ZIEKENHUIS;
                return RET_REDRAW;
            }
            if (strcasecmp(arg, "klok") == 0 && l == LOCATION_STUDEERKAMER) {
                printf("Te zwaar.\n"); return RET_KEEP;
            }
            if (strcasecmp(arg, "kist") == 0 && obj[OBJ_KIST].loc == l) {
                printf("Ik heb geen dorst.\n"); return RET_KEEP;
            }
            if (strcasecmp(arg, "kluis") == 0 && obj[OBJ_KLUIS].loc == l) {
                printf("De kluis zit aan de muur vast.\n"); return RET_KEEP;
            }
            return fail();
        }
        return generic_take_item(idx);
    }
    return fail();
}

static int cmd_drop(char *arg)
{
    int x;

    /* "leg snorkel" special */
    if (strncasecmp(arg, "leg snorkel", 11) == 0) {
        if (obj[OBJ_SNORKEL].loc != 0) { printf("Heeft U niet.\n"); return RET_KEEP; }
        if (l > LOCATION_RIOOL_27 && l < LOCATION_STROOM) { printf("Neem het snel terug!\n"); return RET_KEEP; }
        obj[OBJ_SNORKEL].loc = l; i--; return RET_REDRAW;
    }

    if (strncasecmp(arg, "leg ", 4) == 0)
        arg += 4;
    {
        size_t arglen = strlen(arg);
        for (x = 1; x <= MAX_INV; x++) {
            size_t slen = strlen(obj[x].short_name);
            int g = (int)arglen;
            if (g > (int)slen) g = (int)slen;
            if (g > 0 && strcasecmp(arg + arglen - g, obj[x].short_name + slen - g) == 0 && obj[x].loc == 0) {
                if (x == 8 && (l == LOCATION_VIJVER || l == LOCATION_ZUIDBAAI)) {
                    obj[OBJ_RUBBERBOOT].loc = LOCATION_VIJVEROEVER; i--;
                    printf("De boot drijft weg.....\n");
                    return RET_REDRAW;
                }
                i--;
                obj[x].loc = (l == LOCATION_VIJVER || l == LOCATION_ZUIDBAAI) ? l + WATER_OFF : l;
                return RET_REDRAW;
            }
        }
    }
    return fail();
}

static int cmd_go(const char *arg)
{
    int x;
    char dir;

    if (strncasecmp(arg, "ga ", 3) == 0)
        arg += 3;
    else if (strncasecmp(arg, "ga", 2) == 0)
        arg += 2;

    dir = (char)tolower((unsigned char)*arg);

    if (strncasecmp(arg, "noord", 5) == 0) dir = 'n';
    else if (strncasecmp(arg, "oost", 4) == 0) dir = 'o';
    else if (strncasecmp(arg, "zuid", 4) == 0) dir = 'z';
    else if (strncasecmp(arg, "west", 4) == 0) dir = 'w';
    else if (strncasecmp(arg, "uit", 3) == 0) dir = 'u';
    else if (strncasecmp(arg, "omhoog", 6) == 0) dir = 'h';
    else if (strncasecmp(arg, "omlaag", 6) == 0) dir = 'l';

    if (dir == 'o' && l == LOCATION_WIJNKELDER_WEST) {
        if (v == 0) { printf("Panter laat dat niet toe.\n"); return RET_KEEP; }
        l = LOCATION_WIJNKELDER_OOST; return RET_REDRAW;
    }

    for (x = 0; x < MAX_EXITS; x++) {
        if (loc[l].exits[x].dir == dir) {
            l = loc[l].exits[x].dest;
            return RET_REDRAW;
        }
    }
    printf("Richting niet duidelijk.\n");
    return RET_KEEP;
}

static int cmd_enter(const char *arg)
{
    const char *place;

    if (strncasecmp(arg, "ga in ", 6) == 0)
        place = arg + 6;
    else if (strncasecmp(arg, "ga in", 5) == 0)
        place = arg + 5;
    else
        return -2;

    while (*place == ' ') place++;

    if (strcasecmp(place, "afvoer") == 0) {
        int x, found = 0;
        for (x = 1; x <= SEWER_MAX; x++) {
            if (ve[x] == l) { found = 1; break; }
        }
        if (!found) return fail();
        if (obj[OBJ_RUBBERBOOT].loc == 0 && r == 1) {
            printf("%s\n", p[1]); return RET_KEEP;
        }
        {
            int y;
            for (y = 1; y <= SEWER_NEED; y++) {
                if (obj[y].loc == 0) { printf("%s\n", p[1]); return RET_KEEP; }
            }
        }
        if ((l == LOCATION_HUISKAMER && c1 == 0) || (l == LOCATION_STUDEERKAMER && c2 == 0) ||
            (l == LOCATION_ATRIUM && c3 == 0) || (l == LOCATION_WIJNKELDER_WEST && c4 == 0)) {
            printf("%s\n", p[0]); return RET_KEEP;
        }
        if (w == 0) { printf("U bent te dik.\n"); return RET_KEEP; }
        if (l == LOCATION_HUISKAMER && c1) { l = LOCATION_RIOOL_21; return RET_REDRAW; }
        if (l == LOCATION_STUDEERKAMER && c2) { l = LOCATION_RIOOL_24; return RET_REDRAW; }
        if (l == LOCATION_ATRIUM && c3) { l = LOCATION_RIOOL_26; return RET_REDRAW; }
        if (l == LOCATION_WIJNKELDER_WEST && c4) { l = LOCATION_RIOOL_27; return RET_REDRAW; }
        return fail();
    }

    if (strcasecmp(place, "ballon") == 0) {
        if (h == 0) { printf("Nog niet klaar.\n"); return RET_KEEP; }
        if (l == LOCATION_AFGRAVING)  { l = LOCATION_BALLON_STRAAT; return RET_REDRAW; }
        if (l == LOCATION_PLATEAU) { l = LOCATION_BALLON_PLATEAU; return RET_REDRAW; }
        printf("Ik kan het niet vinden.\n");
        return RET_KEEP;
    }

    if (strcasecmp(place, "vijver") == 0) {
        if (l != LOCATION_VIJVEROEVER) return fail();
        if (obj[OBJ_RUBBERBOOT].loc != 0) { printf("Ik moet ergens op kunnen drijven.\n"); return RET_KEEP; }
        if (r == 0) { printf("Rubberboot is te slap.\n"); return RET_KEEP; }
        l = LOCATION_VIJVER; return RET_REDRAW;
    }

    if (strcasecmp(place, "winkel") == 0 || strcasecmp(place, "supermarkt") == 0) {
        if (l != LOCATION_HOOFDSTRAAT) return fail();
        {
            int x;
            for (x = 1; x <= MAX_INV; x++) {
                if (obj[x].loc == 0) {
                    printf("U kunt de winkel niet binnen met alles wat U bij zich heeft.\n");
                    return RET_KEEP;
                }
            }
        }
        l = LOCATION_SUPERMARKT; return RET_REDRAW;
    }

    if (strcasecmp(place, "landhuis") == 0 || strcasecmp(place, "korenvliet") == 0) {
        if (l == LOCATION_HOOFDSTRAAT)  { l = LOCATION_FOYER; return RET_REDRAW; }
        if (l == LOCATION_BINNENPLEIN)  { l = LOCATION_ATRIUM; return RET_REDRAW; }
        return fail();
    }

    if (strcasecmp(place, "ziekenhuis") == 0) {
        if (l == LOCATION_HOOFDSTRAAT) { l = LOCATION_ZIEKENHUIS; return RET_REDRAW; }
        return fail();
    }

    if (strcasecmp(place, "tunnel") == 0) {
        if (l == LOCATION_ONDERWATER_31 && obj[OBJ_ZWEMBRIL].loc == 0) { l = LOCATION_STROOM; return RET_REDRAW; }
        return fail();
    }

    if (strcasecmp(place, "kanaal") == 0) {
        if (l == LOCATION_KANAALKANT) {
            printf("U gleed uit en viel.\n");
            s = 1; l = LOCATION_ZIEKENHUIS;
            return RET_REDRAW;
        }
        return fail();
    }

    if (strcasecmp(place, "afgraving") == 0) {
        if (l == LOCATION_AFGRAVING) { printf("Te steil.\n"); return RET_KEEP; }
        return fail();
    }

    if (strcasecmp(place, "schuur") == 0) {
        if (l == LOCATION_PLATEAU) { l = LOCATION_SCHUUR; return RET_REDRAW; }
        return fail();
    }

    return -2;
}

static int cmd_examine(const char *arg)
{
    int x, g;
    size_t arglen;
    const char *item;

    if (strncasecmp(arg, "onderzoek ", 10) == 0)
        item = arg + 10;
    else if (strncasecmp(arg, "bekijk ", 7) == 0)
        item = arg + 7;
    else if (strncasecmp(arg, "open ", 5) == 0)
        item = arg + 5;
    else if (strncasecmp(arg, "open", 4) == 0)
        item = arg + 4;
    else
        return -2;

    while (*item == ' ') item++;
    arglen = strlen(item);

    x = 0;
    {
        int xi;
        for (xi = 1; xi <= MAX_OBJ; xi++) {
            size_t slen = strlen(obj[xi].short_name);
            g = (int)arglen;
            if (g > (int)slen) g = (int)slen;
            if (g > 0 && strcasecmp(item + arglen - g, obj[xi].short_name + slen - g) == 0 &&
                (obj[xi].loc == l || obj[xi].loc == 0))
                { x = xi; break; }
        }
    }
    if (x == 0) return fail();

    if (strcasecmp(obj[x].short_name, "fles") == 0) {
        printf("%s %s\n", p[2], n[0]); return RET_KEEP;
    }
    if (strcasecmp(obj[x].short_name, "beker") == 0) {
        printf("%s %s\n", p[2], n[1]); return RET_KEEP;
    }
    if (strcasecmp(obj[x].short_name, "tafel") == 0) {
        printf("Er ligt een briefje met het nummer %s\n", n[2]); return RET_KEEP;
    }
    if (strcasecmp(obj[x].short_name, "kist") == 0) {
        printf("Er ontbreekt een fles.\n"); return RET_KEEP;
    }
    if (strcasecmp(obj[x].short_name, "boek") == 0) {
        printf("   Zo bouwt U een heteluchtballon:\n\n");
        printf("       1   ballon\n");
        printf("       2   kachel\n");
        printf("       3   brandstof\n");
        printf("       4   gondel of schuit\n");
        printf("       5   kabel of touw\n");
        printf("       6   lucifers of aansteker\n\n");
        printf("   Bouw op een geschikte plaats!\n");
        return RET_REDRAW;
    }
    if (strcasecmp(obj[x].short_name, "klok") == 0 && obj[OBJ_ZWEMBRIL].loc == LOC_GONE) {
        printf("Er zit een duikbril in.\n"); return RET_KEEP;
    }
    if (strcasecmp(obj[x].short_name, "tas") == 0 && obj[OBJ_SNORKEL].loc == LOC_GONE) {
        printf("Er zit een snorkel in.\n"); return RET_KEEP;
    }
    if (strcasecmp(obj[x].short_name, "schilderij") == 0) {
        printf("Er zit een kluis achter!\n");
        e = 1;
        obj[OBJ_KLUIS].loc = l;
        return RET_KEEP;
    }
    printf("Niets bijzonders.\n");
    return RET_KEEP;
}

static int cmd_jog(void)
{
    if (obj[OBJ_SPORTSCHOENEN].loc != 0) { printf("Ik heb schoenen nodig.\n"); return RET_KEEP; }
    if (l > LOCATION_HOOFDSTRAAT) { printf("Ik kan hier niet joggen.\n"); return RET_KEEP; }
    w = 1;
    printf("Pfff... Klaar!\n");
    return RET_KEEP;
}

static int cmd_go_up(void)
{
    int x;
    if (s == 1) { printf("Ik voel me niet goed.\n"); return RET_KEEP; }
    if ((l == LOCATION_RIOOL_21 && c1 == 0) || (l == LOCATION_RIOOL_24 && c2 == 0) ||
        (l == LOCATION_RIOOL_26 && c3 == 0) || (l == LOCATION_RIOOL_27 && c4 == 0)) {
        printf("%s\n", p[0]); return RET_KEEP;
    }
    for (x = 0; x < MAX_EXITS; x++) {
        if (loc[l].exits[x].dir == 'u') {
            l = loc[l].exits[x].dest;
            return RET_REDRAW;
        }
    }
    printf("Richting niet duidelijk.\n");
    return RET_KEEP;
}

static int cmd_panther(void)
{
    if (v == 1) return fail();
    if (l != LOCATION_WIJNKELDER_WEST) return fail();
    if (obj[OBJ_ZALM].loc != 0) { printf("U hebt voedsel nodig.\n"); return RET_KEEP; }
    printf("Panter ontsnapte met de zalm.\n");
    if (obj[OBJ_ZALM].loc == 0) i--;
    v = 1;
    obj[OBJ_ZALM].loc = LOC_GONE;
    obj[OBJ_PANTER].loc = LOC_GONE;
    return RET_REDRAW;
}

static int cmd_cut_tree(void)
{
    if (l == LOCATION_BOS && (obj[OBJ_BIJL].loc == 0 || obj[OBJ_BIJL].loc == l)) {
        obj[OBJ_HOUTBLOKKEN].loc = LOCATION_BOS;
        return RET_REDRAW;
    }
    return fail();
}

static int cmd_climb_tree(void)
{
    if (l != LOCATION_BOS) return fail();
    printf("U viel eraf.\n");
    s = 1; l = LOCATION_ZIEKENHUIS;
    return RET_REDRAW;
}

static int cmd_dive(void)
{
    if (l == LOCATION_VIJVER || l == LOCATION_ZUIDBAAI) {
        if (obj[OBJ_SNORKEL].loc == 0) {
            l += WATER_OFF;
            return RET_REDRAW;
        }
        printf("U hebt een snorkel nodig.\n");
        return RET_KEEP;
    }
    return fail();
}

static int cmd_remove_cover(void)
{
    if (l == LOCATION_HUISKAMER || l == LOCATION_RIOOL_21) { c1 = 1; return RET_REDRAW; }
    if (l == LOCATION_STUDEERKAMER || l == LOCATION_RIOOL_24) { c2 = 1; return RET_REDRAW; }
    if (l == LOCATION_ATRIUM || l == LOCATION_RIOOL_26) { c3 = 1; return RET_REDRAW; }
    if (l == LOCATION_WIJNKELDER_WEST || l == LOCATION_RIOOL_27) { c4 = 1; return RET_REDRAW; }
    return fail();
}

static int cmd_open_door(void)
{
    if (l == LOCATION_OVERLOOP || l == LOCATION_TRAP) {
        if (l == LOCATION_OVERLOOP && k == 0) {
            printf("Gaat niet. De deur is aan de andere kant vergrendeld.\n");
            return RET_KEEP;
        }
        printf("OK.\n");
        return RET_KEEP;
    }
    return fail();
}

static int cmd_open_safe(void)
{
    char input[64], f1[16], f2[16], f3[16];
    char sum1[64], sum2[64];

    if (e == 0) { printf("U kunt het niet vinden.\n"); return RET_KEEP; }
    if (l != LOCATION_OVERLOOP) { printf("Is hier niet.\n"); return RET_KEEP; }

    printf("Combinatieslot.\n");
    printf("Type het eerste getal  - ");
    if (fgets(input, sizeof(input), stdin) == NULL) return RET_KEEP;
    chomp(input); input[15] = '\0'; strcpy(f1, input);
    if (strcmp(f1, n[0]) != 0) { printf("Fout.\n"); return RET_KEEP; }

    printf("Type tweede getal  - ");
    if (fgets(input, sizeof(input), stdin) == NULL) return RET_KEEP;
    chomp(input); input[15] = '\0'; strcpy(f2, input);
    snprintf(sum1, sizeof(sum1), "%s%s", f1, f2);
    snprintf(sum2, sizeof(sum2), "%s%s", n[0], n[1]);
    if (strcmp(sum1, sum2) != 0) { printf("Fout.\n"); return RET_KEEP; }

    printf("Type het laatste getal  - ");
    if (fgets(input, sizeof(input), stdin) == NULL) return RET_KEEP;
    chomp(input); input[15] = '\0'; strcpy(f3, input);
    snprintf(sum1, sizeof(sum1), "%s%s%s", f1, f2, f3);
    snprintf(sum2, sizeof(sum2), "%s%s%s", n[0], n[1], n[2]);
    if (strcmp(sum1, sum2) == 0) {
        f = 1;
        printf("\nKlik........ Er zit een testament in.\n");
    } else {
        printf("Fout.\n");
    }
    return RET_KEEP;
}

static int cmd_inflate_boat(void)
{
    if (l != LOCATION_VIJVEROEVER) { printf("Niet hier.\n"); return RET_KEEP; }
    if (r == 1) { printf("Is al opgeblazen.\n"); return RET_KEEP; }
    printf("OK.\n"); r = 1; return RET_KEEP;
}

static int cmd_build_balloon(void)
{
    int x;
    if (l != LOCATION_AFGRAVING) { printf("Niet hier.\n"); return RET_KEEP; }
    hb = 0;
    for (x = 1; x <= BALLOON_PARTS; x++) {
        if (obj[x].loc == 0 || obj[x].loc == LOCATION_AFGRAVING) hb++;
    }
    if (hb != 6) { printf("Niet klaar.\n"); hb = 0; return RET_KEEP; }
    for (x = 1; x <= BALLOON_PARTS; x++) {
        if (obj[x].loc == 0) i--;
        obj[x].loc = LOC_GONE;
    }
    h = 1;
    return RET_REDRAW;
}

static int cmd_fly_balloon(void)
{
    int y, z;
    if (h == 0) { printf("Niet klaar.\n"); return RET_KEEP; }
    if (l == LOCATION_AFGRAVING || l == LOCATION_PLATEAU) { printf("U moet er eerst in.\n"); return RET_KEEP; }

    if (l == LOCATION_BALLON_PLATEAU) {
        for (y = BALLOON_Y_END; y >= BALLOON_Y_START; y -= BALLOON_Y_STEP) {
            z = BALLOON_MIN_ALT + abs(BALLOON_ASCENT * y - BALLOON_MID_Y * BALLOON_ASCENT) / BALLOON_DIVISOR;
            printf("Ballon op hoogte %d...\n", z);
        }
        l = LOCATION_BALLON_STRAAT; return RET_REDRAW;
    }
    if (l == LOCATION_BALLON_STRAAT) {
        for (y = BALLOON_Y_START; y <= BALLOON_Y_END; y += BALLOON_Y_STEP) {
            z = BALLOON_MIN_ALT + abs(BALLOON_ASCENT * y - BALLOON_MID_Y * BALLOON_ASCENT) / BALLOON_DIVISOR;
            printf("Ballon op hoogte %d...\n", z);
        }
        l = LOCATION_BALLON_PLATEAU; return RET_REDRAW;
    }
    return fail();
}

static int cmd_read_will(void)
{
    if (f != 1) return fail();
    printf("\n***  LAATSTE WILSBESCHIKKING  ***\n\n");
    printf("* Ik, Wout van Duysz ter Ghasth *\n");
    printf("* in goede gezondheid en bij    *\n");
    printf("* mijn volle verstand, laat     *\n");
    printf("* al mijn bezittingen, met      *\n");
    printf("* inbegrip van Korenvliet,      *\n");
    printf("* na aan diegene die deze       *\n");
    printf("* kluis opent, wie dat ook      *\n");
    printf("* zijn moge, zelfs Olivier      *\n");
    printf("\n");
    printf("      <<<gefeliciteerd>>>\n");
    return RET_EXIT;
}

static int cmd_read_sign(void)
{
    if (obj[OBJ_BORD].loc == 0 || obj[OBJ_BORD].loc == l) {
        printf("Op het bord staat: Een goede plaats.\n");
        return RET_KEEP;
    }
    printf("Kunt het niet vinden.\n");
    return RET_KEEP;
}

static int cmd_door(void)
{
    if (l == LOCATION_OVERLOOP && k == 0) { printf("De deur is op slot.\n"); return RET_KEEP; }
    if (l == LOCATION_TRAP) { l = LOCATION_OVERLOOP; k = 1; return RET_REDRAW; }
    if (l == LOCATION_OVERLOOP) { l = LOCATION_TRAP; return RET_REDRAW; }
    return fail();
}

/* ------------------------------------------------------------------ */
/*  Main command dispatcher                                            */
/* ------------------------------------------------------------------ */

static int cmd_help(void) {
    int line;
    for (line = 0; help_text[line] != NULL; line++)
        printf("%s\n", help_text[line]);
    return RET_REDRAW;
}

static int cmd_cure(void) {
    if (s != 1) return fail();
    s = 0; printf("Genezen.\n"); return RET_KEEP;
}

static int cmd_read_book(void) {
    return cmd_examine("bekijk boek");
}

static int cmd_kijk(void) {
    return RET_REDRAW;
}

typedef struct {
    const char *cmd;
    int (*handler)(void);
} CmdEntry;

static const CmdEntry cmd_table[] = {
    {"stop",            cmd_stop},
    {"halt",            cmd_stop},
    {"help",            cmd_help},
    {"inventaris",      cmd_inventory},
    {"ga door deur",    cmd_door},
    {"ga u",            cmd_go_up},
    {"ga uit",          cmd_go_up},
    {"verwijder deksel", cmd_remove_cover},
    {"open afvoer",     cmd_remove_cover},
    {"open deur",       cmd_open_door},
    {"maak kluis open", cmd_open_safe},
    {"open kluis",      cmd_open_safe},
    {"blaas boot op",   cmd_inflate_boat},
    {"blaas ballon op", cmd_build_balloon},
    {"bouw ballon",     cmd_build_balloon},
    {"vlieg met ballon", cmd_fly_balloon},
    {"zeil met ballon", cmd_fly_balloon},
    {"lees testament",  cmd_read_will},
    {"lees boek",       cmd_read_book},
    {"lees bord",       cmd_read_sign},
    {"voer panter",     cmd_panther},
    {"geef zalm",       cmd_panther},
    {"gezondheid",      cmd_cure},
    {"wordt beter",     cmd_cure},
    {"beterschap",      cmd_cure},
    {"kijk",            cmd_kijk},
    {NULL, NULL}
};

static int handle_command(const char *cmd)
{
    char buf[128];
    char *cp;
    size_t ci;
    int ret;
    const CmdEntry *entry;

    for (ci = 0; ci < sizeof(buf) - 1 && cmd[ci]; ci++)
        buf[ci] = (char)tolower((unsigned char)cmd[ci]);
    buf[ci] = '\0';

    cp = buf;
    while (*cp == ' ') cp++;
    if (*cp == '\0') return RET_KEEP;

    /* Convert "ga naar X" to "ga in X" */
    if (strncmp(cp, "ga naar ", 8) == 0) {
        memmove(cp + 6, cp + 8, strlen(cp + 8) + 1);
        cp[3] = 'i'; cp[4] = 'n'; cp[5] = ' ';
    }

    /* Dispatch exact-match commands */
    for (entry = cmd_table; entry->cmd; entry++)
        if (strcmp(cp, entry->cmd) == 0)
            return entry->handler();

    /* "ga jog"/"ga trim" prefix (allows "ga joggen", "ga trimmen") */
    if (strncmp(cp, "ga jog", 6) == 0 || strncmp(cp, "ga trim", 7) == 0)
        return cmd_jog();

    /* "ga in X" place entry */
    ret = cmd_enter(cp);
    if (ret != -2) return ret;

    /* Snorkel check before generic "ga o" */
    if (strcmp(cp, "ga o") == 0 && l == LOCATION_STROOM) {
        if (obj[OBJ_SNORKEL].loc != 0) {
            printf("U heeft een snorkel nodig.\n");
            return RET_KEEP;
        }
    }

    /* "ga " / single-letter direction */
    if (strncmp(cp, "ga ", 3) == 0 || (strlen(cp) == 1 && strchr("nozwulh", *cp))) {
        char tmp[16];
        if (strlen(cp) == 1 && strchr("nozwulh", *cp)) {
            snprintf(tmp, sizeof(tmp), "ga %c", *cp);
            return cmd_go(tmp);
        }
        return cmd_go(cp);
    }

    /* "neem " / "pak " */
    if (strncmp(cp, "neem ", 5) == 0 || strncmp(cp, "pak ", 4) == 0)
        return cmd_take(cp);

    /* "leg " */
    if (strncmp(cp, "leg ", 4) == 0)
        return cmd_drop(cp);

    /* "koop " at supermarkt */
    if (strncmp(cp, "koop ", 5) == 0 && l == LOCATION_SUPERMARKT) {
        char *item = cp + 5;
        while (*item == ' ') item++;
        ret = find_obj_by_name(item, MAX_INV);
        if (ret == 0) return fail();
        return generic_take_item(ret);
    }

    /* "hak"/"snij" + boom/bomen */
    if (strstr(cp, "boom") || strstr(cp, "bomen"))
        if (strncmp(cp, "hak", 3) == 0 || strncmp(cp, "snij", 4) == 0)
            return cmd_cut_tree();

    /* "klim" */
    if (strncmp(cp, "klim", 4) == 0)
        return cmd_climb_tree();

    /* "duik" */
    if (strncmp(cp, "duik", 4) == 0)
        return cmd_dive();

    /* "onderzoek " / "bekijk " */
    if (strncmp(cp, "onderzoek ", 10) == 0 || strncmp(cp, "bekijk ", 7) == 0) {
        ret = cmd_examine(cp);
        if (ret != -2) return ret;
    }

    /* "open " (boek/klok/tas → examine, deur → open) */
    if (strncmp(cp, "open ", 5) == 0) {
        const char *what = cp + 5;
        while (*what == ' ') what++;
        if (strcmp(what, "boek") == 0 || strcmp(what, "klok") == 0 || strcmp(what, "tas") == 0) {
            ret = cmd_examine(cp);
            if (ret != -2) return ret;
        }
        if (strcmp(what, "deur") == 0)
            return cmd_open_door();
    }

    return fail();
}

/* ------------------------------------------------------------------ */
/*  Initialization                                                     */
/* ------------------------------------------------------------------ */

static void init_data(void)
{
    int x;

    {
        struct { const char *sn, *desc; int loc; } obj_data[] = {
            {"ballon",      "neergestorte weerballon",     LOCATION_WEILAND},
            {"kachel",      "kleine houtkachel",           LOCATION_BINNENPLEIN},
            {"mand",        "grote rieten mand",          LOCATION_FOYER},
            {"houtblokken", "houtblokken",                LOC_GONE},
            {"koord",       "rol koord",                  LOCATION_ATRIUM},
            {"lucifers",    "doosje lucifers",            LOCATION_TUINKAMER},
            {"tas",         "grote tas",                  LOCATION_OVERLOOP},
            {"rubberboot",  "rubberboot",                  LOCATION_BINNENPLEIN},
            {"bord",        "bord",                        LOCATION_AFGRAVING},
            {"visnet",      "visnet",                      LOCATION_ROTSPAD},
            {"sportschoenen","sportschoenen",             LOCATION_SUPERMARKT},
            {"bijl",        "bijl",                       LOCATION_SUPERMARKT},
            {"zwembril",    "zwembril",                   LOC_GONE},
            {"zalm",        "zalm",                       LOCATION_ZUIDBAAI},
            {"beker",       "kristallen beker",           LOCATION_WIJNKELDER_OOST},
            {"fles",        "lege champagnefles",         LOCATION_GROT},
            {"boek",        "boek",                       LOCATION_STUDEERKAMER},
            {"schilderij",  "schilderij van Oom Wout",    LOCATION_OVERLOOP},
            {"snorkel",     "snorkel",                    LOC_GONE},
            {"landhuis",    "Korenvliet",                  LOCATION_HOOFDSTRAAT},
            {"landhuis",    "Korenvliet",                  LOCATION_BINNENPLEIN},
            {"schuur",      "oude verlaten schuur",       LOCATION_PLATEAU},
            {"tafel",       "houten tafel",               LOCATION_SCHUUR},
            {"klok",        "Friese staartklok",          LOCATION_STUDEERKAMER},
            {"kluis",       "kluis",                      LOC_GONE},
            {"kist",        "kist Chablis",               LOCATION_WIJNKELDER_WEST},
            {"bomen",       "bomen",                       LOCATION_BOS},
            {"deur",        "deur",                       LOCATION_TRAP},
            {"deur",        "deur",                       LOCATION_OVERLOOP},
            {"panter",      "een geimporteerde panter",   LOCATION_WIJNKELDER_WEST},
            {"winkel",      "supermarkt",                  LOCATION_HOOFDSTRAAT},
            {"trap",        "trap",                       LOCATION_WIJNKELDER_OOST},
            {"ziekenhuis",  "ziekenhuis",                  LOCATION_HOOFDSTRAAT},
        };
        for (x = 1; x <= MAX_OBJ; x++) {
            obj[x].short_name = obj_data[x-1].sn;
            obj[x].desc = obj_data[x-1].desc;
            obj[x].loc = (unsigned char)obj_data[x-1].loc;
        }
    }

    {
        const char *loc_desc[] = {
            "op het binnenplein",
            "in een bos",
            "in een weiland",
            "een glibberige kanaalkant",
            "de oever van een vijver",
            "op een braakliggend terrein",
            "op een rotspaadje",
            "de rand van een afgraving",
            "op de hoofdstraat",
            "in de supermarkt",
            "in het ziekenhuis",
            "in de foyer",
            "in de huiskamer",
            "in de studeerkamer",
            "in een tuinkamer",
            "op de overloop",
            "in het atrium",
            "westvleugel van wijnkelder",
            "oostvleugel van wijnkelder",
            "boven aan een trap",
            "een uitlaat van het riool",
            "een bocht in het riool",
            "vertakking in het riool",
            "een uitlaat van het riool",
            "een bocht in het riool",
            "een uitlaat in het riool",
            "een uitlaat in het riool",
            "op de vijver",
            "in de Zuidbaai",
            "onder het wateroppervlak",
            "onder het wateroppervlak",
            "een ondergrondse stroom",
            "in een grot",
            "in een heteluchtballon",
            "in een heteluchtballon",
            "op een plateau",
            "in een schuur",
        };
        for (x = 1; x <= MAX_LOC; x++)
            loc[x].desc = loc_desc[x-1];
    }

    {
        struct { int loc; char d1; int n1; char d2; int n2; char d3; int n3; } exit_data[] = {
            {LOCATION_BINNENPLEIN,  'w', LOCATION_BOS,  'z', LOCATION_KANAALKANT,  '-', 0},
            {LOCATION_BOS,  'o', LOCATION_BINNENPLEIN,  'z', LOCATION_WEILAND,  'n', LOCATION_HOOFDSTRAAT},
            {LOCATION_WEILAND,  'n', LOCATION_BOS,  'o', LOCATION_KANAALKANT,  '-', 0},
            {LOCATION_KANAALKANT,  'w', LOCATION_WEILAND,  'o', LOCATION_VIJVEROEVER,  'n', LOCATION_BINNENPLEIN},
            {LOCATION_VIJVEROEVER,  'w', LOCATION_KANAALKANT,  '-', 0,  '-', 0},
            {LOCATION_TERREIN,  'z', LOCATION_HOOFDSTRAAT,  'o', LOCATION_ROTSPAD,  '-', 0},
            {LOCATION_ROTSPAD,  'w', LOCATION_TERREIN,  'o', LOCATION_AFGRAVING,  '-', 0},
            {LOCATION_AFGRAVING,  'w', LOCATION_ROTSPAD,  '-', 0,  '-', 0},
            {LOCATION_HOOFDSTRAAT,  'z', LOCATION_BOS,  'n', LOCATION_TERREIN,  '-', 0},
            {LOCATION_SUPERMARKT, 'u', LOCATION_HOOFDSTRAAT,  '-', 0,  '-', 0},
            {LOCATION_ZIEKENHUIS, 'u', LOCATION_HOOFDSTRAAT,  '-', 0,  '-', 0},
            {LOCATION_FOYER, 'u', LOCATION_HOOFDSTRAAT,  'z', LOCATION_HUISKAMER, '-', 0},
            {LOCATION_HUISKAMER, 'n', LOCATION_FOYER, 'o', LOCATION_STUDEERKAMER, 'z', LOCATION_ATRIUM},
            {LOCATION_STUDEERKAMER, 'w', LOCATION_HUISKAMER, 'o', LOCATION_TUINKAMER, 'z', LOCATION_OVERLOOP},
            {LOCATION_TUINKAMER, 'w', LOCATION_STUDEERKAMER, '-', 0,  '-', 0},
            {LOCATION_OVERLOOP, 'n', LOCATION_STUDEERKAMER, 'w', LOCATION_ATRIUM, '-', 0},
            {LOCATION_ATRIUM, 'u', LOCATION_BINNENPLEIN,  'n', LOCATION_HUISKAMER, 'o', LOCATION_OVERLOOP},
            {LOCATION_WIJNKELDER_WEST, 'o', LOCATION_WIJNKELDER_OOST, '-', 0,  '-', 0},
            {LOCATION_WIJNKELDER_OOST, 'w', LOCATION_WIJNKELDER_WEST, 'h', LOCATION_TRAP, '-', 0},
            {LOCATION_TRAP, 'l', LOCATION_WIJNKELDER_OOST, '-', 0,  '-', 0},
            {LOCATION_RIOOL_21, 'u', LOCATION_HUISKAMER, 'z', LOCATION_RIOOL_22, '-', 0},
            {LOCATION_RIOOL_22, 'n', LOCATION_RIOOL_21, 'o', LOCATION_RIOOL_23, '-', 0},
            {LOCATION_RIOOL_23, 'w', LOCATION_RIOOL_22, 'n', LOCATION_RIOOL_24, 'z', LOCATION_RIOOL_25},
            {LOCATION_RIOOL_24, 'u', LOCATION_STUDEERKAMER, 'z', LOCATION_RIOOL_23, '-', 0},
            {LOCATION_RIOOL_25, 'n', LOCATION_RIOOL_23, 'w', LOCATION_RIOOL_26, '-', 0},
            {LOCATION_RIOOL_26, 'u', LOCATION_ATRIUM, 'l', LOCATION_RIOOL_27, 'o', LOCATION_RIOOL_25},
            {LOCATION_RIOOL_27, 'u', LOCATION_WIJNKELDER_WEST, 'h', LOCATION_RIOOL_26, '-', 0},
            {LOCATION_VIJVER, 'u', LOCATION_VIJVEROEVER,  'z', LOCATION_ZUIDBAAI, '-', 0},
            {LOCATION_ZUIDBAAI, 'n', LOCATION_VIJVER, '-', 0,  '-', 0},
            {LOCATION_ONDERWATER_30, 'u', LOCATION_VIJVER, 'z', LOCATION_ONDERWATER_31, '-', 0},
            {LOCATION_ONDERWATER_31, 'h', LOCATION_ZUIDBAAI, 'n', LOCATION_ONDERWATER_30, '-', 0},
            {LOCATION_STROOM, 'o', LOCATION_ONDERWATER_31, 'w', LOCATION_GROT, '-', 0},
            {LOCATION_GROT, 'o', LOCATION_STROOM, '-', 0,  '-', 0},
            {LOCATION_BALLON_STRAAT, 'u', LOCATION_AFGRAVING,  '-', 0,  '-', 0},
            {LOCATION_BALLON_PLATEAU, 'u', LOCATION_PLATEAU, '-', 0,  '-', 0},
            {LOCATION_PLATEAU, '-', 0,  '-', 0,  '-', 0},
            {LOCATION_SCHUUR, 'u', LOCATION_PLATEAU, '-', 0,  '-', 0},
        };
        for (x = 0; x < MAX_LOC; x++) {
            int lx = exit_data[x].loc;
            loc[lx].exits[0].dir = exit_data[x].d1;
            loc[lx].exits[0].dest = (unsigned char)exit_data[x].n1;
            loc[lx].exits[1].dir = exit_data[x].d2;
            loc[lx].exits[1].dest = (unsigned char)exit_data[x].n2;
            loc[lx].exits[2].dir = exit_data[x].d3;
            loc[lx].exits[2].dest = (unsigned char)exit_data[x].n3;
        }
    }

    /* Safe combination */
    for (x = 0; x < 3; x++) {
        int z = rand_range(SAFE_MIN, SAFE_MAX);
        snprintf(n[x], sizeof(n[x]), "%02d", z);
    }
}

/* ------------------------------------------------------------------ */
/*  Main                                                               */
/* ------------------------------------------------------------------ */
int main(void)
{
    char input[128];
    int line, result;

    setbuf(stdout, NULL);
    rng_state = 1;
    { const char *t = __TIME__; while (*t) { rng_state = rng_state * 37 + (unsigned char)*t; t++; } }
    if (rng_state == 0) rng_state = 1;

    printf("\n     K O R E N V L I E T\n\n");
    init_data();

    for (line = 0; help_text[line] != NULL; line++)
        printf("%s\n", help_text[line]);

    while (1) {
        display_location();

        while (1) {
            printf("\nWat nu    : ");
            if (fgets(input, sizeof(input), stdin) == NULL)
                return RET_REDRAW;
            chomp(input);

            result = handle_command(input);
            if (result == RET_EXIT) return RET_REDRAW;
            if (result == RET_REDRAW) break;
        }
    }

    return RET_REDRAW;
}
