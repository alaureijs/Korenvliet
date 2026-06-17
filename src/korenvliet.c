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
#include <time.h>
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

static int xsnprintf(char *buf, size_t size, const char *fmt, ...)
{
    int n;
    va_list ap;
    (void)size;
    va_start(ap, fmt);
    n = vsprintf(buf, fmt, ap);
    va_end(ap);
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

/* ------------------------------------------------------------------ */
/*  Object                                                             */
/* ------------------------------------------------------------------ */
typedef struct {
    char short_name[32];
    char desc[64];
    int  loc;               /* 0 = carried, 1..37 = location, 40 = gone */
} Object;

/* ------------------------------------------------------------------ */
/*  Exit descriptor                                                    */
/* ------------------------------------------------------------------ */
typedef struct {
    char dir;               /* n,o,z,w,u,l,h,- */
    int  dest;
} Exit;

/* ------------------------------------------------------------------ */
/*  Location                                                           */
/* ------------------------------------------------------------------ */
typedef struct {
    char desc[64];
    Exit exits[MAX_EXITS];
} Location;

/* ------------------------------------------------------------------ */
/*  Game state                                                         */
/* ------------------------------------------------------------------ */
static Object  obj[MAX_OBJ + 1];      /* 1-indexed */
static Location loc[MAX_LOC + 1];     /* 1-indexed */

static int  l  = 9;   /* current location */
static int  i  = 0;   /* # items carried */
static int  h  = 0;   /* balloon built */
static int  r  = 0;   /* rubber boat inflated */
static int  w  = 0;   /* jogging done (weight loss) */
static int  k  = 0;   /* door unlocked */
static int  v  = 0;   /* panther fed */
static int  f  = 0;   /* safe opened, testament readable */
static int  e  = 0;   /* painting examined, safe revealed */
static int  c1 = 0, c2 = 0, c3 = 0, c4 = 0;
static int  s  = 0;   /* sick / injured */
static int  hb = 0;   /* balloon part counter */

static char p[3][64];            /* misc messages */
static int  ve[9];               /* sewer locations */
static char n[4][4];             /* random numbers (strings) */
static char ss[4][4];            /* shuffled safe combo */
static int  sflags[4];           /* shuffle tracking */

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

/* Return random integer in [lo, hi] */
static int rand_range(int lo, int hi)
{
    return lo + rand() % (hi - lo + 1);
}

/* Remove trailing newline from a string */
static void chomp(char *s)
{
    size_t len = strlen(s);
    while (len > 0 && (s[len-1] == '\n' || s[len-1] == '\r'))
        s[--len] = '\0';
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
    if (obj[13].loc != 0 && (l == 30 || l == 31)) {
        printf("Niets bijzonders.\n");
        printf("\n");
        return;
    }

    col = 0;
    for (x = 1; x <= MAX_OBJ; x++) {
        if (obj[x].loc == l) {
            if (col + (int)strlen(obj[x].desc) > 38) {
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
    if (obj[13].loc == 0 && l == 31)
        printf("Een tunnel onder water.\n");
    if ((l == 13 && c1) || (l == 14 && c2) || (l == 17 && c3) || (l == 18 && c4))
        printf("putdeksel. ");
    if (l == 13 || l == 14 || l == 17 || l == 18)
        printf("afvoer.\n");
    if (h && (l == 8 || l == 36))
        printf("hetelucht ballon.\n");

    /* Random atmospheric descriptions */
    {
        int z = rand_range(1, 10);
        if (l == 6 && z == 1)
            printf("Adriaan met twee staven dynamiet.\n");
        if (l == 3 && z == 3)
            printf("Zoete met een koppel bloedhonden.\n");
        if (l == 7 && z == 5)
            printf("Berend met een bulldozer.\n");
        if (l == 33 && z < 5)
            printf("Er vliegt een vleermuis langs.\n");
        if (l == 27 && z < 3)
            printf("Er zit spinrag in Uw haar.\n");
        if (l == 25 && z < 3)
            printf("Een rat strijkt langs Uw been.\n");
        if (l == 4 && z == 7)
            printf("Een pad springt in het kanaal.\n");
        if (l == 28 && obj[14].loc == 0 && z < 5)
            printf("Een hongerige meeuw cirkelt rond.\n");
        if (l == 2 && z == 8)
            printf("Een aapachtig figuur kijkt op U neer.\n");
    }
}

/* ------------------------------------------------------------------ */
/*  Command handlers - each returns: 0 = redisplay, 1 = prompt only    */
/*  (no location redisplay), -1 = exit game                            */
/* ------------------------------------------------------------------ */

static int cmd_stop(void)
{
    printf("Stoppen...\n");
    return -1;
}

static int cmd_inventory(void)
{
    int x, col = 0;
    printf("Inventaris:\n");
    for (x = 1; x <= MAX_INV; x++) {
        if (obj[x].loc == 0) {
            if (col + (int)strlen(obj[x].desc) > 38) {
                printf("\n");
                col = 0;
            }
            printf("%s. ", obj[x].desc);
            col += (int)strlen(obj[x].desc) + 2;
        }
    }
    printf("\n");
    return 1;
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
    if (idx == 0) return -1;
    if (obj[idx].loc == 0) { printf("Dat heeft U al.\n"); return 1; }
    if (obj[idx].loc == l) { obj[idx].loc = 0; i++; return 0; }
    return -1;
}

static int cmd_take(char *arg)
{
    if (strncasecmp(arg, "pak ", 4) == 0)
        memmove(arg, arg + 4, strlen(arg) - 3);
    else if (strncasecmp(arg, "neem ", 5) == 0)
        memmove(arg, arg + 5, strlen(arg) - 4);

    /* Specific checks before generic handling */
    if (strcasecmp(arg, "zalm") == 0 && l == 29 && obj[10].loc != 0) {
        printf("Die glipte uit Uw vingers.\n");
        return 1;
    }
    if (strcasecmp(arg, "schilderij") == 0 && l == 16) {
        printf("Te kostbaar.\n");
        return 1;
    }
    if (l == 10) {
        printf("Pleeg geen winkeldiefstal!\n");
        return 1;
    }
    if (strcasecmp(arg, "tafel") == 0 && l == 37) {
        printf("Die zit vastgespijkerd.\n");
        return 1;
    }
    if (i >= 4) {
        printf("U draagt teveel bij U.\n");
        return 1;
    }

    /* Bril (zwembril, obj 13) */
    if (strcasecmp(arg, "bril") == 0) {
        if (obj[13].loc == 0) { printf("Heeft U al.\n"); return 1; }
        if (obj[13].loc == 40 && l == 14) { obj[13].loc = 0; i++; return 0; }
        if (obj[13].loc == l) { obj[13].loc = 0; i++; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    /* Snorkel (obj 19) */
    if (strcasecmp(arg, "snorkel") == 0) {
        if (obj[19].loc == 0) { printf("Heeft U al.\n"); return 1; }
        if (obj[19].loc == 40 && (obj[7].loc == 0 || obj[7].loc == l)) {
            obj[19].loc = 0; i++; return 0;
        }
        if (obj[19].loc == l) { obj[19].loc = 0; i++; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    /* Generic take */
    {
        int idx = find_obj_by_name(arg, MAX_INV);
        if (idx == 0) {
            if (strcasecmp(arg, "panter") == 0 && obj[30].loc == l) {
                printf("U had nog net genoeg kracht om\nweg te komen.\n");
                s = 1; l = 11;
                return 0;
            }
            if (strcasecmp(arg, "klok") == 0 && l == 14) {
                printf("Te zwaar.\n"); return 1;
            }
            if (strcasecmp(arg, "kist") == 0 && obj[26].loc == l) {
                printf("Ik heb geen dorst.\n"); return 1;
            }
            if (strcasecmp(arg, "kluis") == 0 && obj[25].loc == l) {
                printf("De kluis zit aan de muur vast.\n"); return 1;
            }
            printf("Ik begrijp U niet.\n");
            return 1;
        }
        return generic_take_item(idx);
    }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_drop(char *arg)
{
    int x;

    /* "leg snorkel" special */
    if (strncasecmp(arg, "leg snorkel", 11) == 0) {
        if (obj[19].loc != 0) { printf("Heeft U niet.\n"); return 1; }
        if (l > 27 && l < 32) { printf("Neem het snel terug!\n"); return 1; }
        obj[19].loc = l; i--; return 0;
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
                if (x == 8 && (l == 28 || l == 29)) {
                    obj[8].loc = 5; i--;
                    printf("De boot drijft weg.....\n");
                    return 0;
                }
                i--;
                obj[x].loc = (l == 28 || l == 29) ? l + 2 : l;
                return 0;
            }
        }
    }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_go(const char *arg)
{
    int x;
    char dir;

    if (strncasecmp(arg, "ga ", 3) == 0)
        arg += 3;
    else if (strncasecmp(arg, "ga", 2) == 0)
        arg += 2;

    dir = tolower((unsigned char)*arg);

    if (strncasecmp(arg, "noord", 5) == 0) dir = 'n';
    else if (strncasecmp(arg, "oost", 4) == 0) dir = 'o';
    else if (strncasecmp(arg, "zuid", 4) == 0) dir = 'z';
    else if (strncasecmp(arg, "west", 4) == 0) dir = 'w';
    else if (strncasecmp(arg, "uit", 3) == 0) dir = 'u';
    else if (strncasecmp(arg, "omhoog", 6) == 0) dir = 'h';
    else if (strncasecmp(arg, "omlaag", 6) == 0) dir = 'l';

    if (dir == 'o' && l == 18) {
        if (v == 0) { printf("Panter laat dat niet toe.\n"); return 1; }
        l = 19; return 0;
    }

    for (x = 0; x < MAX_EXITS; x++) {
        if (loc[l].exits[x].dir == dir) {
            l = loc[l].exits[x].dest;
            return 0;
        }
    }
    printf("Richting niet duidelijk.\n");
    return 1;
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
        for (x = 1; x <= 8; x++) {
            if (ve[x] == l) { found = 1; break; }
        }
        if (!found) { printf("Ik begrijp U niet.\n"); return 1; }
        if (obj[8].loc == 0 && r == 1) {
            printf("%s\n", p[1]); return 1;
        }
        {
            int y;
            for (y = 1; y <= 4; y++) {
                if (obj[y].loc == 0) { printf("%s\n", p[1]); return 1; }
            }
        }
        if ((l == 13 && c1 == 0) || (l == 14 && c2 == 0) ||
            (l == 17 && c3 == 0) || (l == 18 && c4 == 0)) {
            printf("%s\n", p[0]); return 1;
        }
        if (w == 0) { printf("U bent te dik.\n"); return 1; }
        if (l == 13 && c1) { l = 21; return 0; }
        if (l == 14 && c2) { l = 24; return 0; }
        if (l == 17 && c3) { l = 26; return 0; }
        if (l == 18 && c4) { l = 27; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    if (strcasecmp(place, "ballon") == 0) {
        if (h == 0) { printf("Nog niet klaar.\n"); return 1; }
        if (l == 8)  { l = 34; return 0; }
        if (l == 36) { l = 35; return 0; }
        printf("Ik kan het niet vinden.\n");
        return 1;
    }

    if (strcasecmp(place, "vijver") == 0) {
        if (l != 5) { printf("Ik begrijp U niet.\n"); return 1; }
        if (obj[8].loc != 0) { printf("Ik moet ergens op kunnen drijven.\n"); return 1; }
        if (r == 0) { printf("Rubberboot is te slap.\n"); return 1; }
        l = 28; return 0;
    }

    if (strcasecmp(place, "winkel") == 0 || strcasecmp(place, "supermarkt") == 0) {
        if (l != 9) { printf("Ik begrijp U niet.\n"); return 1; }
        {
            int x;
            for (x = 1; x <= MAX_INV; x++) {
                if (obj[x].loc == 0) {
                    printf("U kunt de winkel niet binnen met alles wat U bij zich heeft.\n");
                    return 1;
                }
            }
        }
        l = 10; return 0;
    }

    if (strcasecmp(place, "landhuis") == 0 || strcasecmp(place, "korenvliet") == 0) {
        if (l == 9)  { l = 12; return 0; }
        if (l == 1)  { l = 17; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    if (strcasecmp(place, "ziekenhuis") == 0) {
        if (l == 9) { l = 11; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    if (strcasecmp(place, "tunnel") == 0) {
        if (l == 31 && obj[13].loc == 0) { l = 32; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    if (strcasecmp(place, "kanaal") == 0) {
        if (l == 4) {
            printf("U gleed uit en viel.\n");
            s = 1; l = 11;
            return 0;
        }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    if (strcasecmp(place, "afgraving") == 0) {
        if (l == 8) { printf("Te steil.\n"); return 1; }
        printf("Ik begrijp U niet.\n");
        return 1;
    }

    if (strcasecmp(place, "schuur") == 0) {
        if (l == 36) { l = 37; return 0; }
        printf("Ik begrijp U niet.\n");
        return 1;
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
    if (x == 0) { printf("Ik begrijp U niet.\n"); return 1; }

    if (strcasecmp(obj[x].short_name, "fles") == 0) {
        printf("%s %s\n", p[2], n[1]); return 1;
    }
    if (strcasecmp(obj[x].short_name, "beker") == 0) {
        printf("%s %s\n", p[2], n[2]); return 1;
    }
    if (strcasecmp(obj[x].short_name, "tafel") == 0) {
        printf("Er ligt een briefje met het nummer %s\n", n[3]); return 1;
    }
    if (strcasecmp(obj[x].short_name, "kist") == 0) {
        printf("Er ontbreekt een fles.\n"); return 1;
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
        return 0;
    }
    if (strcasecmp(obj[x].short_name, "klok") == 0 && obj[13].loc == 40) {
        printf("Er zit een duikbril in.\n"); return 1;
    }
    if (strcasecmp(obj[x].short_name, "tas") == 0 && obj[19].loc == 40) {
        printf("Er zit een snorkel in.\n"); return 1;
    }
    if (strcasecmp(obj[x].short_name, "schilderij") == 0) {
        printf("Er zit een kluis achter!\n");
        e = 1;
        obj[25].loc = l;
        return 1;
    }
    printf("Niets bijzonders.\n");
    return 1;
}

static int cmd_jog(void)
{
    if (obj[11].loc != 0) { printf("Ik heb schoenen nodig.\n"); return 1; }
    if (l > 9) { printf("Ik kan hier niet joggen.\n"); return 1; }
    w = 1;
    printf("Pfff... Klaar!\n");
    return 1;
}

static int cmd_go_up(void)
{
    int x;
    if (s == 1) { printf("Ik voel me niet goed.\n"); return 1; }
    if ((l == 21 && c1 == 0) || (l == 24 && c2 == 0) ||
        (l == 26 && c3 == 0) || (l == 27 && c4 == 0)) {
        printf("%s\n", p[0]); return 1;
    }
    for (x = 0; x < MAX_EXITS; x++) {
        if (loc[l].exits[x].dir == 'u') {
            l = loc[l].exits[x].dest;
            return 0;
        }
    }
    printf("Richting niet duidelijk.\n");
    return 1;
}

static int cmd_panther(void)
{
    if (v == 1) { printf("Ik begrijp U niet.\n"); return 1; }
    if (l != 18) { printf("Ik begrijp U niet.\n"); return 1; }
    if (obj[14].loc != 0) { printf("U hebt voedsel nodig.\n"); return 1; }
    printf("Panter ontsnapte met de zalm.\n");
    if (obj[14].loc == 0) i--;
    v = 1;
    obj[14].loc = 40;
    obj[30].loc = 40;
    return 0;
}

static int cmd_cut_tree(void)
{
    if (l == 2 && (obj[12].loc == 0 || obj[12].loc == l)) {
        obj[4].loc = 2;
        return 0;
    }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_climb_tree(void)
{
    if (l != 2) { printf("Ik begrijp U niet.\n"); return 1; }
    printf("U viel eraf.\n");
    s = 1; l = 11;
    return 0;
}

static int cmd_dive(void)
{
    if (l == 28 || l == 29) {
        if (obj[19].loc == 0) {
            l += 2;
            return 0;
        }
        printf("U hebt een snorkel nodig.\n");
        return 1;
    }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_remove_cover(void)
{
    if (l == 13 || l == 21) { c1 = 1; return 0; }
    if (l == 14 || l == 24) { c2 = 1; return 0; }
    if (l == 17 || l == 26) { c3 = 1; return 0; }
    if (l == 18 || l == 27) { c4 = 1; return 0; }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_open_door(void)
{
    if (l == 16 || l == 20) {
        if (l == 16 && k == 0) {
            printf("Gaat niet. De deur is aan de andere kant vergrendeld.\n");
            return 1;
        }
        printf("OK.\n");
        return 1;
    }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_open_safe(void)
{
    char input[64], f1[16], f2[16], f3[16];
    char sum1[64], sum2[64];

    if (e == 0) { printf("U kunt het niet vinden.\n"); return 1; }
    if (l != 16) { printf("Is hier niet.\n"); return 1; }

    printf("Combinatieslot.\n");
    printf("Type het eerste getal  - ");
    if (fgets(input, sizeof(input), stdin) == NULL) return 1;
    chomp(input); strcpy(f1, input);
    if (strcmp(f1, ss[1]) != 0) { printf("Fout.\n"); return 1; }

    printf("Type tweede getal  - ");
    if (fgets(input, sizeof(input), stdin) == NULL) return 1;
    chomp(input); strcpy(f2, input);
    snprintf(sum1, sizeof(sum1), "%s%s", f1, f2);
    snprintf(sum2, sizeof(sum2), "%s%s", ss[1], ss[2]);
    if (strcmp(sum1, sum2) != 0) { printf("Fout.\n"); return 1; }

    printf("Type het laatste getal  - ");
    if (fgets(input, sizeof(input), stdin) == NULL) return 1;
    chomp(input); strcpy(f3, input);
    snprintf(sum1, sizeof(sum1), "%s%s%s", f1, f2, f3);
    snprintf(sum2, sizeof(sum2), "%s%s%s", ss[1], ss[2], ss[3]);
    if (strcmp(sum1, sum2) == 0) {
        f = 1;
        printf("\nKlik........ Er zit een testament in.\n");
    } else {
        printf("Fout.\n");
    }
    return 1;
}

static int cmd_inflate_boat(void)
{
    if (l != 5) { printf("Niet hier.\n"); return 1; }
    if (r == 1) { printf("Is al opgeblazen.\n"); return 1; }
    printf("OK.\n"); r = 1; return 1;
}

static int cmd_build_balloon(void)
{
    int x;
    if (l != 8) { printf("Niet hier.\n"); return 1; }
    hb = 0;
    for (x = 1; x <= 6; x++) {
        if (obj[x].loc == 0 || obj[x].loc == 8) hb++;
    }
    if (hb != 6) { printf("Niet klaar.\n"); hb = 0; return 1; }
    for (x = 1; x <= 6; x++) {
        if (obj[x].loc == 0) i--;
        obj[x].loc = 40;
    }
    h = 1;
    return 0;
}

static int cmd_fly_balloon(void)
{
    int y, z;
    if (h == 0) { printf("Niet klaar.\n"); return 1; }
    if (l == 80 || l == 36) { printf("U moet er eerst in.\n"); return 1; }

    if (l == 35) {
        for (y = 29; y >= 5; y -= 6) {
            z = 3 + abs(5 * y - 85) / 6;
            printf("Ballon op hoogte %d...\n", z);
        }
        l = 34; return 0;
    }
    if (l == 34) {
        for (y = 5; y <= 29; y += 6) {
            z = 3 + abs(5 * y - 85) / 6;
            printf("Ballon op hoogte %d...\n", z);
        }
        l = 35; return 0;
    }
    printf("Ik begrijp U niet.\n");
    return 1;
}

static int cmd_read_will(void)
{
    if (f != 1) { printf("Ik begrijp U niet.\n"); return 1; }
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
    return -1;
}

static int cmd_read_sign(void)
{
    if (obj[9].loc == 0 || obj[9].loc == l) {
        printf("Op het bord staat: Een goede plaats.\n");
        return 1;
    }
    printf("Kunt het niet vinden.\n");
    return 1;
}

static int cmd_door(void)
{
    if (l == 16 && k == 0) { printf("De deur is op slot.\n"); return 1; }
    if (l == 20) { l = 16; k = 1; return 0; }
    if (l == 16) { l = 20; return 0; }
    printf("Ik begrijp U niet.\n");
    return 1;
}

/* ------------------------------------------------------------------ */
/*  Main command dispatcher                                            */
/* ------------------------------------------------------------------ */
static int handle_command(const char *cmd)
{
    char buf[128];
    char *p;
    size_t ci;
    int ret;

    for (ci = 0; ci < sizeof(buf) - 1 && cmd[ci]; ci++)
        buf[ci] = tolower((unsigned char)cmd[ci]);
    buf[ci] = '\0';

    p = buf;
    while (*p == ' ') p++;
    if (*p == '\0') return 1;

    /* Convert "ga naar X" to "ga in X" */
    if (strncmp(p, "ga naar ", 8) == 0) {
        memmove(p + 6, p + 8, strlen(p + 8) + 1);
        p[3] = 'i'; p[4] = 'n'; p[5] = ' ';
    }

    if (strcmp(p, "stop") == 0 || strcmp(p, "halt") == 0)
        return cmd_stop();

    if (strcmp(p, "help") == 0) {
        int h;
        for (h = 0; help_text[h] != NULL; h++)
            printf("%s\n", help_text[h]);
        return 0;
    }

    if (strcmp(p, "inventaris") == 0)
        return cmd_inventory();

    if (s == 1 && (strcmp(p, "gezondheid") == 0 || strcmp(p, "wordt beter") == 0 || strcmp(p, "beterschap") == 0)) {
        s = 0; printf("Genezen.\n"); return 1;
    }

    if (strncmp(p, "ga jog", 6) == 0 || strncmp(p, "ga trim", 7) == 0)
        return cmd_jog();

    if (strcmp(p, "ga door deur") == 0)
        return cmd_door();

    ret = cmd_enter(p);
    if (ret != -2) return ret;

    if (strcmp(p, "ga u") == 0 || strcmp(p, "ga uit") == 0)
        return cmd_go_up();

    if (strcmp(p, "ga o") == 0 && l == 32) {
        if (obj[19].loc != 0) {
            printf("U heeft een snorkel nodig.\n");
            return 1;
        }
    }

    if (strncmp(p, "ga ", 3) == 0 || (strlen(p) == 1 && strchr("nozwulh", *p))) {
        char tmp[16];
        if (strlen(p) == 1 && strchr("nozwulh", *p)) {
            snprintf(tmp, sizeof(tmp), "ga %c", *p);
            return cmd_go(tmp);
        }
        return cmd_go(p);
    }

    if (strncmp(p, "neem ", 5) == 0 || strncmp(p, "pak ", 4) == 0)
        return cmd_take(p);

    if (strncmp(p, "leg ", 4) == 0)
        return cmd_drop(p);

    if (strncmp(p, "koop ", 5) == 0 && l == 10) {
        int idx;
        char *item = p + 5;
        while (*item == ' ') item++;
        idx = find_obj_by_name(item, MAX_INV);
        if (idx == 0) { printf("Ik begrijp U niet.\n"); return 1; }
        return generic_take_item(idx);
    }

    if (strcmp(p, "verwijder deksel") == 0 || strcmp(p, "open afvoer") == 0)
        return cmd_remove_cover();

    if (strcmp(p, "open deur") == 0)
        return cmd_open_door();

    if (strcmp(p, "maak kluis open") == 0 || strcmp(p, "open kluis") == 0)
        return cmd_open_safe();

    if (strcmp(p, "blaas boot op") == 0)
        return cmd_inflate_boat();

    if (strcmp(p, "blaas ballon op") == 0 || strcmp(p, "bouw ballon") == 0)
        return cmd_build_balloon();

    if (strcmp(p, "vlieg met ballon") == 0 || strcmp(p, "zeil met ballon") == 0)
        return cmd_fly_balloon();

    if (strcmp(p, "lees testament") == 0 && f == 1)
        return cmd_read_will();

    if (strcmp(p, "lees boek") == 0)
        return cmd_examine("bekijk boek");

    if (strcmp(p, "lees bord") == 0)
        return cmd_read_sign();

    if (strcmp(p, "voer panter") == 0 || strcmp(p, "geef zalm") == 0)
        return cmd_panther();

    if (strstr(p, "boom") || strstr(p, "bomen")) {
        if (strncmp(p, "hak", 3) == 0 || strncmp(p, "snij", 4) == 0)
            return cmd_cut_tree();
    }

    if (strncmp(p, "klim", 4) == 0)
        return cmd_climb_tree();

    if (strncmp(p, "duik", 4) == 0)
        return cmd_dive();

    if (strncmp(p, "onderzoek ", 10) == 0 || strncmp(p, "bekijk ", 7) == 0) {
        ret = cmd_examine(p);
        if (ret != -2) return ret;
    }

    if (strncmp(p, "open ", 5) == 0) {
        const char *what = p + 5;
        while (*what == ' ') what++;
        if (strcmp(what, "boek") == 0 || strcmp(what, "klok") == 0 || strcmp(what, "tas") == 0) {
            ret = cmd_examine(p);
            if (ret != -2) return ret;
        }
        if (strcmp(what, "deur") == 0)
            return cmd_open_door();
    }

    printf("Ik begrijp U niet.\n");
    return 1;
}

/* ------------------------------------------------------------------ */
/*  Initialization                                                     */
/* ------------------------------------------------------------------ */

static void init_data(void)
{
    int x;

    {
        struct { const char *sn, *desc; int loc; } obj_data[] = {
            {"ballon",      "neergestorte weerballon",     3},
            {"kachel",      "kleine houtkachel",           1},
            {"mand",        "grote rieten mand",          12},
            {"houtblokken", "houtblokken",                40},
            {"koord",       "rol koord",                  17},
            {"lucifers",    "doosje lucifers",            15},
            {"tas",         "grote tas",                  16},
            {"rubberboot",  "rubberboot",                  1},
            {"bord",        "bord",                        8},
            {"visnet",      "visnet",                      7},
            {"sportschoenen","sportschoenen",             10},
            {"bijl",        "bijl",                       10},
            {"zwembril",    "zwembril",                   40},
            {"zalm",        "zalm",                       29},
            {"beker",       "kristallen beker",           19},
            {"fles",        "lege champagnefles",         33},
            {"boek",        "boek",                       14},
            {"schilderij",  "schilderij van Oom Wout",    16},
            {"snorkel",     "snorkel",                    40},
            {"landhuis",    "Korenvliet",                  9},
            {"landhuis",    "Korenvliet",                  1},
            {"schuur",      "oude verlaten schuur",       36},
            {"tafel",       "houten tafel",               37},
            {"klok",        "Friese staartklok",          14},
            {"kluis",       "kluis",                      40},
            {"kist",        "kist Chablis",               18},
            {"bomen",       "bomen",                       2},
            {"deur",        "deur",                       20},
            {"deur",        "deur",                       16},
            {"panter",      "een geimporteerde panter",   18},
            {"winkel",      "supermarkt",                  9},
            {"trap",        "trap",                       19},
            {"ziekenhuis",  "ziekenhuis",                  9},
        };
        for (x = 1; x <= MAX_OBJ; x++) {
            strcpy(obj[x].short_name, obj_data[x-1].sn);
            strcpy(obj[x].desc, obj_data[x-1].desc);
            obj[x].loc = obj_data[x-1].loc;
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
            "een uitlaat van een riool",
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
            strcpy(loc[x].desc, loc_desc[x-1]);
    }

    {
        struct { int loc; char d1; int n1; char d2; int n2; char d3; int n3; } exit_data[] = {
            {1,  'w', 2,  'z', 4,  '-', 0},
            {2,  'o', 1,  'z', 3,  'n', 9},
            {3,  'n', 2,  'o', 4,  '-', 0},
            {4,  'w', 3,  'o', 5,  'n', 1},
            {5,  'w', 4,  '-', 0,  '-', 0},
            {6,  'z', 9,  'o', 7,  '-', 0},
            {7,  'w', 6,  'o', 8,  '-', 0},
            {8,  'w', 7,  '-', 0,  '-', 0},
            {9,  'z', 2,  'n', 6,  '-', 0},
            {10, 'u', 9,  '-', 0,  '-', 0},
            {11, 'u', 9,  '-', 0,  '-', 0},
            {12, 'u', 9,  'z', 13, '-', 0},
            {13, 'n', 12, 'o', 14, 'z', 17},
            {14, 'w', 13, 'o', 15, 'z', 16},
            {15, 'w', 14, '-', 0,  '-', 0},
            {16, 'n', 14, 'w', 17, '-', 0},
            {17, 'u', 1,  'n', 13, 'o', 16},
            {18, 'o', 19, '-', 0,  '-', 0},
            {19, 'w', 18, 'h', 20, '-', 0},
            {20, 'l', 19, '-', 0,  '-', 0},
            {21, 'u', 13, 'z', 22, '-', 0},
            {22, 'n', 21, 'o', 23, '-', 0},
            {23, 'w', 22, 'n', 24, 'z', 25},
            {24, 'u', 14, 'z', 23, '-', 0},
            {25, 'n', 23, 'w', 26, '-', 0},
            {26, 'u', 17, 'l', 27, 'o', 25},
            {27, 'u', 18, 'h', 26, '-', 0},
            {28, 'u', 5,  'z', 29, '-', 0},
            {29, 'n', 28, '-', 0,  '-', 0},
            {30, 'u', 28, 'z', 31, '-', 0},
            {31, 'h', 29, 'n', 30, '-', 0},
            {32, 'o', 31, 'w', 33, '-', 0},
            {33, 'o', 32, '-', 0,  '-', 0},
            {34, 'u', 8,  '-', 0,  '-', 0},
            {35, 'u', 36, '-', 0,  '-', 0},
            {36, '-', 0,  '-', 0,  '-', 0},
            {37, 'u', 36, '-', 0,  '-', 0},
        };
        for (x = 0; x < 37; x++) {
            int lx = exit_data[x].loc;
            loc[lx].exits[0].dir = exit_data[x].d1;
            loc[lx].exits[0].dest = exit_data[x].n1;
            loc[lx].exits[1].dir = exit_data[x].d2;
            loc[lx].exits[1].dest = exit_data[x].n2;
            loc[lx].exits[2].dir = exit_data[x].d3;
            loc[lx].exits[2].dest = exit_data[x].n3;
        }
    }

    strcpy(p[0], "uitlaat is afgedekt");
    strcpy(p[1], "er past iets niet");
    strcpy(p[2], "binnenin is een briefje met nummer");

    {
        int ve_data[] = { 0, 13, 14, 17, 18, 21, 24, 26, 27 };
        for (x = 1; x <= 8; x++)
            ve[x] = ve_data[x];
    }

    /* Safe combination */
    for (x = 1; x <= 3; x++) {
        int z = rand_range(10, 100);
        snprintf(n[x], sizeof(n[x]), "%02d", z);
        printf("Getal %d: %s\n", x, n[x]);
    }
    for (x = 1; x <= 3; x++) {
        int z = x;
        while (sflags[z] == z) z = x;
        {
            size_t nlen = strlen(n[x]);
            if (nlen >= 2)
                strcpy(ss[z], n[x] + nlen - 2);
            else
                snprintf(ss[z], sizeof(ss[z]), "%s", n[x]);
        }
        sflags[z] = z;
        printf("Code %d: %s\n", z, ss[z]);
    }
}

/* ------------------------------------------------------------------ */
/*  Main                                                               */
/* ------------------------------------------------------------------ */
int main(void)
{
    char input[128];
    int h, result;

    setbuf(stdout, NULL);
    srand((unsigned int)time(NULL));

    printf("\n     K O R E N V L I E T\n\n");
    init_data();

    for (h = 0; help_text[h] != NULL; h++)
        printf("%s\n", help_text[h]);

    while (1) {
        display_location();

        while (1) {
            printf("\nWat nu    : ");
            if (fgets(input, sizeof(input), stdin) == NULL)
                return 0;
            chomp(input);

            result = handle_command(input);
            if (result == -1) return 0;
            if (result == 0) break;
        }
    }

    return 0;
}
