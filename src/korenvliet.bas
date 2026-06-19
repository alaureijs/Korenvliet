10 rem korenvliet -- c64 basic v2 port
11 rem original (c) 1983 hans pennings
12 rem c64 port (c) 2026
13 rem
14 rem *** init ***
15 oc = 39: ol = 24
16 dim i$(33), o$(33), o(33), l$(37), d$(3, 37), d(3, 37)
17 l = 9: ic = 0
20 gosub 65: ho=11: ve=12: gosub 6500: print "K O R E N V L I E T";
30 for x = 1 to 33: read i$(x), o$(x), o(x): next
31 for x = 1 to 37: read l$(x): next
32 for y = 1 to 37: for x = 1 to 3: read d$(x, y), d(x, y): next: next
33 for x = 1 to 3: read p$(x): next
34 for x = 1 to 8: read ve(x): next
35 for x = 1 to 3: z = int(rnd(1) * 89) + 11: n$(x) = right$(str$(z), 2): next
40 for x = 1 to 3
45 z = int(rnd(1) * 3) + 1: if s(z) = z then 45
50 s$(z) = right$(n$(x), 2): s(z) = z: next
55 goto 670
65 print chr$(147)chr$(14);: poke 53280,0: poke 53281,0: poke 646,5: return
66 rem *** wait for key ***
70 print "druk op een willekeurige toets:";
75 poke 650, 0: get in$: if in$ = "" then 75
80 return
90 rem
95 rem *** get single key -> in$ ***
100 poke 650, 0
101 get in$: if in$="" then 101: p=asc(in$) and 127: in$=chr$(p)
102 if p=3 then 9000
102 return
110 rem
115 rem *** line input into c$ ***
120 c$ = "": ll = 0
125 poke 650, 0: get in$: if in$ = "" then 125
130 t = asc(in$): if t = 13 then print: return
131 if t = 20 then 137
132 if t < 32 then 125
133 if ll < 22 then c$ = c$ + chr$(t): ll = ll + 1: print chr$(t);: goto 125
134 gosub 160: goto 125
137 if ll = 0 then 125
138 c$ = left$(c$, ll - 1): ll = ll - 1: print chr$(20);: goto 125
140 rem
145 rem *** wait for any key (uses 70) ***
150 gosub 70: return
160 rem beep via sid
161 sp=106:sd=1:sv=15:gosub 400:return
195 rem
400 rem sid beep
401 f0=sp*74:if f0<1 then f0=1
402 poke 54296,sv:poke 54277,0:poke 54278,240
403 poke 54272,f0 and 255:poke 54273,int(f0/256)
404 poke 54276,17
405 for dl=1 to sd*100:next dl
406 poke 54276,16
407 poke 54296,0
408 return
670 rem *** welcome ***
675 gosub 65: ho=6: ve=12: gosub 6500: print "wilt u instructies? (j/n) ";
680 gosub 101: if in$="j" or in$="J" then gosub 7500: goto 1000
685 if in$<>"n" and in$<>"N" then gosub 160: goto 680
688 rem *** short delay before redraw ***
690 for dx = 1 to 800: next: goto 1000
1000 gosub 65: print "plaats    :";: poke 646,7: print l$(l) "."
1002 print
1003 print "uitgangen :";
1010 for x = 1 to 3
1011 poke 646,7: gosub 5000: print " ";
1012 next
1013 print
1014 print
1015 print "u ziet    :";: poke 646,7
1020 if o(13) <> 0 and (l = 30 or l = 31) then poke 646,5: goto 1100
1030 for x = 1 to 33: if o(x) <> l then 1050
1035 if pos(0) + len(o$(x)) > 38 then print: print tab(11);
1040 print o$(x) ". ";
1050 next: poke 646,5: print: print: gosub 5200
1095 rem
1100 poke 646,3: print: print "wat nu    :";: gosub 120: poke 646,5: print
1105 if s = 1 then 6000
1110 if left$(c$, 3) = "pak" then c$ = "neem" + mid$(c$, 4)
1115 if left$(c$, 4) = "neem" then 2030
1120 if left$(c$, 11) = "leg snorkel" then 3640
1125 if left$(c$, 3) = "leg" then 2190
1130 if right$(c$, 10) = "inventaris" then 2350
1135 g = len(c$) - 7: if g > 0 and mid$(c$, 4, 4) = "naar" then c$ = left$(c$, 3) + "in" + right$(c$, g)
1140 rem
1145 rem *** ga in ***
1150 if left$(c$, 5) <> "ga in" then 1210
1155 if right$(c$, 6) = "afvoer" then 2395
1160 if right$(c$, 6) = "ballon" then 2540
1165 if right$(c$, 6) = "vijver" then 2600
1170 if right$(c$, 6) = "winkel" or right$(c$, 10) = "supermarkt" then 2680
1175 goto 2750
1180 rem
1210 if c$ = "ga door deur" then 2650
1220 if left$(c$, 9) = "onderzoek" then 2840
1225 if left$(c$, 6) = "bekijk" then 2850
1230 if left$(c$, 6) = "ga jog" or left$(c$, 7) = "ga trim" then 3000
1235 if left$(c$, 4) = "ga o" and l = 32 then 3950
1240 if left$(c$, 4) = "ga u" then 3030
1245 if left$(c$, 2) = "ga" then 3080
1250 if c$ = "voer panter" or c$ = "geef zalm" then 3150
1255 gosub 1400: if r$ = "panter" then 3130
1270 if right$(c$, 4) <> "boom" and right$(c$, 5) <> "bomen" then 1290
1275 if left$(c$, 3) = "hak" or left$(c$, 4) = "snij" then 3190
1280 if left$(c$, 4) = "klim" then 3800
1290 if left$(c$, 4) = "duik" then 3209
1300 if c$ = "stop" or c$ = "halt" then gosub 1391: goto 1000
1305 if left$(c$, 4) = "koop" and l = 10 then 2060
1310 if c$ = "verwijder deksel" or c$ = "open afvoer" then 3250
1315 if left$(c$, 4) <> "open" then 1340
1320 if right$(c$, 4) = "boek" or right$(c$, 4) = "klok" or right$(c$, 3) = "tas" then 2845
1325 if right$(c$, 4) = "deur" then 3295
1340 if c$ = "maak kluis open" or c$ = "open kluis" then 7000
1345 if c$ = "blaas boot op" then 3350
1350 if c$ = "blaas ballon op" or c$ = "bouw ballon" then 3380
1355 if c$ = "vlieg met ballon" or c$ = "zeil met ballon" then 3460
1360 if c$ = "lees testament" and f = 1 then 7200
1365 if c$ = "lees boek" then 2850
1370 if c$ = "lees bord" then 3900
1375 if left$(c$, 4) = "kijk" then 1000
1380 if c$ = "help" then gosub 7510: goto 1000
1390 goto 1990
1391 print "echt stoppen? (j/n) ";
1392 gosub 101
1393 if in$="j" or in$="J" then 9003
1394 if in$="n" or in$="N" then return
1395 gosub 160: goto 1392
1396 rem *** instr replacement for panter ***
1400 r$ = "": for i = 1 to len(c$) - 5
1401 if mid$(c$, i, 6) = "panter" then r$ = "panter"
1402 next: return
1990 gosub 160: print "ik begrijp u niet.": goto 1100
2000 rem
2030 if c$ = "neem zalm" and l = 29 and o(10) <> 0 then print "die glipte uit uw vingers.": goto 1100
2035 if c$ = "neem schilderij" and l = 16 then print "te kostbaar.": goto 1100
2040 if l = 10 then print "pleeg geen winkeldiefstal!": goto 1100
2045 if c$ = "neem tafel" and l = 37 then print "die zit vastgespijkerd.": goto 1100
2055 if ic = 4 then print "u draagt teveel bij u.": goto 1100
2060 if right$(c$, 4) = "bril" then 6150
2065 if c$ = "neem snorkel" then 6100
2070 for x = 1 to 19: g = len(c$) - 5: if g < 1 then 2110
2075 if g > len(i$(x)) then g = len(i$(x))
2080 if right$(c$, g) <> right$(i$(x), g) then 2110
2085 if o(x) = 0 then print "dat hebt u al.": x = 19: next: goto 690
2090 if o(x) = l then o(x) = 0: ic = ic + 1
2095 x = 19: next: goto 1000
2110 next
2120 if c$ = "neem panter" and o(30) = l then 6200
2130 if right$(c$, 4) = "klok" and l = 14 then print "te zwaar.": goto 1100
2140 if c$ = "neem kist" and o(26) = l then print "ik heb geen dorst.": goto 1100
2150 if c$ = "neem kluis" and o(25) = l then print "de kluis zit aan de muur vast.": goto 1100
2160 goto 1990
2170 rem
2190 for x = 1 to 19
2191 hp = 0: for g = 5 to len(c$)
2192 if mid$(c$, g, 1) = " " then hp = g: g = len(c$)
2193 next g
2194 if hp <> 0 then g = hp - 5
2195 if hp = 0 then g = len(c$) - 4
2196 if g > len(i$(x)) then g = len(i$(x))
2197 if g > 0 and mid$(c$, 5, g) = right$(i$(x), g) and o(x) = 0 then 2239
2198 next: goto 1990
2239 if x <> 8 or (l <> 28 and l <> 29) then 2270
2240 o(8)=5: ic=ic-1: poke 646,3: print"de boot drijft weg.....": x=19: next
2241 goto 690
2270 ic = ic - 1
2280 if l = 28 or l = 29 then o(x) = l + 2: x = 19: next: goto 1000
2300 o(x) = l: x = 19: next: goto 1000
2350 for x = 1 to 19: if o(x) <> 0 then 2370
2355 if len(o$(x)) + pos(0) > 38 then print
2360 print o$(x) ". ";
2370 next: print: goto 1100
2395 for x = 1 to 8: if ve(x) = l then 2415
2400 next: goto 1990
2415 x = 8: next: if o(8) = 0 and r = 1 then print p$(2): goto 1100
2420 for x = 1 to 4: if o(x) = 0 then x = 4: next: print p$(2): goto 1100
2430 next
2450 if (l = 13 and c1 = 0) or (l = 14 and c2 = 0) or (l = 17 and c3 = 0) or (l = 18 and c4 = 0) then print p$(1): goto 1100
2485 if w = 0 then print "u bent te dik.": goto 1100
2490 if l = 13 and c1 = 1 then l = 21: goto 1000
2500 if l = 14 and c2 = 1 then l = 24: goto 1000
2510 if l = 17 and c3 = 1 then l = 26: goto 1000
2520 if l = 18 and c4 = 1 then l = 27: goto 1000
2530 goto 1990
2540 if h = 0 then print "nog niet klaar.": goto 1100
2550 if l = 8 then l = 34: goto 1000
2560 if l = 36 then l = 35: goto 1000
2570 print "ik kan het niet vinden.": goto 1100
2600 if l <> 5 then 1990
2609 if o(8) <> 0 then poke 646,3
2610 if o(8) <> 0 then print "ik moet ergens op kunnen drijven.": goto 1100
2630 if r = 0 then poke 646,3: print "rubberboot is te slap.": goto 1100
2640 l = 28: goto 1000
2650 if l = 16 and k = 0 then print "de deur is op slot.": goto 1100
2655 if l = 20 then l = 16: k = 1: goto 1000
2660 if l = 16 then l = 20: goto 1000
2670 goto 1990
2680 if l <> 9 then 1990
2690 for x = 1 to 19: if o(x) = 0 then x = 19: next: print "u kunt de winkel niet binnen met alles": print "wat u zich heeft.": goto 1100
2710 next: l = 10: goto 1000
2750 if right$(c$, 8) <> "landhuis" and right$(c$, 10) <> "korenvliet" then 2770
2760 if l = 9 then l = 12: goto 1000
2765 if l = 1 then l = 17: goto 1000
2770 if right$(c$, 10) = "ziekenhuis" and l = 9 then l = 11: goto 1000
2780 if c$ = "ga in tunnel" and l = 31 and o(13) = 0 then l = 32: goto 1000
2790 if c$ = "ga in kanaal" and l = 4 then print "u gleed uit en viel.": s = 1: l = 11: goto 690
2800 if right$(c$, 9) = "afgraving" and l = 8 then print "te steil.": goto 1100
2810 if c$ = "ga in schuur" and l = 36 then l = 37: goto 1000
2820 goto 1990
2840 g = len(c$) - 10: goto 2860
2845 g = len(c$) - 5
2850 g = len(c$) - 7
2860 if g < 1 then 1990
2861 q$ = right$(c$, g): for x = 1 to 33
2870 if len(q$) > len(i$(x)) then 2890
2875 if q$ = right$(i$(x), len(q$)) and (o(x) = l or o(x) = 0) then x = 33: next: goto 2900
2890 next: goto 1990
2900 if q$ = "fles" then print p$(3) n$(1): goto 1100
2910 if q$ = "beker" then print p$(3) n$(2): goto 1100
2920 if q$ = "tafel" then print "er ligt een briefje met het nummer" n$(3): goto 1100
2930 if q$ = "kist" then print "er ontbreekt een fles.": goto 1100
2940 if q$ = "boek" then 6550
2950 if right$(q$, 4) = "klok" and o(13) = 40 then print "er zit een duikbril in.": goto 1100
2960 if q$ = "tas" and o(19) = 40 then print "er zit een snorkel in.": goto 1100
2970 if q$ = "schilderij" then print "er zit een kluis achter!": e = 1: o(25) = l: goto 1100
2980 print "niets bijzonders.": goto 1100
3000 if o(11) <> 0 then print "ik heb schoenen nodig.": goto 1100
3010 if l > 9 then print "ik kan hier niet joggen.": goto 1100
3015 w = 1: print "pfff... klaar!": goto 1100
3030 if s = 1 then print "ik voel me niet goed.": goto 1100
3040 if (l = 21 and c1 = 0) or (l = 24 and c2 = 0) or (l = 26 and c3 = 0) or (l = 27 and c4 = 0) then print p$(1): goto 1100
3080 if left$(c$, 4) = "ga o" and l = 18 then 6300
3090 for x = 1 to 3: if mid$(c$, 4, 1) = d$(x, l) then l = d(x, l): x = 3: next: goto 1000
3110 next: print "richting niet duidelijk.": goto 1100
3130 if v = 0 and l = 18 then 6200
3140 goto 1990
3150 if v = 1 then 1990
3160 if l <> 18 then 1990
3170 if o(14) <> 0 then print "u hebt voedsel nodig.": goto 1100
3180 print "panter ontsnapte met de zalm.": if o(14) = 0 then ic = ic - 1
3185 v = 1: o(14) = 40: o(30) = 40: goto 690
3190 if l = 2 and (o(12) = 0 or o(12) = l) then o(4) = 2: goto 1000
3200 goto 1990
3209 if (l <> 28 and l <> 29) or o(8) <> 0 or o(19) <> 0 then 3220
3210 o(8) = 5: ic = ic - 1: l = l + 2: poke 646,3: print "de boot drijft weg..."
3211 goto 690
3220 if (l = 28 or l = 29) and o(19) = 0 then l = l + 2: goto 1000
3230 if l = 28 or l = 29 then print "u hebt een snorkel nodig.": goto 1100
3240 goto 1990
3250 if l = 13 or l = 21 then c1 = 1: goto 1000
3260 if l = 14 or l = 24 then c2 = 1: goto 1000
3270 if l = 17 or l = 26 then c3 = 1: goto 1000
3280 if l = 18 or l = 27 then c4 = 1: goto 1000
3290 goto 1990
3295 if l = 16 or l = 20 then 3305
3300 goto 1990
3305 if l = 16 and k = 0 then print "gaat niet. de deur is aan de andere": print "kant vergrendeld.": goto 1100
3310 print "ok.": goto 1100
3350 if l <> 5 then poke 646,3: print "niet hier.": goto 1100
3360 if r = 1 then poke 646,3: print "is al opgeblazen.": goto 1100
3370 poke 646,3: print "ok.": r = 1: goto 1100
3380 if l <> 8 then print "niet hier.": goto 1100
3390 hb = 0: for x = 1 to 6: if o(x) = 0 or o(x) = 8 then hb = hb + 1
3400 next: if hb = 6 then 3420
3410 print "niet klaar.": goto 1100
3420 for x = 1 to 6: if o(x) = 0 then ic = ic - 1
3430 o(x) = 40: next: h = 1: goto 1000
3460 if h = 0 then print "niet klaar.": goto 1100
3470 if l = 8 or l = 36 then print "u moet er eerst in.": goto 1100
3480 if l = 35 then 3570
3490 if l <> 34 then 1990
3500 for y = 5 to 29 step 6: gosub 6400: next: l = 35: goto 1000
3570 for y = 29 to 5 step -6: gosub 6400: next: l = 34: goto 1000
3640 if o(19) <> 0 then print "heeft u niet.": goto 1100
3650 if l > 27 and l < 32 then print "neem het snel terug!": goto 1100
3660 o(19) = l: ic = ic - 1: goto 1000
3800 if l <> 2 then 1990
3810 poke 646,4: print "u viel eraf.": s = 1: l = 11: goto 690
3900 if o(9) = 0 or o(9) = l then print "op het bord staat: een goede plaats.": goto 1100
3910 print "kunt het niet vinden.": goto 1100
3950 if o(19) = 0 then 3080
3960 print "u hebt een snorkel nodig.": goto 1100
5000 xl$ = d$(x, l): if xl$ = "-" then return
5010 if xl$ = "u" then print "uit";
5020 if xl$ = "n" then print "noord";
5030 if xl$ = "o" then print "oost";
5040 if xl$ = "z" then print "zuid";
5050 if xl$ = "w" then print "west";
5060 if xl$ = "h" then print "(om)hoog";
5070 if xl$ = "l" then print "(om)laag";
5080 print ".";: return
5200 if o(13) = 0 and l = 31 then print "een tunnel onder water.": return
5230 if l = 13 and c1 = 1 then print "putdeksel. ";
5231 if l = 14 and c2 = 1 then print "putdeksel. ";
5232 if l = 17 and c3 = 1 then print "putdeksel. ";
5233 if l = 18 and c4 = 1 then print "putdeksel. ";
5240 if l = 13 or l = 14 or l = 17 or l = 18 then print "afvoer.": return
5270 if h = 1 and (l = 8 or l = 36) then print "hetelucht ballon.": return
5280 z = int(rnd(1) * 10) + 1
5290 if l = 6 and z = 1 then print "adriaan met twee staven dynamiet."
5300 if l = 3 and z = 3 then print "zoete met een koppel bloedhonden."
5310 if l = 7 and z = 5 then print "berend met een bulldozer."
5320 if l = 33 and z < 5 then print "er vliegt een vleermuis langs."
5330 if l = 27 and z < 3 then print "er zit spinrag in uw haar."
5340 if l = 25 and z < 3 then print "een rat strijkt langs uw been."
5350 if l = 4 and z = 7 then print "een pad springt in het kanaal."
5360 if l = 28 and o(14) = 0 and z < 5 then print "een hongerige meeuw cirkelt rond."
5370 if l = 2 and z = 8 then print "een aapachtig figuur kijkt op u neer."
5390 return
6000 if c$ = "gezondheid" or c$ = "wordt beter" or c$ = "beterschap" then s = 0: print "genezen.": goto 1100
6010 goto 1115
6100 if o(19) = 0 then print "u hebt het al.": goto 1100
6115 if o(19) = 40 and (o(7) = 0 or o(7) = l) then o(19) = 0: ic = ic + 1: goto 1000
6130 if o(19) = l then o(19) = 0: ic = ic + 1: goto 1000
6140 goto 1990
6150 if o(13) = 0 then print "heeft u al.": goto 1100
6160 if o(13) = 40 and l = 14 then o(13) = 0: ic = ic + 1: goto 1000
6170 if o(13) = l then o(13) = 0: ic = ic + 1: goto 1000
6180 goto 1990
6200 poke 646,4: print "u had nog net genoeg kracht om weg te"
6210 print "komen.": s = 1: l = 11: goto 690
6300 if v = 0 then print "panter laat dat niet toe.": goto 1100
6310 l = 19: goto 1000
6400 z = 3 + abs(5 * y - 85) / 6
6405 ve = z - 1: ho = y - 1: gosub 6500: print "- - -"
6410 ve = z:     ho = y - 2: gosub 6500: print "-     -"
6420 ve = z + 1: ho = y - 2: gosub 6500: print "======="
6430 ve = z + 2: ho = y - 2: gosub 6500: print "-     -"
6440 ve = z + 3: ho = y - 1: gosub 6500: print "-   -"
6450 ve = z + 4: ho = y:     gosub 6500: print ".-."
6460 ve = z + 5: ho = y:     gosub 6500: print ". ."
6470 ve = z + 6: ho = y:     gosub 6500: print "---"
6480 ve = z + 7: ho = y:     gosub 6500: print "***"
6485 ve = z + 8: ho = y:     gosub 6500: print "---"
6490 for x = 1 to 500: next: return
6500 if ho>oc then ho=39
6501 if ve>ol then ve=24
6502 poke 781,ve
6503 poke 782,ho
6504 poke 783,0
6505 sys 65520
6506 return
6510 rem
6550 gosub 65: print "   zo bouwt u een heteluchtballon:"
6570 print: print: print tab(8) "1   ballon"
6575 print tab(8) "2   kachel"
6580 print tab(8) "3   brandstof"
6585 print tab(8) "4   gondel of schuit"
6590 print tab(8) "5   kabel of touw"
6595 print tab(8) "6   lucifers of aansteker"
6600 print: print: print "   bouw op een geschikte plaats!": gosub 150: goto 1000
7000 if e = 0 then print "u kunt het niet vinden.": goto 1100
7030 if l <> 16 then print "is hier niet.": goto 1100
7040 print "combinatieslot."
7045 print "type eerste getal  - ";
7046 gosub 120
7047 f$(1) = c$
7048 if f$(1) <> s$(1) then 7120
7070 print "type tweede getal  - ";
7071 gosub 120
7072 f$(2) = c$
7073 if f$(1) + f$(2) <> s$(1) + s$(2) then 7120
7100 print "type laatste getal - ";
7101 gosub 120
7102 f$(3) = c$
7103 if f$(1) + f$(2) + f$(3) <> s$(1) + s$(2) + s$(3) then 7120
7104 f = 1
7105 print
7106 print "klik ........ er zit een testament in."
7107 goto 1100
7120 print "fout.": goto 1100
7200 gosub 65: print: print: print
7201 for x = 1 to 39: print "*";: next
7210 print "**     laatste wilsbeschikking       **"
7215 print "**   ik, wout van duysz ter ghasth,  **"
7220 print "**   in goede gezondheid en bij      **"
7225 print "**   mijn volle verstand, laat       **"
7230 print "**   al mijn bezittingen, met        **"
7235 print "**   inbegrip van korenvliet,        **"
7240 print "**   na aan diegene die deze         **"
7245 print "**   kluis opent, wie dat ook        **"
7250 print "**   zijn moge, zelfs olivier.       **"
7290 for x = 1 to 39: print "*";: next
7291 print : gosub 150: goto 9003
7500 gosub 65
7501 print "welkom in rittenburg. u hebt onlangs"
7505 print "vernomen dat uw excentrieke oom wout"
7506 print "is overleden. het gerucht gaat dat"
7510 print "deze oude zonderling het landhuis"
7511 print "korenvliet heeft nagelaten aan"
7515 print "degene die zijn kluis vindt en"
7516 print "weet te openen."
7520 print
7521 print "om het spel te spelen moet u"
7522 print "objecten en uw omgeving onderzoeken"
7525 print "en manipuleren door het gebruik van"
7526 print "eenvoudige opdrachten, zoals:"
7530 print
7531 print "neem mand, ga zuid, leg iets weg,"
7532 print "stop, ga door deur, ga in vijver,"
7535 print "inventaris, bekijk iets, ga uit"
7536 print "landhuis, help, open deur, kijk"
7540 print "(om u heen), verwijder deksel, ga"
7541 print "naar winkel."
7550 print
7551 print "richtingen mogen worden afgekort:"
7552 print "ga n,w,o,z; u=uit, l=omlaag,"
7553 print "h=omhoog"
7560 print
7561 gosub 150
7562 return
8000 data ballon,"neergestorte weerballon",3
8001 data kachel,"kleine houtkachel",1
8002 data mand,"grote rieten mand",12
8005 data houtblokken,houtblokken,40
8006 data koord,"rol koord",17
8007 data lucifers,"doosje lucifers",15
8010 data tas,"grote tas",16
8011 data rubberboot,rubberboot,1
8012 data bord,bord,8
8020 data visnet,visnet,7
8021 data sportschoenen,sportschoenen,10
8022 data bijl,bijl,10
8030 data zwembril,zwembril,40
8031 data zalm,zalm,29
8032 data beker,"kristallen beker",19
8040 data fles,"lege champagnefles",33
8041 data boek,boek,14
8042 data schilderij,"schilderij van oom wout",16
8050 data snorkel,snorkel,40
8051 data landhuis,korenvliet,9
8052 data landhuis,korenvliet,1
8060 data schuur,"oude verlaten schuur",36
8061 data tafel,"houten tafel",37
8062 data klok,"friese staartklok",14
8070 data kluis,kluis,40
8071 data kist,"kist chablis",18
8072 data bomen,bomen,2
8073 data deur,deur,20
8074 data deur,deur,16
8080 data panter,"een geimporteerde panter",18
8081 data winkel,supermarkt,9
8082 data trap,trap,19
8083 data ziekenhuis,ziekenhuis,9
8100 data "op het binnenplein","in een bos","in een weiland"
8102 data "een glibberige kanaalkant","de oever van een vijver"
8104 data "op een braakliggend terrein","op een rotspaadje"
8106 data "de rand van een afgraving","op de hoofdstraat"
8108 data "in de supermarkt","in het ziekenhuis","in de foyer"
8110 data "in de huiskamer","in de studeerkamer","in een tuinkamer"
8112 data "op de overloop","in het atrium","westvleugel van wijnkelder"
8114 data "oostvleugel van wijnkelder","boven aan een trap"
8116 data "een uitlaat van het riool","een bocht in het riool"
8118 data "vertakking in het riool","een uitlaat van het riool"
8120 data "een bocht in het riool","een uitlaat in het riool"
8122 data "een uitlaat in het riool","op de vijver"
8124 data "in de zuidbaai","onder het wateroppervlak"
8126 data "onder het wateroppervlak","een ondergrondse stroom"
8128 data "in een grot","in een heteluchtballon"
8130 data "in een heteluchtballon","op een plateau","in een schuur"
8140 data w,2,z,4,-,0,o,1,z,3,n,9,n,2,o,4,-,0,w,3,o,5,n,1
8141 data w,4,-,0,-,0,z,9,o,7,-,0,w,6,o,8,-,0
8142 data w,7,-,0,-,0,z,2,n,6,-,0,u,9,-,0,-,0
8143 data u,9,-,0,-,0,u,9,z,13,-,0,n,12,o,14,z,17
8144 data w,13,o,15,z,16,w,14,-,0,-,0,n,14,w,17,-,0
8145 data u,1,n,13,o,16,o,19,-,0,-,0,w,18,h,20,-,0
8146 data l,19,-,0,-,0,u,13,z,22,-,0,n,21,o,23,-,0
8147 data w,22,n,24,z,25,u,14,z,23,-,0,n,23,w,26,-,0
8148 data u,17,l,27,o,25,u,18,h,26,-,0,u,5,z,29,-,0
8149 data n,28,-,0,-,0,u,28,z,31,-,0,h,29,n,30,-,0
8150 data o,31,w,33,-,0,o,32,-,0,-,0,u,8,-,0,-,0
8151 data u,36,-,0,-,0,-,0,-,0,-,0,u,36,-,0,-,0
8180 data "uitlaat is afgedekt","er past iets niet"
8182 data "binnenin is een briefje met nummer"
8250 data 13,14,17,18,21,24,26,27
8990 rem nat.lab. p2000 computer club
8991 rem programma nr 48
8992 rem korenvliet
8993 rem versie u6 dd 02-06-83
8994 rem vrijgegeven dd 04-07-83
8995 rem copyright hans pennings
9000 poke 650, 0: rem *** stop? ***
9001 poke 646,4: gosub 160: print "stop?";: gosub 101
9002 if in$<>"j" and in$<>"J" then 9001
9003 poke 53280,14: poke 53281,6: poke 646,14
9004 print chr$(147)chr$(14);: print: print "tot ziens.": end
