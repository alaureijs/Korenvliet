10 rem basicode 2 routines for c64 and commander x16
11 goto 1000:rem jump to init
20 rv=rnd(-ti)
21 rem see if screen width = 40 and number of lines
22 oc=79
23 poke783,1:sys65520:o0=peek(781)
24 printtab(39);"  ";
25 poke783,1:sys65520
26 if peek(781)>o0 then oc=39
27 poke781,23:poke782,0:poke783,0:sys65520
28 ol=peek(781)
29 print:poke783,1:sys65520
30 if peek(781)>ol then 28
31 goto 1010:rem jump to start program
100 rem clear screen, upper/lower case
101 print chr$(147);chr$(14);
102 return
110 REM Set cursor to position given by the variables HO and VE.
111 if ho>oc then ho=39:rem set cursor position
112 if ve>ol then ve=ol
113 poke781,ve:poke782,ho:poke783,0
114 sys65520:return
120 rem read cursor position HO and VE
121 poke783,1
122 sys65520
123 ve=peek(781):ho=pos(782)
124 if ho>oc then ho=ho-oc-1
125 return
200 REM Read key stroke and return it in IN$.
201 REM no key pressed: IN$=""
202 REM IN$ holds only capital letters
203 get in$
204 return
210 REM Wait and read the pressed key and return it in IN$ (see also line 200)
211 get in$:if in$="" then 210:rem wait for key from the keyboard
213 return
250 print chr$(7):return:rem beep
260 rv=rnd(1):return:rem return random number
270 fr=fre(0):rem return amount of free memory
271 if fr<0 then fr=32767
272 return
280 return: REM Disable the stop/break key (FR=1) or enable or (FR=0).
300 sr$=str$(sr):rem convert number to string
301 if left$(sr$,1)="." then sr$="0"+sr$
302 if left$(sr$,1)=" " then sr$=mid$(sr$,2,255)
303 return
310 sr$=str$(sr):rem convert number to a fixed width string
311 return
350 return:rem print to printer, not implemented
360 return:rem newline on printer, not implemented
400 rem Produce a tone using SP, SD and SV
401 rem SP is frequency level: 0 = lowest, 60='central C', 127 = highest
402 rem SD is the tone duration in steps of 0.1 seconds
403 rem SV is the volume: 0=muted 7=medium, 15=loud
404 rem This subroutine keeps running during the time of SD.
405 return
450 rem Wait SD*0.1 seconds or for a key stroke
451 rem When ended: IN$ and IN contain the possible keystroke (see for special codes line 200). SD contains the remaining time from the moment the key was pressed or zero (if no key was pressed)
452 return
500 rem Open the file NF$ according to the code in NF:
501 rem NF = even number: input: NF= uneven number: output
502 rem    NF= 0 or 1 BASICODE cassette
503 rem    NF= 2 or 3 own system memory
504 rem    NF= 4 or 5 diskette
505 rem    NF= 6 or 7 diskette
506 rem    IN=0: all OK, IN=1: end of file, IN=-1: error
507 return
540 return: Read into IN$ from the opened file NF$ (in IN the status, see line 500)
560 return: Send SR$ towards the opened file NF$ (in IN the status, see line 500)
580 return: Close the file with code NF
600 return: Switch to graphic screen and clear graphic screen
610 return: Plot a point at graphic position HO,VE (0<=HO<1 en 0<=VE<1) in fore/background color CN (=0/1; normally white/black)
630 return: Draw a line towards point HO,VE (0<=HO<1 en 0<=VE<1) in fore/background color CN (=0/1; normally white/black)
650 return: Print SR$ as text from graphic position HO,VE (0<=HO<1 en 0<=VE<1). HO and VE stay the same value.

800 IN$="":A%=1: ML%=21
801 CS$=chr$(95)+chr$(157):IF IN$<>"" THEN A%=42
802 PRINT IN$CS$;
810 J= PEEK(56320) AND 127: GET ES$:IF J=127 AND ES$="" THEN 810
811 IF J<>127 THEN 830
812 PRINT CS$;:E= ASC(ES$):IF (E<45 OR E>57) AND (E<65 OR E>93) AND E<>13 AND E<>20 AND E<>32 THEN 810
814 IF E=13 THEN PRINT" "CHR$(157);: RETURN
816 IF E=20 AND LEN(IN$)>0 THEN IN$= LEFT$(IN$, LEN(IN$)-1): PRINT CHR$(157);CS$;CHR$(29);" ";CHR$(157);CHR$(157);: GOTO 810
818 IF LEN(IN$)<=ML% AND E<>20 THEN IN$=IN$+ES$: PRINT ES$CS$;
820 GOTO 810
829 REM *** THE FOLLOWING IS ONLY NEEDED FOR JOYSTICK
830 IF J<>119 AND J<>123 THEN 810
831 E=1:IF LEN(IN$)=ML% OR J=123 OR A%=42 THEN E=41
833 A$=MID$("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.- "+CHR$(95)+CHR$(94),E,1):PRINT A$;CHR$(157);
835 FOR TW=0 TO 500: NEXT
840 J=PEEK(56320) AND 127: GET ES$:IF J=127 AND ES$="" THEN 840
841 IF ES$<>"" THEN 812
842 IF J=111 THEN 850                    : rem Down+Right
844 IF J=119 THEN E=E+1:IF E>41 THEN E=1 : rem Down+Left
846 IF J=123 THEN E=E-1:IF E<1 THEN E=41 : rem Left
848 GOTO 833
850 FOR TW=0 TO 500: NEXT: IF E=40 THEN ES$=CHR$(20):GOTO 812
852 IF E=41 THEN E=13: GOTO 814
854 ES$=A$: GOTO 812

950 rem stop
951 stop
1000 A=1000 : GOTO 20
1010 Rem Korenvliet
1020 DIM NR(201),DT(201)
1020 goto 9610
1030 FOR X = 1 TO 9000: NEXT: rem wacht een seconde
1040 gosub 100 : PRINT "Plaats    : ";::PRINT L$(L)"."
1050 PRINT : PRINT "Uitgangen : ";: FOR X = 1 TO 3: GOSUB 5000:PRINT " ";:NEXT : print
1060 PRINT : PRINT "U ziet    : ";:
1070 IF O(13) <> 0 AND (L = 30 OR L = 31) THEN 1190
1079 rem: list objecten
1080 FOR X = 1 TO 33: IF O(X) <> L THEN 1100
1085   IF POS(0) + LEN(O$(X)) > 38 THEN :PRINT: PRINT TAB(12);
1090   PRINT O$(X)". ";
1100 NEXT :PRINT :PRINT: GOSUB 5200
1190 rem
1192 print: print"Wat nu    : ";:GOSUB 800: C$=IN$: PRINT
1195 IF S = 1 THEN 6000
1199 IF LEFT$(C$,3) = "pak" THEN c$ = "neem" + right$(C$,4, len(c$))
1200 IF LEFT$(C$,4) = "neem" THEN 2030
1210 IF LEFT$(C$,11) = "leg snorkel" THEN 3640
1220 IF LEFT$(C$,3) = "leg" THEN 2190
1230 IF RIGHT$(C$,10) = "inventaris" THEN 2350
1235 G = LEN(C$)-7:IF G > 0 AND MID$(C$,4,4) = "naar" THEN C$ = LEFT$(C$,3) + "in" +  RIGHT$(C$,G)
1239 rem: GA IN
1240 IF LEFT$(C$,5) <> "ga in" THEN 1320
1260 IF RIGHT$(C$,6) = "afvoer" THEN 2395
1270 IF RIGHT$(C$,6) = "ballon" THEN 2540
1280 IF RIGHT$(C$,6) = "vijver" THEN 2600
1300 IF RIGHT$(C$,6) = "winkel" or RIGHT$(C$,10) = "supermarkt" THEN 2680
1310 goto 2750
1320 IF C$ = "ga door deur" THEN 2650
1340 IF LEFT$(C$,9) = "onderzoek" THEN 2840
1350 IF LEFT$(C$,6) = "bekijk" THEN 2850
1360 IF LEFT$(C$,6) = "ga jog" OR LEFT$(C$,7) = "ga trim" THEN 3000
1370 IF LEFT$(C$,4) = "ga o" AND L = 32 THEN 3950
1380 IF LEFT$(C$,4) = "ga u" THEN 3030
1390 IF LEFT$(C$,2) = "ga" THEN 3080
1410 IF C$ = "voer panter" OR C$ = "geef zalm" THEN 3150
1419 rem 1420 h = INSTR(C$,"panter") : if h <> 0 THEN 3130
1420 H = 0:FOR I = 1 TO LEN(C$) - 5
1421 IF MID$(C$,I,6) = "PANTER" THEN H = I:I = LEN(C$):REM EXIT LOOP
1422 NEXT I:IF H <> 0 THEN 3130
1430 IF RIGHT$(C$,4) <> "boom" AND RIGHT$(C$,5) <> "bomen" THEN 1450
1435 IF LEFT$(C$,3) = "hak" OR LEFT$(C$,4) = "snij" THEN  3190
1440 IF LEFT$(C$,4) = "klim" THEN 3800
1450 IF LEFT$(C$,4) = "duik" THEN 3210
1460 IF C$ = "stop" OR C$ = "halt" THEN  65432
1470 IF LEFT$(C$,4) = "koop" AND L = 10 THEN 2060
1480 IF C$ = "verwijder deksel" OR C$ = "open afvoer" THEN 3250
1483 IF LEFT$(C$,4) <> "open" THEN  1510
1485 IF RIGHT$(C$,4) = "boek" OR RIGHT$(C$,4) = "klok" OR RIGHT$(C$,3) = "tas" THEN 2845
1490 IF RIGHT$(C$,4) = "deur" THEN 3295
1510 IF C$ = "maak kluis open" OR C$ = "open kluis" THEN 7000
1540 IF C$ = "blaas boot op" THEN 3350
1550 IF C$ = "blaas ballon op" OR C$ = "bouw ballon" THEN 3380
1570 IF C$ = "vlieg met ballon" OR C$ = "zeil met ballon" THEN 3460
1590 IF C$ = "lees testament" AND F = 1 THEN 7200
1600 IF C$ = "lees boek" THEN 2850
1605 IF C$ = "lees bord" THEN 3900
1620 IF LEFT$(C$,4) = "kijk" THEN 1040
1630 IF C$ = "help" THEN :GOSUB 7600:GOTO 1040
1990  PRINT CHR$ (7)"Ik begrijp U niet.":print:GOTO 1190
2000 rem NEEM
2030 IF C$ = "neem zalm" AND L = 29 AND O(10) <> 0 THEN :PRINT "Die glipte uit Uw vingers.":GOTO 1190
2035 IF C$ = "neem schilderij" AND L = 16 THEN  :PRINT "Te kostbaar.":GOTO 1190
2040 IF L = 10 THEN :PRINT "pleeg geen winkeldiefstal!":GOTO 1190
2045 IF C$ = "neem tafel" AND L = 37 THEN :PRINT "Die zit vastgespijkerd":GOTO 1190
2055 IF I = 4 THEN :PRINT "U draagt teveel bij U.":GOTO 1190
2060 IF RIGHT$(C$,4) = "bril" THEN 6150
2065 IF C$ = "neem snorkel" THEN 6100
2070 FOR X = 1 TO 19:G=LEN(C$)-5: IF G <1 THEN 2110
2090   IF RIGHT$(C$,G) <> RIGHT$(I$(X),G) THEN 2110
2095   IF O(X) = 0 THEN :PRINT "Dat heeft U al.": X = 19: GOTO 990
2100   IF O(X) = L THEN O(X) = 0: I = I + 1
2105   X = 19: GOTO 1040
2110 NEXT
2120 IF C$ = "neem panter" AND O(30) = L THEN 6200
2130 IF RIGHT$(C$,4) = "klok" AND L = 14 THEN :PRINT "Te zwaar.":GOTO 1190
2140 IF C$ = "neem kist" AND O(26) = L THEN :PRINT "Ik heb geen dorst.":GOTO 1190
2150 IF C$ = "neem kluis" AND O(25) = L THEN :PRINT "De kluis zit aan de muur vast.":GOTO 1190
2160 GOTO 1990: rem EINDE NEEM
2189 rem: "LEG" 2190 FOR X =1 TO 19: H = INSTR(5,C$," "): IF H <> 0 THEN G = H-5 ELSE G = LEN(C$)-4
2190 FOR X =1 TO 19
2191   h=0: print X
2192   for g = 5 to len(c$)
2193     if mid$(c$,g,1) = " " then H=g
2194   next g
2195   IF H <> 0 THEN G = H-5
2196   IF h = 0  THEN G = LEN(C$)-4
2197   IF G > 0 THEN IF MID$(C$,5,G) = RIGHT$(I$(X),G) AND O(X) = 0 THEN 2240
2198 NEXT X
2199 GOTO 1990
2240 IF X = 8 AND (L = 28 OR L = 29) THEN O(8) = 5:I = I-1: :PRINT "De boot drijft weg.....":X = 19: GOTO 990
2270 I = I-1
2280 IF (L = 28 OR L = 29) THEN O(X) = L + 2: GOTO 1040
2300   O(X) = L : X = 19: GOTO 1040
2315 NEXT
2340 rem print inventaris
2350 FOR X = 1 TO 19: IF O(X) <> 0 THEN 2370
2355 IF LEN(O$(X)) + POS(0) > 38 THEN PRINT
2360   PRINT O$(X)". ";
2370 NEXT :PRINT :GOTO 1190
2395 FOR X = 1 TO 8:IF VE(X) = L THEN 2415
2400 NEXT: GOTO 1990
2415 X = 8: IF O(8) =0 AND R = 1 THEN :PRINT P$(2):GOTO 1190
2420 FOR X = 1 TO 4: IF O(X) = 0 THEN X = 4: :PRINT P$(2): GOTO 1190
2430 NEXT
2450 IF(L = 13 AND C1 = 0) OR (L = 14 AND C2 = 0) OR (L = 17 AND C3 = 0) OR (L = 18 AND C4 = 0) THEN : PRINT P$(1):GOTO 1190
2485 IF W = 0 THEN :PRINT "U bent te dik.":GOTO 1190
2490 IF L = 13 AND C1 = 1 THEN  L = 21:GOTO 1040
2500 IF L = 14 AND C2 = 1 THEN  L = 24:GOTO 1040
2510 IF L = 17 AND C3 = 1 THEN  L = 26:GOTO 1040
2520 IF L = 18 AND C4 = 1 THEN  L = 27:GOTO 1040
2530 IF NOT (L = 18 AND C4 = 1) THEN 1990 : rem else replacement
2539 rem: BALLON varen ??
2540 IF H = 0 THEN :PRINT "Nog niet klaar.":GOTO 1190
2550 IF L = 8 THEN  L= 34:GOTO 1040
2560 IF L = 36 THEN  L= 35:GOTO 1040
2570 :PRINT "Ik kan het niet vinden.":GOTO 1190
2599 rem: Mag ik op de vijver?
2600 IF L <> 5 THEN 1990
2610 IF O(8) <> 0 THEN :PRINT "Ik moet ergens op kunnen drijven.":GOTO 1190
2630 IF R = 0 THEN :PRINT "Rubberboot is te slap.":GOTO 1190
2640 L = 28:GOTO 1040
2650 IF L = 16 AND K = 0 THEN :PRINT "De deur is op slot.":GOTO 1190
2655 IF L = 20 THEN L = 16:K = 1:GOTO 1040
2660 IF L = 16 THEN L = 20:GOTO 1040
2679 goto 1990 : rem else replacement
2680 IF L <> 9 THEN 1990
2690 FOR X = 1 TO 19:IF O(X) = 0 THEN X = 19: :PRINT "U kunt de winkel niet binnen met alles wat U bij zich heeft.": GOTO 1190
2710 NEXT :L = 10:GOTO 1040
2749 rem: ga in korenvliet
2750 IF RIGHT$(C$,8) <> "landhuis" then 2770
2751 if RIGHT$(C$,10) <> "korenvliet" THEN 2770
2760 IF L = 9 THEN L = 12:GOTO 1040
2765 IF L = 1 THEN L = 17:GOTO 1040
2769 rem: ga in ziekenhuis
2770 IF RIGHT$(C$,10) = "ziekenhuis" AND L = 9 THEN L = 11:GOTO 1040
2780 IF C$ = "ga in tunnel" AND L = 31 AND O(13) = 0 THEN L = 32:GOTO 1040
2790 IF C$ = "ga in kanaal" AND L = 4 THEN :PRINT "U gleed uit en viel.":S = 1:L = 11:GOTO 990
2800 IF RIGHT$(C$,9) = "afgraving" AND L = 8 THEN :PRINT "Te steil.":GOTO 1190
2810 IF C$ = "ga in schuur" AND L = 36 THEN L = 37:GOTO 1040
2820 IF NOT (C$ = "ga in schuur" AND L = 36) THEN 1990 : rem else replacement
2840 G = LEN(C$)-10:GOTO 2860
2845 G = LEN(C$)+2
2850 G = LEN(C$)-7
2860 IF G < 1 THEN 1990
2861 IF G > 0 THEN Q$ = RIGHT$(C$,G):FOR X = 1 TO 33
2870   IF Q$ = RIGHT$(I$(X),G) AND(O(X) = L OR O(X) = 0) THEN X = 33: GOTO 2900
2880 NEXT: GOTO 1990
2900 IF Q$ = "fles" THEN :PRINT P$(3);N$(1):GOTO 1190
2910 IF Q$ = "beker" THEN :PRINT P$(3);N$(2):GOTO 1190
2920 IF Q$ = "tafel" THEN :PRINT "Er ligt een briefje met het nummer";N$(3):GOTO 1190
2930 IF Q$ = "kist" THEN :PRINT "Er ontbreekt een fles.":GOTO 1190
2940 IF Q$ = "boek" THEN 6550
2950 IF RIGHT$(Q$,4) = "klok" AND O(13) = 40 THEN :PRINT "Er zit een duikbril in.": GOTO 1190
2960 IF Q$ = "tas" AND O(19) = 40 THEN :PRINT "Er zit een snorkel in.":GOTO 1190
2970 IF Q$ = "schilderij" THEN :PRINT "Er zit een kluis achter!":E = 1:O(25) = L:GOTO 1190
2980 :PRINT "Niets bijzonders.":GOTO 1190
3000 IF O(11) <> 0 THEN :PRINT "Ik heb schoenen nodig.":GOTO 1190
3010 IF L > 9 THEN :PRINT "Ik kan hier niet joggen.":GOTO 1190
3015 W = 1::PRINT "Pfff... Klaar!":GOTO 1190
3020 IF L = 28 THEN L = 5:GOTO 1040
3021 GOTO 1990 : rem else replacement
3030 IF S = 1 THEN :PRINT "Ik voel me niet goed.":GOTO 1190
3040 IF(L = 21 AND C1 = 0) OR (L = 24 AND C2 = 0) OR (L = 26 AND C3 = 0) OR (L = 27 AND C4 = 0)THEN :PRINT P$(1):GOTO 1190
3080 IF LEFT$(C$,4)="ga o" AND L = 18 THEN 6300
3090 FOR X = 1 TO 3: IF MID$(C$,4,1) = D$(X,L) THEN L = D(X,L): X = 3: GOTO 1040
3110 NEXT: :PRINT "Richting niet duidelijk.": GOTO 1190
3129 rem: is de panter gevoerd?
3130 IF V = 0 AND L = 18 THEN 6200
3131 IF NOT (V = 0 AND L = 18) THEN 1990
3150 IF V = 1 THEN 1990
3159 rem: Kan ik de panter voeren?
3160 IF L <> 18 THEN 1990
3170 IF O(14) <> 0 OR L <> 18 THEN :PRINT "U hebt voedsel nodig.":GOTO 1190
3180 :PRINT "Panter ontsnapte met de zalm.":IF O(14) = 0 THEN I = I-1
3185 V = 1: O(14) = 40:O(30) = 40:GOTO 990
3190 IF L = 2 AND (O(12) = 0 OR O(12) = L) THEN O(4) = 2:GOTO 1040
3191 IF NOT( L = 2 AND (O(12) = 0 OR O(12) = L)) THEN  1990 : rem else replacement
3210 IF (L = 28 OR L = 29) AND O(8) AND O(19) = 0 THEN O(8) = 5: I=I-1: L=L+2: :PRINT "De boot drijft weg ...": GOTO 990
3220 IF (L = 28 OR L = 29) AND O(19) = 0 THEN L = L+2:GOTO 1040
3230 IF L = 28 OR L = 29 THEN :PRINT "U hebt een snorkel nodig.":GOTO 1190
3230 IF NOT( L = 28 OR L = 29 ) THEN 1990 : rem else replacement
3250 IF L = 13 OR L = 21 THEN C1 = 1:GOTO 1040
3260 IF L = 14 OR L = 24 THEN C2 = 1:GOTO 1040
3270 IF L = 17 OR L = 26 THEN C3 = 1:GOTO 1040
3280 IF L = 18 OR L = 27 THEN C4 = 1:GOTO 1040
3281 IF NOT( L = 18 OR L = 27 ) THEN 1990 : rem else replacement
3295 IF L = 16 OR L = 20 THEN 3305
3296 IF NOT( L = 16 OR L = 20 ) THEN 1990 : rem else replacement
3305 IF L = 16 AND K = 0 THEN :PRINT "Gaat niet. De deur is aan de andere kant vergrendeld.":GOTO 1190
3310 PRINT "OK.":GOTO 1190
3349 rem: Kan ik de ballon maken?
3350 IF L <> 5 THEN :PRINT "Niet hier.":GOTO 1190
3360 IF R = 1 THEN :PRINT "Is al opgeblazen.":GOTO 1190
3370 PRINT "OK.":R = 1:GOTO 1190
3379 rem: Kan ik de boot maken?
3380 IF L <> 8 THEN :PRINT "Niet hier.":GOTO 1190
3390 FOR X = 1 TO 6:IF O(X) = 0 OR O(X) = 8 THEN HB = HB+1
3400 NEXT :IF HB = 6 THEN 3420
3410 PRINT "Niet klaar.":HB = 0:GOTO 1190
3420 FOR X = 1 TO 6: IF O(X) = 0 THEN I = I-1
3430 O(X) = 40:NEXT :H = 1:GOTO 1040
3460 IF H = 0 THEN :PRINT "Niet klaar.":GOTO 1190
3470 IF L = 80 OR L = 36 THEN :PRINT "U moet er eerst in.":GOTO 1190
3480 IF L = 35 THEN 3570
3480 IF L <> 34 THEN 1990: rem else replacement
3500 FOR Y = 5 TO 29 STEP 6:GOSUB 6400:NEXT :L = 35:GOTO 1040 : rem vlieg naar plaform
3570 FOR Y = 29 TO 5 STEP-6:GOSUB 6400:NEXT :L = 34:GOTO 1040 : rem vlieg terug
3639 rem: leg snorkel
3640 IF O(19) <> 0 THEN :PRINT "Heeft U niet.":GOTO 1190
3650 IF L > 27 AND L < 32 THEN :PRINT "Neem het snel terug!":GOTO 1190
3660 O(19) = L:I = I-1:GOTO 1040
3799 rem: U valt uit de boom
3800 IF L <> 2 THEN 1990
3810 :PRINT "U viel eraf.":S = 1:L = 11:GOTO 990 : rem else replacement
3899 rem: Lees het bord
3900 IF O(9) = 0 OR O(9) = L THEN :PRINT "Op het bord staat: Een goede plaats.":GOTO 1190
3910 :PRINT "Kunt het niet vinden.":GOTO 1190
3950 IF O(19) = 0 THEN 3080
3960 :PRINT "U heeft een snorkel nodig.":GOTO 1190



4999 rem print de uitgangen
5000 XL$ = D$(X,L):IF XL$ = "-"THEN RETURN
5010 rem
5020 IF XL$ = "u" THEN PRINT "uit";
5030 IF XL$ = "n" THEN PRINT "noord";
5040 IF XL$ = "o" THEN PRINT "oost";
5050 IF XL$ = "z" THEN PRINT "zuid";
5060 IF XL$ = "w" THEN PRINT "west";
5070 IF XL$ = "h" THEN PRINT "(om)hoog";
5080 IF XL$ = "l" THEN PRINT "(om)laag";
5090 PRINT ".";:  RETURN
5199 rem print bijzonderheden
5200 IF O(13) = 0 AND L = 31 THEN : PRINT "Een tunnel onder water.":RETURN
5230 IF (L = 13 AND C1 = 1) OR (L = 14 AND C2 = 1) OR (L = 17 AND C3 = 1) OR (L = 18 AND C4 = 1)THEN :PRINT "putdeksel.";
5240 IF L = 13 OR L = 14 OR L = 17 OR L = 18 THEN :PRINT "afvoer.": RETURN
5270 IF H = 1 AND (L = 8 OR L = 36) THEN :PRINT "hetelucht ballon.":RETURN
5280 gosub 260: Z = INT(10*rv)+1:
5290 IF L = 6 AND Z = 1 THEN PRINT "Adriaan met twee staven dynamiet."
5300 IF L = 3 AND Z = 3 THEN PRINT "Zoete met een koppel bloedhonden."
5310 IF L = 7 AND Z = 5 THEN PRINT "Berend met een bulldozer."
5320 IF L = 33 AND Z < 5 THEN PRINT "Er vliegt een vleermuis langs."
5330 IF L = 27 AND Z < 3 THEN PRINT "Er zit spinrag in Uw haar."
5340 IF L = 25 AND Z < 3 THEN PRINT "Een rat strijkt langs Uw been."
5350 IF L = 4 AND Z = 7 THEN PRINT "Een pad springt in het kanaal."
5360 IF L = 28 AND O(14) = 0 AND Z < 5 THEN PRINT "Een hongerige meeuw cirkelt rond."
5370 IF L = 2 AND Z = 8 THEN PRINT "Een aapachtig figuur kijkt op U neer."
5390 RETURN
5999 rem: wordt beter ?
6000 IF C$ = "gezondheid" OR C$ = "wordt beter" OR C$ = "beterschap" THEN S = 0::PRINT "genezen.":GOTO 1190
6010 goto 1200
6100 IF O(19) = 0 THEN :PRINT "U heeft het al.":GOTO 1190
6115 IF O(19) = 40 AND (O(7) = 0 OR O(7) = L) THEN O(19) = 0:I = I+1:GOTO 1040
6130 IF O(19) = L THEN O(19) = 0:I = I+1:GOTO 1040
6140 goto 1990
6150 IF O(13) = 0 THEN :PRINT "Heeft U al.":GOTO 1190
6160 IF O(13) = 40 AND L = 14 THEN O(13) = 0:I = I+1:GOTO 1040
6170 IF O(13) = L THEN O(13) = 0: I = I+1:GOTO 1040
6180 goto 1990 : rem else replacement
6199 rem: ontsnappen aan panter
6200 :PRINT "U had nog net genoeg kracht om" : PRINT " weg te komen.":S = 1:L = 11:GOTO 990
6300 IF V = 0 THEN :PRINT "Panter laat dat niet toe.":GOTO 1190
6310 L = 19:GOTO 1040
6399 rem vlieg de ballon
6400 :Z = 3 + ABS(5*Y-85)/6: GOSUB 100: LOCATE Z,Y: PRINT "- - -"
6410 LOCATE Z + 1,Y - 1: PRINT "-     -"
6420 LOCATE Z + 2,Y - 1: PRINT "======="
6430 LOCATE Z + 3,Y - 1: PRINT "-     -"
6440 LOCATE Z + 4,Y: PRINT "-   -"
6450 LOCATE Z + 5,Y + 1: PRINT ".-."
6460 LOCATE Z + 6,Y + 1: PRINT ". ."
6470 LOCATE Z + 7,Y + 1: PRINT "---"
6480 LOCATE Z + 8,Y + 1: PRINT "***"
6485 LOCATE Z + 9,Y + 1: PRINT "---"
6490 FOR X = 1 TO 1000:NEXT X:RETURN
6499 rem fancy wachtlus?? Iets met geluid op de P2000
6500 FOR X = 0 TO 20: FOR Y = 0 TO 50:NEXT :NEXT :RETURN
6549 rem Lees boek
6550 :gosub 100:"   Zo bouwt U een heteluchtballon:"
6570 PRINT :PRINT :PRINT TAB(8)"1   ballon": PRINT TAB(8)"2   kachel":PRINT TAB(8)"3   brandstof":PRINT TAB(8)"4   gondel of schuit":PRINT TAB(8)"5   kabel of touw":PRINT TAB(8)"6   lucifers of aansteker"
6600 PRINT :PRINT :PRINT "   Bouw op een geschikte plaats!":GOSUB 10000:GOTO 1040
6999 rem OPEN kluis
7000 IF E = 0 THEN :PRINT "U kunt het niet vinden.":GOTO 1190
7030 IF L <> 16 THEN :PRINT "Is hier niet.":GOTO 1190
7040 PRINT "Combinatieslot.": PRINT "Type het eerste getal  - ";: INPUT A$: F$(1) =A$: GOSUB 6500: IF F$(1) <> S$(1) THEN 7120
7070 PRINT "Type tweede getal  - ";: INPUT A$: F$(2) = A$: GOSUB 6500: IF F$(1) + F$(2) <> S$(1) + S$(2) THEN 7120
7100 PRINT "Type het laatste getal  - ";: INPUT A$: F$(3) = A$: GOSUB 6500: IF F$(1)+F$(2)+F$(3) = S$(1)+S$(2)+S$(3) THEN F = 1:PRINT :PRINT "Klik........ Er zit een testament in.":GOTO 1190
7120 PRINT "Fout.":GOTO 1190
7199 rem print testament
7200 GOSUB 100
7205 PRINT "***  LAATSTE WILSBESCHIKKING  ***"
7205 print
7210 PRINT "* Ik, Wout van Duysz ter Ghasth *"
7215 PRINT "* in goede gezondheid en bij    *"
7220 PRINT "* mijn volle verstand, laat     *"
7225 PRINT "* al mijn bezittingen, met      *"
7230 PRINT "* inbegrip van Korenvliet,      *"
7235 PRINT "* na aan diegene die deze       *"
7240 PRINT "* kluis opent, wie dat ook      *"
7245 PRINT "* zijn moge, zelfs Olivier      *"
7246 print
7250 PRINT "      <<<gefeliciteerd>>>"
7255  gosub 10000 : GOTO 65432
7499 rem print HELP met intro
7500  gosub 100:
7501 rem
7502 PRINT "Welkom in Rittenburg. U heeft onlangs"
7503 PRINT "vernomen dat Uw exentrieke oom Wout is"
7504 PRINT "overleden. Het gerucht gaat dat deze"
7505 PRINT "oude zonderling het landhuis Korenvliet"
7506 PRINT "heeft nagelaten aan degene die zijn"
7507 PRINT "kluis vindr en weet te openen"
7508 PRINT ""
7600 rem
7601 PRINT "Om het spel te spelen moet U objecten"
7602 PRINT "in Uw omgeving onderzoeken en manipu-"
7603 PRINT "leren door het gebruik van eenvoudige"
7604 PRINT "opdrachten, zoals:"
7605 PRINT ""
7606 PRINT "neem mand, ga zuid, leg iets wet, stop,"
7607 PRINT "ga door deur, ga in vijver, inventaris,"
7608 PRINT "bekijk iets, ga uit landhuis, help,"
7609 PRINT "open deur, kijk (om U heen), verwijder"
7610 PRINT "deksel, va naar winkel"
7611 PRINT ""
7612 PRINT "Richtingen mogen worden afgekort:"
7613 PRINT "ga N,W,O,Z; U=uit, L=omlaag, H=omhoog"
7614 PRINT ""
7615 PRINT " Druk op een willekeurige toets;";
7790 gosub 210
7800 GOTO 1040
8000 DATA ballon,"neergestorte weerballon",3,kachel,"kleine houtkachel",1,mand,"grote rieten mand",12,houtblokken,houtblokken,40,koord,"rol koord",17,lucifers,"doosje lucifers",15,tas,"grote tas",16,rubberboot,rubberboot,1,bord,bord,8
8100 DATA visnet,visnet,7,sportschoenen,sportschoenen,10,bijl,bijl,10,zwembril,zwembril,40,zalm,zalm,29,beker,"kristallen beker",19,fles,"lege champagnefles",33,boek,boek,14,schilderij,"schilderij van Oom Wout",16,snorkel,snorkel,40,landhuis,"Korenvliet",9
8110 DATA landhuis,"Korenvliet",1,schuur,"oude verlaten schuur",36,tafel,"houten tafel",37,klok,"Friese staartklok",14,kluis,kluis,40,kist,"kist Chablis",18,bomen,bomen,2,deur,deur,20,deur,deur,16,panter,"een geimporteerde panter",18,winkel,supermarkt,9
8120 DATA trap,trap,19,ziekenhuis,ziekenhuis,9,op het binnenplein,in een bos,in een weiland,een glibberige kanaalkant,de oever van een vijver,op een braakliggend terrein,op een rotspaadje
8125 DATA de rand van een afgraving,op de hoofdstraat,in de supermarkt
8130 DATA in het ziekenhuis,in de foyer,in de huiskamer,in de studeerkamer,in een tuinkamer,op de overloop,in het atrium,westvleugel van wijnkelder,oostvleugel van wijnkelder,boven aan een trap,een uitlaat van een riool
8140 DATA een bocht in het riool,vertakking in het riool,een uitlaat van het riool,een bocht in het riool,een uitlaat in het riool,een uitlaat in het riool,op de vijver,in de Zuidbaai,onder het wateroppervlak
8150 DATA onder het wateroppervlak,een ondergrondse stroom,in een grot,in een heteluchtballon,in een heteluchtballon,op een plateau,in een schuur
8160 DATA w,2,z,4,-,0,o,1,z,3,n,9,n,2,o,4,-,0,w,3,o,5,n,1,w,4,-,0,-,0,z,9,o,7,-,0,w,6,o,8,-,0,w,7,-,0,-,0,z,2,n,6,-,0,u,9,-,0,-,0,u,9,-,0,-,0,u,9,z,13,-,0,n,12,o,14,z,17,w,13,o,15,z,16,w,14,-,0,-,0,n,14,w,17,-,0,u,1,n,13,o,16,o,19,-,0,-,0,w
8170 DATA 18,h,20,-,0,l,19,-,0,-,0,u,13,z,22,-,0,n,21,o,23,-,0,w,22,n,24,z,25,u,14,z,23,-,0,n,23,w,26,-,0,u,17,l,27,o,25,u,18,h,26,-,0,u,5,z,29,-,0,n,28,-,0,-,0,u,28,z,31,-,0,h,29,n,30,-,0,o,31,w,33,-,0,o,32,-,0,-,0,u,8,-,0,-,0,u,36,-,0,-,0
8180 DATA -,0,-,0,-,0,u,36,-,0,-,0,uitlaat is afgedekt,er past iets niet,binnenin is een briefje met nummer,13,14,17,18,21,24,26,27
9610 rem
9620 rem DEFINT B-Z: DIM I$(33),O$(33),O(33),L$(37),D$(3,37),D(3,37): L=9: I=0
9621 DIM I$(33),O$(33),O(33),L$(37),D$(3,37),D(3,37): L=9: I=0
9630 gosub 100: HO=9:VE=11:gosub 110;: PRINT" K O R E N V L I E T ": PRINT: PRINT
9640 FOR X = 1 TO 33: READ I$(X),O$(X),O(X): NEXT
9641 FOR X = 1 TO 37: READ L$(X): NEXT
9642 FOR Y = 1 TO 37
9643   FOR X=1 TO 3: READ D$(X,Y),D(X,Y): NEXT
9644 NEXT
9645 FOR X = 1 TO 3: READ P$(X): NEXT
9646 FOR X = 1 TO 8: READ VE(X): NEXT
9647 Y = 0
9648 FOR X = 1 TO 3: gosub 260: z = INT(rv*(90+1))+10 : N$(X) =STR$(Z): print n$(x) : NEXT
9650 FOR X = 1 TO 3
9655   gosub 260
9660   Z = x: rem Z = INT(4*rv)+1:
9661   IF S(Z) = Z THEN goto 9660
9662   S$(Z) = RIGHT$ (N$(X),2)
9663   S(Z) = Z
9664   print s$(z)
9665 NEXT
9666 for i = 1 to 30: next : rem wait 3 seconds
9670 rem
9671  HO=9:VE=11:gosub 110;:PRINT "Wilt U instructies (j/n)?";
9672 gosub 210: IF IN$="J" THEN GOSUB 7500
9700 GOTO 1040
10000 FOR X=1 TO 32000: NEXT X:  RETURN: rem wachtlus
65430 rem exit
65432 cls: screen 0: width 80: end
65520 rem Nat.Lab. P2000 Computer Club
65521 rem Programma nr 48
65522 rem KORENVLIET
65523 rem versie U6 dd 01-06-83
65524 rem vrijgegeven dd 04-07-83
65525 rem copyright Hans Pennings
