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
110 rem set cursor to position given by the variables ho and ve.
111 if ho>oc then ho=39:rem set cursor position
112 if ve>ol then ve=ol
113 poke781,ve:poke782,ho:poke783,0
114 sys65520:return
120 rem read cursor position ho and ve
121 poke783,1
122 sys65520
123 ve=peek(781):ho=pos(782)
124 if ho>oc then ho=ho-oc-1
125 return
200 rem read key stroke and return it in in$.
201 rem no key pressed: in$=""
202 rem in$ holds only capital letters
203 get in$:if in$<>"" then a=asc(in$) and 127:in$=chr$(a)
204 return
210 rem wait and read the pressed key and return it in in$ (see also line 200)
211 get in$:if in$="" then 210:rem wait for key from the keyboard
212 a=asc(in$) and 127:in$=chr$(a)
213 return
250 sp=106:sd=1:sv=15:gosub 400:return:rem beep
260 rv=rnd(1):return:rem return random number
270 fr=fre(0):rem return amount of free memory
271 if fr<0 then fr=32767
272 return
280 return: rem Disable the stop/break key (FR=1) or enable or (FR=0).
300 sr$=str$(sr):rem convert number to string
301 if left$(sr$,1)="." then sr$="0"+sr$
302 if left$(sr$,1)=" " then sr$=mid$(sr$,2,255)
303 return
310 sr$=str$(sr):rem convert number to a fixed width string
311 return
350 return:rem print to printer, not implemented
360 return:rem newline on printer, not implemented
400 rem produce a tone using sp, sd and sv
401 rem sp is frequency level: 0 = lowest, 60='central c', 127 = highest
402 rem sd is the tone duration in steps of 0.1 seconds
403 rem sv is the volume: 0=muted 7=medium, 15=loud
404 rem this subroutine keeps running during the time of sd.
405 f0=sp*74:if f0<1 then f0=1:rem calc frequency
406 poke 54296,sv:poke 54277,0:poke 54278,240:rem volume and envelope
407 poke 54272,f0 and 255:poke 54273,int(f0/256):rem set frequency
408 poke 54276,17:rem gate on + triangle wave
409 for t=1 to sd*500:next t:rem wait duration
410 poke 54276,16:rem gate off
411 return
450 rem wait sd*0.1 seconds or for a key stroke
451 tm = ti + sd * 6
452 gosub 200
453 if in$ <> "" or in <> 0 then sd = (tm - ti) / 6:return
454 if ti < tm then 452
455 sd = 0
456 return
500 rem open the file nf$ according to the code in nf:
501 rem nf = even number: input: nf= uneven number: output
502 rem    nf= 0 or 1 basicode cassette
503 rem    nf= 2 or 3 own system memory
504 rem    nf= 4 or 5 diskette
505 rem    nf= 6 or 7 diskette
506 rem    in=0: all ok, in=1: end of file, in=-1: error
507 return
540 return: rem Read into IN$ from the opened file NF$ (in IN the status, see line 500)
560 return: rem Send SR$ towards the opened file NF$ (in IN the status, see line 500)
580 return: rem Close the file with code NF
600 return: rem Switch to graphic screen and clear graphic screen
610 return: rem Plot a point at graphic position HO,VE (0<=HO<1 en 0<=VE<1) in fore/background color CN (=0/1; normally white/black)
630 return: rem Draw a line towards point HO,VE (0<=HO<1 en 0<=VE<1) in fore/background color CN (=0/1; normally white/black)
650 return: rem Print SR$ as text from graphic position HO,VE (0<=HO<1 en 0<=VE<1). HO and VE stay the same value.
800 in$="":a%=1: ml%=21
801 cs$=chr$(95)+chr$(157):if in$<>"" then a%=42
802 print in$cs$;
810 j= peek(56320) and 127: get es$:if j=127 and es$="" then 810
811 if j<>127 then 830
812 print cs$;:e= asc(es$):if (e<45 or e>57) and (e<65 or e>93) and e<>13 and e<>20 and e<>32 then 810
814 if e=13 then print" "chr$(157);: return
816 if e=20 and len(in$)>0 then in$= left$(in$, len(in$)-1): print chr$(157);cs$;chr$(29);" ";chr$(157);chr$(157);: goto 810
818 if len(in$)<=ml% and e<>20 then in$=in$+es$: print es$cs$;
820 goto 810
829 rem *** the following is only needed for joystick
830 if j<>119 and j<>123 then 810
831 e=1:if len(in$)=ml% or j=123 or a%=42 then e=41
833 a$=mid$("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.- "+chr$(95)+chr$(94),e,1):print a$;chr$(157);
835 for tw=0 to 500: next
840 j=peek(56320) and 127: get es$:if j=127 and es$="" then 840
841 if es$<>"" then 812
842 if j=111 then 850                    : rem Down+Right
844 if j=119 then e=e+1:if e>41 then e=1 : rem Down+Left
846 if j=123 then e=e-1:if e<1 then e=41 : rem Left
848 goto 833
850 for tw=0 to 500: next: if e=40 then es$=chr$(20):goto 812
852 if e=41 then e=13: goto 814
854 es$=a$: goto 812
950 rem stop
951 stop
1000 a=1000 : goto 20
1010 rem korenvliet
1020 goto 9610
1030 sd = 10:gosub 450: rem wacht een seconde
1040 gosub 100 : print "Plaats    : ";:print l$(l)"."
1050 print : print "Uitgangen : ";: for x = 1 to 3: gosub 5000:print " ";:next : print
1060 print : print "U ziet    : ";:
1070 if o(13) <> 0 and (l = 30 or l = 31) then 1190
1079 rem: list objecten
1080 for x = 1 to 33: if o(x) <> l then 1100
1085   if pos(0) + len(o$(x)) > 38 then :print: print tab(12);
1090   print o$(x)". ";
1100 next :print :print: gosub 5200
1190 rem
1192 print: print"Wat nu    : ";:gosub 800: c$=in$: print
1195 if s = 1 then 6000
1199 if left$(c$,3) = "pak" then c$ = "neem" + mid$(c$,4)
1200 if left$(c$,4) = "neem" then 2030
1210 if left$(c$,11) = "leg snorkel" then 3640
1220 if left$(c$,3) = "leg" then 2190
1230 if right$(c$,10) = "inventaris" then 2350
1235 g = len(c$)-7:if g > 0 and mid$(c$,4,4) = "naar" then c$ = left$(c$,3) + "in" +  right$(c$,g)
1239 rem: ga in
1240 if left$(c$,5) <> "ga in" then 1320
1260 if right$(c$,6) = "afvoer" then 2395
1270 if right$(c$,6) = "ballon" then 2540
1280 if right$(c$,6) = "vijver" then 2600
1300 if right$(c$,6) = "winkel" or right$(c$,10) = "supermarkt" then 2680
1310 goto 2750
1320 if c$ = "ga door deur" then 2650
1340 if left$(c$,9) = "onderzoek" then 2840
1350 if left$(c$,6) = "bekijk" then 2850
1360 if left$(c$,6) = "ga jog" or left$(c$,7) = "ga trim" then 3000
1370 if left$(c$,4) = "ga o" and l = 32 then 3950
1380 if left$(c$,4) = "ga u" then 3030
1390 if left$(c$,2) = "ga" then 3080
1410 if c$ = "voer panter" or c$ = "geef zalm" then 3150
1419 rem 1420 h = instr(c$,"panter") : if h <> 0 then 3130
1420 h = 0:for i = 1 to len(c$) - 5
1421 if mid$(c$,i,6) = "panter" then h = i:i = len(c$):rem EXIT LOOP
1422 next i:if h <> 0 then 3130
1430 if right$(c$,4) <> "boom" and right$(c$,5) <> "bomen" then 1450
1435 if left$(c$,3) = "hak" or left$(c$,4) = "snij" then  3190
1440 if left$(c$,4) = "klim" then 3800
1450 if left$(c$,4) = "duik" then 3210
1460 if c$ = "stop" or c$ = "halt" then  950
1470 if left$(c$,4) = "koop" and l = 10 then 2060
1480 if c$ = "verwijder deksel" or c$ = "open afvoer" then 3250
1483 if left$(c$,4) <> "open" then  1510
1485 if right$(c$,4) = "boek" or right$(c$,4) = "klok" or right$(c$,3) = "tas" then 2845
1490 if right$(c$,4) = "deur" then 3295
1510 if c$ = "maak kluis open" or c$ = "open kluis" then 7000
1540 if c$ = "blaas boot op" then 3350
1550 if c$ = "blaas ballon op" or c$ = "bouw ballon" then 3380
1570 if c$ = "vlieg met ballon" or c$ = "zeil met ballon" then 3460
1590 if c$ = "lees testament" and f = 1 then 7200
1600 if c$ = "lees boek" then 2850
1605 if c$ = "lees bord" then 3900
1620 if left$(c$,4) = "kijk" then 1040
1630 if c$ = "help" then :gosub 7600:goto 1040
1990  print chr$ (7)"Ik begrijp U niet.":print:goto 1190
2000 rem neem
2030 if c$ = "neem zalm" and l = 29 and o(10) <> 0 then :print "Die glipte uit Uw vingers.":goto 1190
2035 if c$ = "neem schilderij" and l = 16 then  :print "Te kostbaar.":goto 1190
2040 if l = 10 then :print "pleeg geen winkeldiefstal!":goto 1190
2045 if c$ = "neem tafel" and l = 37 then :print "Die zit vastgespijkerd":goto 1190
2055 if i = 4 then :print "U draagt teveel bij U.":goto 1190
2060 if right$(c$,4) = "bril" then 6150
2065 if c$ = "neem snorkel" then 6100
2070 for x = 1 to 19:g=len(c$)-5: if g <1 then 2110
2090   if right$(c$,g) <> right$(i$(x),g) then 2110
2095   if o(x) = 0 then :print "Dat heeft U al.": x = 19: goto 1030
2100   if o(x) = l then o(x) = 0: i = i + 1
2105   x = 19: goto 1040
2110 next
2120 if c$ = "neem panter" and o(30) = l then 6200
2130 if right$(c$,4) = "klok" and l = 14 then :print "Te zwaar.":goto 1190
2140 if c$ = "neem kist" and o(26) = l then :print "Ik heb geen dorst.":goto 1190
2150 if c$ = "neem kluis" and o(25) = l then :print "De kluis zit aan de muur vast.":goto 1190
2160 goto 1990: rem EINDE NEEM
2189 rem: "leg" 2190 for x =1 to 19: h = instr(5,c$," "): if h <> 0 then g = h-5 else g = len(c$)-4
2190 for x =1 to 19
2191   h=0
2192   for g = 5 to len(c$)
2193     if mid$(c$,g,1) = " " then h=g
2194   next g
2195   if h <> 0 then g = h-5
2196   if h = 0  then g = len(c$)-4
2197   if g > 0 then if mid$(c$,5,g) = right$(i$(x),g) and o(x) = 0 then 2240
2198 next x
2199 goto 1990
2240 if x = 8 and (l = 28 or l = 29) then o(8) = 5:i = i-1: :print "De boot drijft weg.....":x = 19: goto 1030
2270 i = i-1
2280 if (l = 28 or l = 29) then o(x) = l + 2: goto 1040
2300   o(x) = l : x = 19: goto 1040
2315 next
2340 rem print inventaris
2350 for x = 1 to 19: if o(x) <> 0 then 2370
2355 if len(o$(x)) + pos(0) > 38 then print
2360   print o$(x)". ";
2370 next :print :goto 1190
2395 for x = 1 to 8:if ve(x) = l then 2415
2400 next: goto 1990
2415 x = 8: if o(8) =0 and r = 1 then :print p$(2):goto 1190
2420 for x = 1 to 4: if o(x) = 0 then x = 4: :print p$(2): goto 1190
2430 next
2450 if(l = 13 and c1 = 0) or (l = 14 and c2 = 0) or (l = 17 and c3 = 0) or (l = 18 and c4 = 0) then : print p$(1):goto 1190
2485 if w = 0 then :print "U bent te dik.":goto 1190
2490 if l = 13 and c1 = 1 then  l = 21:goto 1040
2500 if l = 14 and c2 = 1 then  l = 24:goto 1040
2510 if l = 17 and c3 = 1 then  l = 26:goto 1040
2520 if l = 18 and c4 = 1 then  l = 27:goto 1040
2530 if not (l = 18 and c4 = 1) then 1990 : rem else replacement
2539 rem: ballon varen ??
2540 if h = 0 then :print "Nog niet klaar.":goto 1190
2550 if l = 8 then  l= 34:goto 1040
2560 if l = 36 then  l= 35:goto 1040
2570 :print "Ik kan het niet vinden.":goto 1190
2599 rem: mag ik op de vijver?
2600 if l <> 5 then 1990
2610 if o(8) <> 0 then :print "Ik moet ergens op kunnen drijven.":goto 1190
2630 if r = 0 then :print "Rubberboot is te slap.":goto 1190
2640 l = 28:goto 1040
2650 if l = 16 and k = 0 then :print "De deur is op slot.":goto 1190
2655 if l = 20 then l = 16:k = 1:goto 1040
2660 if l = 16 then l = 20:goto 1040
2679 goto 1990 : rem else replacement
2680 if l <> 9 then 1990
2690 for x = 1 to 19:if o(x) = 0 then x = 19: :print "U kunt de winkel niet binnen met alles wat U bij zich heeft.": goto 1190
2710 next :l = 10:goto 1040
2749 rem: ga in korenvliet
2750 if right$(c$,8) <> "landhuis" and right$(c$,10) <> "korenvliet" then 2770
2760 if l = 9 then l = 12:goto 1040
2765 if l = 1 then l = 17:goto 1040
2769 rem: ga in ziekenhuis
2770 if right$(c$,10) = "ziekenhuis" and l = 9 then l = 11:goto 1040
2780 if c$ = "ga in tunnel" and l = 31 and o(13) = 0 then l = 32:goto 1040
2790 if c$ = "ga in kanaal" and l = 4 then :print "U gleed uit en viel.":s = 1:l = 11:goto 1030
2800 if right$(c$,9) = "afgraving" and l = 8 then :print "Te steil.":goto 1190
2810 if c$ = "ga in schuur" and l = 36 then l = 37:goto 1040
2820 if not (c$ = "ga in schuur" and l = 36) then 1990 : rem else replacement
2840 g = len(c$)-10:goto 2860
2845 g = len(c$)+2
2850 g = len(c$)-7
2860 if g < 1 then 1990
2861 if g > 0 then q$ = right$(c$,g):for x = 1 to 33
2870   if q$ = right$(i$(x),g) and(o(x) = l or o(x) = 0) then x = 33: goto 2900
2880 next: goto 1990
2900 if q$ = "fles" then :print p$(3);n$(1):goto 1190
2910 if q$ = "beker" then :print p$(3);n$(2):goto 1190
2920 if q$ = "tafel" then :print "Er ligt een briefje met het nummer";n$(3):goto 1190
2930 if q$ = "kist" then :print "Er ontbreekt een fles.":goto 1190
2940 if q$ = "boek" then 6550
2950 if right$(q$,4) = "klok" and o(13) = 40 then :print "Er zit een duikbril in.": goto 1190
2960 if q$ = "tas" and o(19) = 40 then :print "Er zit een snorkel in.":goto 1190
2970 if q$ = "schilderij" then :print "Er zit een kluis achter!":e = 1:o(25) = l:goto 1190
2980 :print "Niets bijzonders.":goto 1190
3000 if o(11) <> 0 then :print "Ik heb schoenen nodig.":goto 1190
3010 if l > 9 then :print "Ik kan hier niet joggen.":goto 1190
3015 w = 1:print "Pfff... Klaar!":goto 1190
3020 if l = 28 then l = 5:goto 1040
3021 goto 1990 : rem else replacement
3030 if s = 1 then :print "Ik voel me niet goed.":goto 1190
3040 if(l = 21 and c1 = 0) or (l = 24 and c2 = 0) or (l = 26 and c3 = 0) or (l = 27 and c4 = 0)then :print p$(1):goto 1190
3080 if left$(c$,4)="ga o" and l = 18 then 6300
3090 for x = 1 to 3: if mid$(c$,4,1) = d$(x,l) then l = d(x,l): x = 3: goto 1040
3110 next: :print "Richting niet duidelijk.": goto 1190
3129 rem: is de panter gevoerd?
3130 if v = 0 and l = 18 then 6200
3131 if not (v = 0 and l = 18) then 1990
3150 if v = 1 then 1990
3159 rem: kan ik de panter voeren?
3160 if l <> 18 then 1990
3170 if o(14) <> 0 or l <> 18 then :print "U hebt voedsel nodig.":goto 1190
3180 :print "Panter ontsnapte met de zalm.":if o(14) = 0 then i = i-1
3185 v = 1: o(14) = 40:o(30) = 40:goto 1030
3190 if l = 2 and (o(12) = 0 or o(12) = l) then o(4) = 2:goto 1040
3191 if not( l = 2 and (o(12) = 0 or o(12) = l)) then  1990 : rem else replacement
3210 if (l = 28 or l = 29) and o(8) and o(19) = 0 then o(8) = 5: i=i-1: l=l+2: :print "De boot drijft weg ...": goto 1030
3220 if (l = 28 or l = 29) and o(19) = 0 then l = l+2:goto 1040
3230 if l = 28 or l = 29 then :print "U hebt een snorkel nodig.":goto 1190
3240 if not( l = 28 or l = 29 ) then 1990 : rem else replacement
3250 if l = 13 or l = 21 then c1 = 1:goto 1040
3260 if l = 14 or l = 24 then c2 = 1:goto 1040
3270 if l = 17 or l = 26 then c3 = 1:goto 1040
3280 if l = 18 or l = 27 then c4 = 1:goto 1040
3281 if not( l = 18 or l = 27 ) then 1990 : rem else replacement
3295 if l = 16 or l = 20 then 3305
3296 if not( l = 16 or l = 20 ) then 1990 : rem else replacement
3305 if l = 16 and k = 0 then :print "Gaat niet. De deur is aan de andere kant vergrendeld.":goto 1190
3310 print "OK.":goto 1190
3349 rem: kan ik de ballon maken?
3350 if l <> 5 then :print "Niet hier.":goto 1190
3360 if r = 1 then :print "Is al opgeblazen.":goto 1190
3370 print "OK.":r = 1:goto 1190
3379 rem: kan ik de boot maken?
3380 if l <> 8 then :print "Niet hier.":goto 1190
3390 for x = 1 to 6:if o(x) = 0 or o(x) = 8 then hb = hb+1
3400 next :if hb = 6 then 3420
3410 print "Niet klaar.":hb = 0:goto 1190
3420 for x = 1 to 6: if o(x) = 0 then i = i-1
3430 o(x) = 40:next :h = 1:goto 1040
3460 if h = 0 then :print "Niet klaar.":goto 1190
3470 if l = 80 or l = 36 then :print "U moet er eerst in.":goto 1190
3480 if l = 35 then 3570
3490 if l <> 34 then 1990: rem else replacement
3500 for y = 5 to 29 step 6:gosub 6400:next :l = 35:goto 1040 : rem vlieg naar plaform
3570 for y = 29 to 5 step-6:gosub 6400:next :l = 34:goto 1040 : rem vlieg terug
3639 rem: leg snorkel
3640 if o(19) <> 0 then :print "Heeft U niet.":goto 1190
3650 if l > 27 and l < 32 then :print "Neem het snel terug!":goto 1190
3660 o(19) = l:i = i-1:goto 1040
3799 rem: u valt uit de boom
3800 if l <> 2 then 1990
3810 :print "U viel eraf.":s = 1:l = 11:goto 1030 : rem else replacement
3899 rem: lees het bord
3900 if o(9) = 0 or o(9) = l then :print "Op het bord staat: Een goede plaats.":goto 1190
3910 :print "Kunt het niet vinden.":goto 1190
3950 if o(19) = 0 then 3080
3960 :print "U heeft een snorkel nodig.":goto 1190
4999 rem print de uitgangen
5000 xl$ = d$(x,l):if xl$ = "-"then return
5010 rem
5020 if xl$ = "u" then print "uit";
5030 if xl$ = "n" then print "noord";
5040 if xl$ = "o" then print "oost";
5050 if xl$ = "z" then print "zuid";
5060 if xl$ = "w" then print "west";
5070 if xl$ = "h" then print "(om)hoog";
5080 if xl$ = "l" then print "(om)laag";
5090 print ".";:  return
5199 rem print bijzonderheden
5200 if o(13) = 0 and l = 31 then : print "Een tunnel onder water.":return
5230 if (l = 13 and c1 = 1) or (l = 14 and c2 = 1) or (l = 17 and c3 = 1) or (l = 18 and c4 = 1)then :print "putdeksel.";
5240 if l = 13 or l = 14 or l = 17 or l = 18 then :print "afvoer.": return
5270 if h = 1 and (l = 8 or l = 36) then :print "hetelucht ballon.":return
5280 gosub 260: z = int(10*rv)+1:
5290 if l = 6 and z = 1 then print "Adriaan met twee staven dynamiet."
5300 if l = 3 and z = 3 then print "Zoete met een koppel bloedhonden."
5310 if l = 7 and z = 5 then print "Berend met een bulldozer."
5320 if l = 33 and z < 5 then print "Er vliegt een vleermuis langs."
5330 if l = 27 and z < 3 then print "Er zit spinrag in Uw haar."
5340 if l = 25 and z < 3 then print "Een rat strijkt langs Uw been."
5350 if l = 4 and z = 7 then print "Een pad springt in het kanaal."
5360 if l = 28 and o(14) = 0 and z < 5 then print "Een hongerige meeuw cirkelt rond."
5370 if l = 2 and z = 8 then print "Een aapachtig figuur kijkt op U neer."
5390 return
5999 rem: wordt beter ?
6000 if c$ = "gezondheid" or c$ = "wordt beter" or c$ = "beterschap" then s = 0:print "genezen.":goto 1190
6010 goto 1200
6100 if o(19) = 0 then :print "U heeft het al.":goto 1190
6115 if o(19) = 40 and (o(7) = 0 or o(7) = l) then o(19) = 0:i = i+1:goto 1040
6130 if o(19) = l then o(19) = 0:i = i+1:goto 1040
6140 goto 1990
6150 if o(13) = 0 then :print "Heeft U al.":goto 1190
6160 if o(13) = 40 and l = 14 then o(13) = 0:i = i+1:goto 1040
6170 if o(13) = l then o(13) = 0: i = i+1:goto 1040
6180 goto 1990 : rem else replacement
6199 rem: ontsnappen aan panter
6200 :print "U had nog net genoeg kracht om" : print " weg te komen.":s = 1:l = 11:goto 1030
6300 if v = 0 then :print "Panter laat dat niet toe.":goto 1190
6310 l = 19:goto 1040
6399 rem vlieg de ballon
6400 :z = 3 + abs(5*y-85)/6: gosub 100: ve = z-1: ho = y-1: gosub 110: print "- - -"
6410 ve = z: ho = y-2: gosub 110: print "-     -"
6420 ve = z+1: ho = y-2: gosub 110: print "======="
6430 ve = z+2: ho = y-2: gosub 110: print "-     -"
6440 ve = z+3: ho = y-1: gosub 110: print "-   -"
6450 ve = z+4: ho = y: gosub 110: print ".-."
6460 ve = z+5: ho = y: gosub 110: print ". ."
6470 ve = z+6: ho = y: gosub 110: print "---"
6480 ve = z+7: ho = y: gosub 110: print "***"
6485 ve = z+8: ho = y: gosub 110: print "---"
6490 sd = 1:gosub 450:return
6499 rem fancy wachtlus?? iets met geluid op de p2000
6500 sd = 2:gosub 450:return
6549 rem lees boek
6550 :gosub 100:print "   Zo bouwt U een heteluchtballon:"
6570 print :print :print tab(8)"1   ballon": print tab(8)"2   kachel":print tab(8)"3   brandstof":print tab(8)"4   gondel of schuit":print tab(8)"5   kabel of touw":print tab(8)"6   lucifers of aansteker"
6600 print :print :print "   Bouw op een geschikte plaats!":gosub 10000:goto 1040
6999 rem open kluis
7000 if e = 0 then :print "U kunt het niet vinden.":goto 1190
7030 if l <> 16 then :print "Is hier niet.":goto 1190
7040 print "Combinatieslot.": print "Type het eerste getal  - ";: input a$: f$(1) =a$: gosub 6500: if f$(1) <> s$(1) then 7120
7070 print "Type tweede getal  - ";: input a$: f$(2) = a$: gosub 6500: if f$(1) + f$(2) <> s$(1) + s$(2) then 7120
7100 print "Type het laatste getal  - ";: input a$: f$(3) = a$: gosub 6500: if f$(1)+f$(2)+f$(3) = s$(1)+s$(2)+s$(3) then f = 1:print :print "Klik........ Er zit een testament in.":goto 1190
7120 print "Fout.":goto 1190
7199 rem print testament
7200 gosub 100
7205 print "***  LAATSTE WILSBESCHIKKING  ***"
7206 print
7210 print "* Ik, Wout van Duysz ter Ghasth *"
7215 print "* in goede gezondheid en bij    *"
7220 print "* mijn volle verstand, laat     *"
7225 print "* al mijn bezittingen, met      *"
7230 print "* inbegrip van Korenvliet,      *"
7235 print "* na aan diegene die deze       *"
7240 print "* kluis opent, wie dat ook      *"
7245 print "* zijn moge, zelfs Olivier      *"
7246 print
7250 print "      <<<gefeliciteerd>>>"
7255  gosub 10000 : goto 950
7499 rem print help met intro
7500  gosub 100:
7501 print ""
7502 print "Welkom in Rittenburg. U heeft onlangs"
7503 print "vernomen dat Uw exentrieke oom Wout is"
7504 print "overleden. Het gerucht gaat dat deze"
7505 print "oude zonderling het landhuis Korenvliet"
7506 print "heeft nagelaten aan degene die zijn"
7507 print "kluis vind en weet te openen"
7508 print ""
7600 rem
7601 print "Om het spel te spelen moet U objecten"
7602 print "in Uw omgeving onderzoeken en manipu-"
7603 print "leren door het gebruik van eenvoudige"
7604 print "opdrachten, zoals:"
7605 print ""
7606 print "neem mand, ga zuid, leg iets wet, stop,"
7607 print "ga door deur, ga in vijver, inventaris,"
7608 print "bekijk iets, ga uit landhuis, help,"
7609 print "open deur, kijk (om U heen), verwijder"
7610 print "deksel, va naar winkel"
7611 print ""
7612 print "Richtingen mogen worden afgekort:"
7613 print "ga N,W,O,Z; U=uit, L=omlaag, H=omhoog"
7614 print ""
7615 print " Druk op een willekeurige toets;";
7790 gosub 210
7800 goto 1040
8000 data "ballon","neergestorte weerballon",3
8001 data "kachel","kleine houtkachel",1
8002 data "mand","grote rieten mand",12
8003 data "houtblokken","houtblokken",40
8004 data "koord","rol koord",17
8005 data "lucifers","doosje lucifers",15
8006 data "tas","grote tas",16
8007 data "rubberboot","rubberboot",1
8008 data "bord","bord",8
8009 data "visnet","visnet",7
8010 data "sportschoenen","sportschoenen",10
8011 data "bijl","bijl",10
8012 data "zwembril","zwembril",40
8013 data "zalm","zalm",29
8014 data "beker","kristallen beker",19
8015 data "fles","lege champagnefles",33
8016 data "boek","boek",14
8017 data "schilderij","schilderij van Oom Wout",16
8018 data "snorkel","snorkel",40
8019 data "landhuis","Korenvliet",9
8020 data "landhuis","Korenvliet",1
8021 data "schuur","oude verlaten schuur",36
8022 data "tafel","houten tafel",37
8023 data "klok","Friese staartklok",14
8024 data "kluis","kluis",40
8025 data "kist","kist Chablis",18
8026 data "bomen","bomen",2
8027 data "deur","deur",20
8028 data "deur","deur",16
8029 data "panter","een geimporteerde panter",18
8030 data "winkel","supermarkt",9
8031 data "trap","trap",19
8032 data "ziekenhuis","ziekenhuis",9
8100 data "op het binnenplein"
8101 data "in een bos"
8102 data "in een weiland"
8103 data "een glibberige kanaalkant"
8104 data "de oever van een vijver"
8105 data "op een braakliggend terrein"
8106 data "op een rotspaadje"
8107 data "de rand van een afgraving"
8108 data "op de hoofdstraat"
8109 data "in de supermarkt"
8110 data "in het ziekenhuis"
8111 data "in de foyer"
8112 data "in de huiskamer"
8113 data "in de studeerkamer"
8114 data "in een tuinkamer"
8115 data "op de overloop"
8116 data "in het atrium"
8117 data "westvleugel van wijnkelder"
8118 data "oostvleugel van wijnkelder"
8119 data "boven aan een trap"
8120 data "een uitlaat van een riool"
8121 data "een bocht in het riool"
8122 data "vertakking in het riool"
8123 data "een uitlaat van het riool"
8124 data "een bocht in het riool"
8125 data "een uitlaat in het riool"
8126 data "een uitlaat in het riool"
8127 data "op de vijver"
8128 data "in de Zuidbaai"
8129 data "onder het wateroppervlak"
8130 data "onder het wateroppervlak"
8131 data "een ondergrondse stroom"
8132 data "in een grot"
8133 data "in een heteluchtballon"
8134 data "in een heteluchtballon"
8135 data "op een plateau"
8136 data "in een schuur"
8200 data w,2,z,4,-,0
8201 data o,1,z,3,n,9
8202 data n,2,o,4,-,0
8203 data w,3,o,5,n,1
8204 data w,4,-,0,-,0
8205 data z,9,o,7,-,0
8206 data w,6,o,8,-,0
8207 data w,7,-,0,-,0
8208 data z,2,n,6,-,0
8209 data u,9,-,0,-,0
8210 data u,9,-,0,-,0
8211 data u,9,z,13,-,0
8212 data n,12,o,14,z,17
8213 data w,13,o,15,z,16
8214 data w,14,-,0,-,0
8215 data n,14,w,17,-,0
8216 data u,1,n,13,o,16
8217 data o,19,-,0,-,0
8218 data w,18,h,20,-,0
8219 data l,19,-,0,-,0
8220 data u,13,z,22,-,0
8221 data n,21,o,23,-,0
8222 data w,22,n,24,z,25
8223 data u,14,z,23,-,0
8224 data n,23,w,26,-,0
8225 data u,17,l,27,o,25
8226 data u,18,h,26,-,0
8227 data u,5,z,29,-,0
8228 data n,28,-,0,-,0
8229 data u,28,z,31,-,0
8230 data h,29,n,30,-,0
8231 data o,31,w,33,-,0
8232 data o,32,-,0,-,0
8233 data u,8,-,0,-,0
8234 data u,36,-,0,-,0
8235 data -,0,-,0,-,0
8236 data u,36,-,0,-,0
8240 data "uitlaat is afgedekt"
8241 data "er past iets niet"
8242 data "binnenin is een briefje met nummer"
8250 data 13,14,17,18,21,24,26,27
9610 rem
9620 rem defint b-z: dim i$(33),o$(33),o(33),l$(37),d$(3,37),d(3,37): l=9: i=0
9621 dim i$(33),o$(33),o(33),l$(37),d$(3,37),d(3,37): l=9: i=0
9630 gosub 100: ho=9:ve=11:gosub 110: print" K O R E N V L I E T ": print: print
9640 for x = 1 to 33: read i$(x),o$(x),o(x): next
9641 for x = 1 to 37: read l$(x): next
9642 for y = 1 to 37
9643   for x=1 to 3: read d$(x,y),d(x,y): next
9644 next
9645 for x = 1 to 3: read p$(x): next
9646 for x = 1 to 8: read ve(x): next
9647 y = 0
9648 for x = 1 to 3: gosub 260: z = int(rv*(90+1))+10 : n$(x) =str$(z): print n$(x) : next
9650 for x = 1 to 3
9655   gosub 260
9660   z = x: rem Z = INT(4*rv)+1:
9661   if s(z) = z then goto 9660
9662   s$(z) = right$ (n$(x),2)
9663   s(z) = z
9664   print s$(z)
9665 next
9666 sd = 30:gosub 450: rem wait 3 seconds
9670 rem
9671  ho=9:ve=11:gosub 110:print "Wilt U instructies (j/n)?";
9672 gosub 210: print in$ :if in$="j" then gosub 7500
9700 goto 1040
10000 sd = 30:gosub 450:return: rem wachtlus
63992 rem nat.lab. p2000 computer club
63993 rem programma nr 48
63994 rem korenvliet
63995 rem versie u6 dd 01-06-83
63996 rem vrijgegeven dd 04-07-83
63997 rem copyright hans pennings
