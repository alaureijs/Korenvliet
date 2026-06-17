10 CLEAR150,40959:H$=CHR$(12):J$=CHR$(131):POKE24595,1:DEFINTA-Z:DEFUSR=38880:I=USR(0):POKE24591,0:ONERRORGOTO65432:DIMI$(33),O$(33),O(33),L$(37),D$(3,37),D(3,37):L=9:PRINTH$CHR$(4)H$CHR$(9)CHR$(141)CHR$(130)"K O R E N V L I E T":PRINT:PRINT
40 FORX=1TO33:READI$(X),O$(X),O(X):NEXT:FORX=1TO37:READL$(X):NEXT:FORY=1TO37:FORX=1TO3:READD$(X,Y),D(X,Y):NEXT:NEXT:FORX=1TO3:READP$(X):NEXT:FORX=1TO8:READVE(X):NEXT:Y=RND(PEEK(24592)):FORX=1TO3:Z=INT(89*RND(5))+11:N$(X)=STR$(Z):NEXT
50 FORX=1TO3
60 Z=INT(3*RND(5))+1:IFS(Z)=ZTHEN60:ELSES$(Z)=RIGHT$(N$(X),2):S(Z)=Z:NEXT:GOTO670
140 PRINTCHR$(127);:GOSUB200:PRINTCHR$(8);:IFTS<32THENTS=32
145 PRINTCHR$(TS);:C=TS:GOSUB220:IFTS=13THENRETURN:ELSE142
150 LL=0:C$=SPACE$(25)
151 PRINTCHR$(127);:GOSUB200:PRINTCHR$(8);:IFTS>31THEN154
152 IFTS=8THEN156
153 IFTS=13THENPRINT" ":C$=LEFT$(C$,LL):RETURN:ELSEPRINTCHR$(7);:GOTO151
154 IFLL<22THENLL=LL+1:ELSEPRINTCHR$(8);
155 MID$(C$,LL,1)=CHR$(TS):PRINTCHR$(TS);:GOTO151
156 IFLL=0THEN150:ELSEPRINT" "STRING(2,8);:MID$(C$,LL,1)=" ":LL=LL-1:GOTO151
160 PRINTCHR$(4)CHR$(24)CHR$(1)CHR$(130)"Druk op een willekeurige toets:";
165 IFINP(0)<255THEN165
170 IFINP(0)=255THEN170:ELSERETURN
200 TS=USR(0):IFTS=3THEN65430:ELSERETURN
220 PRINTCHR$(127);:GOSUB200:PRINTCHR$(8)" "STRING(2,8);:RETURN
670 PRINTH$CHR$(4)H$CHR$(7)"Wilt U instructies ? (j/n) ";
680 C=USR(0):IFC=106THENGOSUB7500:ELSEIFC=110THEN1000:ELSEPRINTCHR$(7);:GOTO680
990 FORX=1TO3000:NEXT
1000 PRINTH$"Plaats    :"J$L$(L)".":PRINT:PRINT"Uitgangen :"J$;:FORX=1TO3:GOSUB5000:PRINT" ";:NEXT:PRINT:PRINT:PRINT"U ziet    :"J$;
1070 IFO(13)<>0AND(L=30ORL=31)THEN1190
1080 FORX=1TO33:IFO(X)<>LTHEN1100
1085 IFPOS(0)+<E0>(O$(X))>38THENPRINT:PRINTTAB(11)J$;
1090 PRINTO$(X)". ";
1100 NEXT:PRINT:PRINT:PRINTCHR$(130);:GOSUB5200
1190 PRINT:PRINT"Wat nu    :"CHR$(134);:GOSUB150:PRINT
1195 IFS=1THEN6000
1199 IFLEFT$(C$,3)="pak"THENC$=" "+C$:MID$(C$,1,4)="neem"
1200 IFLEFT$(C$,4)="neem"THEN2030
1210 IFLEFT$(C$,11)="leg snorkel"THEN3640
1220 IFLEFT$(C$,3)="leg"THEN2190
1230 IFRIGHT$(C$,10)="inventaris"THEN2350
1235 G=<E0>(C$)-7:IFG>0ANDMID$(C$,4,4)="naar"THENC$=LEFT$(C$,3)+"in"+RIGHT$(C$,G)
1240 IFLEFT$(C$,5)<>"ga in"THEN1320
1260 IFRIGHT$(C$,6)="afvoer"THEN2395
1270 IFRIGHT$(C$,6)="ballon"THEN2540
1280 IFRIGHT$(C$,6)="vijver"THEN2600
1300 IFRIGHT$(C$,6)="winkel"ORRIGHT$(C$,10)="supermarkt"THEN2680:ELSE2750
1320 IFC$="ga door deur"THEN2650
1340 IFLEFT$(C$,9)="onderzoek"THEN2840
1350 IFLEFT$(C$,6)="bekijk"THEN2850
1360 IFLEFT$(C$,6)="ga jog"ORLEFT$(C$,7)="ga trim"THEN3000
1370 IFLEFT$(C$,4)="ga o"ANDL=32THEN3950
1380 IFLEFT$(C$,4)="ga u"THEN3030
1390 IFLEFT$(C$,2)="ga"THEN3080
1410 IFC$="voer panter"ORC$="geef zalm"THEN3150
1420 IFINSTR(C$,"panter")<>0THEN3130
1430 IFRIGHT$(C$,4)<>"boom"ANDRIGHT$(C$,5)<>"bomen"THEN1450
1435 IFLEFT$(C$,3)="hak"ORLEFT$(C$,4)="snij"THEN3190
1440 IFLEFT$(C$,4)="klim"THEN3800
1450 IFLEFT$(C$,4)="duik"THEN3210
1460 IFC$="stop"ORC$="halt"THEN65432
1470 IFLEFT$(C$,4)="koop"ANDL=10THEN2060
1480 IFC$="verwijder deksel"ORC$="open afvoer"THEN3250
1483 IFLEFT$(C$,4)<>"open"THEN1510
1485 IFRIGHT$(C$,4)="boek"ORRIGHT$(C$,4)="klok"ORRIGHT$(C$,3)="tas"THEN2845
1490 IFRIGHT$(C$,4)="deur"THEN3295
1510 IFC$="maak kluis open"ORC$="open kluis"THEN7000
1540 IFC$="blaas boot op"THEN3350
1550 IFC$="blaas ballon op"ORC$="bouw ballon"THEN3380
1570 IFC$="vlieg met ballon"ORC$="zeil met ballon"THEN3460
1590 IF C$="lees testament"ANDF=1THEN7200
1600 IFC$="lees boek"THEN2850
1605 IFC$="lees bord"THEN3900
1620 IFLEFT$(C$,4)="kijk"THEN1000
1630 IFC$="help"THENGOSUB7510:GOTO1000
1990 PRINTCHR$(7)"Ik begrijp U niet.":GOTO1190
2030 IFC$="neem zalm"ANDL=29ANDO(10)<>0THENPRINT"Die glipte uit Uw vingers.":GOTO1190
2035 IFC$="neem schilderij"ANDL=16THENPRINT"Te kostbaar.":GOTO1190
2040 IFL=10THENPRINT"Pleeg geen winkeldiefstal !":GOTO1190
2045 IFC$="neem tafel"ANDL=37THENPRINT"Die zit vastgespijkerd.":GOTO1190
2055 IFI=4THENPRINT"U draagt teveel bij U.":GOTO1190
2060 IFRIGHT$(C$,4)="bril"THEN6150
2065 IFC$="neem snorkel"THEN6100
2070 FORX=1TO19:G=<E0>(C$)-5:IFG<1THEN2110
2090 IFRIGHT$(C$,G)<>RIGHT$(I$(X),G)THEN2110
2095 IFO(X)=0THENPRINT"Dat hebt U al.":X=19:NEXT:GOTO990
2100 IFO(X)=LTHENO(X)=0:I=I+1
2105 X=19:NEXT:GOTO1000
2110 NEXT
2120 IFC$="neem panter"ANDO(30)=LTHEN6200
2130 IFRIGHT$(C$,4)="klok"ANDL=14THENPRINT"Te zwaar.":GOTO1190
2140 IFC$="neem kist"ANDO(26)=LTHENPRINT"Ik heb geen dorst.":GOTO1190
2150 IFC$="neem kluis"ANDO(25)=LTHENPRINT"De kluis zit aan de muur vast.":GOTO1190:ELSE1990
2190 FORX=1TO19:H=INSTR(5,C$," "):IFH<>0THENG=H-5:ELSEG=<E0>(C$)-4
2200 IFG>0THENIFMID$(C$,5,G)=RIGHT$(I$(X),G)ANDO(X)=0THEN2240
2220 NEXT:GOTO1990
2240 IFX=8AND(L=28ORL=29)THENO(8)=5:I=I-1:PRINTCHR$(134)"De boot drijft weg ...":X=19:NEXT:GOTO990
2270 I=I-1
2280 IF(L=28ORL=29)THENO(X)=L+2:GOTO1000
2300 O(X)=L:X=19:NEXT:GOTO1000
2350 FORX=1TO19:IFO(X)<>0THEN2370
2355 IF<E0>(O$(X))+POS(0)>38THENPRINT
2360 PRINTO$(X)". ";
2370 NEXT:PRINT:GOTO1190
2395 FORX=1TO8:IFVE(X)=LTHEN2415
2400 NEXT:GOTO1990
2415 X=8:NEXT:IFO(8)=0ANDR=1THENPRINTP$(2):GOTO1190
2420 FORX=1TO4:IFO(X)=0THENX=4:NEXT:PRINTP$(2):GOTO1190
2430 NEXT
2450 IF(L=13ANDC1=0)OR(L=14ANDC2=0)OR(L=17ANDC3=0)OR(L=18ANDC4=0)THENPRINTP$(1):GOTO1190
2485 IFW=0THENPRINT"U bent te dik.":GOTO1190
2490 IFL=13ANDC1=1THENL=21:GOTO1000
2500 IFL=14ANDC2=1THENL=24:GOTO1000
2510 IFL=17ANDC3=1THENL=26:GOTO1000
2520 IFL=18ANDC4=1THENL=27:GOTO1000:ELSE1990
2540 IFH=0THENPRINT"Nog niet klaar.":GOTO1190
2550 IFL=8THENL=34:GOTO1000
2560 IFL=36THENL=35:GOTO1000
2570 PRINT"Ik kan het niet vinden.":GOTO1190
2600 IFL<>5THEN1990
2610 IFO(8)<>0THENPRINT"Ik moet ergens op kunnen drijven.":GOTO1190
2630 IFR=0THENPRINT"Rubberboot is te slap.":GOTO1190
2640 L=28:GOTO1000
2650 IFL=16ANDK=0THENPRINT"De deur is op slot.":GOTO1190
2655 IFL=20THENL=16:K=1:GOTO1000
2660 IFL=16THENL=20:GOTO1000:ELSE1990
2680 IFL<>9THEN1990
2690 FORX=1TO19:IFO(X)=0THENX=19:NEXT:PRINT"U kunt de winkel niet binnen met alles  wat U bij zich heeft.":GOTO1190
2710 NEXT:L=10:GOTO1000
2750 IFRIGHT$(C$,8)<>"landhuis"ANDRIGHT$(C$,10)<>"korenvliet"THEN2770
2760 IFL=9THENL=12:GOTO1000
2765 IFL=1THENL=17:GOTO1000
2770 IFRIGHT$(C$,10)="ziekenhuis"ANDL=9THENL=11:GOTO1000
2780 IFC$="ga in tunnel"ANDL=31ANDO(13)=0THENL=32:GOTO1000
2790 IFC$="ga in kanaal"ANDL=4THENPRINTCHR$(130)"U gleed uit en viel.":S=1:L=11:GOTO990
2800 IFRIGHT$(C$,9)="afgraving"ANDL=8THENPRINT"Te steil.":GOTO1190
2810 IFC$="ga in schuur"ANDL=36THENL=37:GOTO1000:ELSE1990
2840 G=<E0>(C$)-10:GOTO2860
2845 G=<E0>(C$)+2
2850 G=<E0>(C$)-7
2860 IFG<1THEN1990:ELSEQ$=RIGHT$(C$,G):FORX=1TO33
2870 IFQ$=RIGHT$(I$(X),G)AND(O(X)=LORO(X)=0)THENX=33:NEXT:GOTO2900
2880 NEXT:GOTO1990
2900 IFQ$="fles"THENPRINTP$(3);N$(1):GOTO1190
2910 IFQ$="beker"THENPRINTP$(3);N$(2):GOTO1190
2920 IFQ$="tafel"THENPRINT"Er ligt een briefje met het nummer";N$(3):GOTO1190
2930 IFQ$="kist"THENPRINT"Er ontbreekt een fles.":GOTO1190
2940 IFQ$="boek"THEN6550
2950 IFRIGHT$(Q$,4)="klok"ANDO(13)=40THENPRINT"Er zit een duikbril in.":GOTO1190
2960 IFQ$="tas"ANDO(19)=40THENPRINT"Er zit een snorkel in.":GOTO1190
2970 IFQ$="schilderij"THENPRINT"Er zit een kluis achter !":E=1:O(25)=L:GOTO1190
2980 PRINT"Niets bijzonders.":GOTO1190
3000 IFO(11)<>0THENPRINT"Ik heb schoenen nodig.":GOTO1190
3010 IFL>9THENPRINT"Ik kan hier niet joggen.":GOTO1190
3015 W=1:PRINT"Pfff... Klaar !":GOTO1190
3020 IFL=28THENL=5:GOTO1000:ELSE1990
3030 IFS=1THENPRINT"Ik voel me niet goed.":GOTO1190
3040 IF(L=21ANDC1=0)OR(L=24ANDC2=0)OR(L=26ANDC3=0)OR(L=27ANDC4=0)THENPRINTP$(1):GOTO1190
3080 IFLEFT$(C$,4)="ga o"ANDL=18THEN6300
3090 FORX=1TO3:IFMID$(C$,4,1)=D$(X,L)THENL=D(X,L):X=3:NEXT:GOTO1000
3110 NEXT:PRINT"Richting niet duidelijk.":GOTO1190
3130 IFV=0ANDL=18THEN6200:ELSE1990
3150 IFV=1THEN1990
3160 IFL<>18THEN1990
3170 IFO(14)<>0ORL<>18THENPRINT"U hebt voedsel nodig.":GOTO1190
3180 PRINTCHR$(130)"Panter ontsnapte met de zalm.":IFO(14)=0THENI=I-1
3185 V=1:O(14)=40:O(30)=40:GOTO990
3190 IFL=2AND(O(12)=0ORO(12)=L)THENO(4)=2:GOTO1000:ELSE1990
3210 IF(L=28ORL=29)ANDO(8)=0ANDO(19)=0THENO(8)=5:I=I-1:L=L+2:PRINTCHR$(134)"De boot drijft weg ...":GOTO990
3220 IF(L=28ORL=29)ANDO(19)=0THENL=L+2:GOTO1000
3230 IFL=28ORL=29THENPRINT"U hebt een snorkel nodig.":GOTO1190:ELSE1990
3250 IFL=13ORL=21THENC1=1:GOTO1000
3260 IFL=14ORL=24THENC2=1:GOTO1000
3270 IFL=17ORL=26THENC3=1:GOTO1000
3280 IFL=18ORL=27THENC4=1:GOTO1000:ELSE1990
3295 IFL=16ORL=20THEN3305:ELSE1990
3305 IFL=16ANDK=0THENPRINT"Gaat niet. De deur is aan de andere kantvergrendeld.":GOTO1190
3310 PRINT"Ok.":GOTO1190
3350 IFL<>5THENPRINT"Niet hier.":GOTO1190
3360 IFR=1THENPRINT"Is al opgeblazen.":GOTO1190
3370 PRINT"Ok.":R=1:GOTO1190
3380 IFL<>8THENPRINT"Niet hier.":GOTO1190
3390 FORX=1TO6:IFO(X)=0ORO(X)=8THENHB=HB+1
3400 NEXT:IFHB=6THEN3420
3410 PRINT"Niet klaar.":HB=0:GOTO1190
3420 FORX=1TO6:IFO(X)=0THENI=I-1
3430 O(X)=40:NEXT:H=1:GOTO1000
3460 IFH=0THENPRINT"Niet klaar.":GOTO1190
3470 IFL=8ORL=36THENPRINT"U moet er eerst in.":GOTO1190
3480 IFL=35THEN3570:ELSEIFL<>34THEN1990
3500 FORY=5TO29STEP6:GOSUB6400:NEXT:L=35:GOTO1000
3570 FORY=29TO5STEP-6:GOSUB6400:NEXT:L=34:GOTO1000
3640 IFO(19)<>0THENPRINT"Hebt U niet.":GOTO1190
3650 IFL>27ANDL<32THENPRINT"Neem het snel terug !":GOTO1190
3660 O(19)=L:I=I-1:GOTO1000
3800 IFL<>2THEN1990:ELSEPRINTCHR$(133)"U viel eraf.":S=1:L=11:GOTO990
3900 IFO(9)=0ORO(9)=LTHENPRINT"Op het bord staat: Een goede plaats.":GOTO1190
3910 PRINT"Kunt het niet vinden.":GOTO1190
3950 IFO(19)=0THEN3080
3960 PRINT"U hebt een snorkel nodig.":GOTO1190
5000 XL$=D$(X,L):IFXL$="-"THENRETURN
5020 IFXL$="u"THENPRINT"uit";
5030 IFXL$="n"THENPRINT"noord";
5040 IFXL$="o"THENPRINT"oost";
5050 IFXL$="z"THENPRINT"zuid";
5060 IFXL$="w"THENPRINT"west";
5070 IFXL$="h"THENPRINT"(om)hoog";
5080 IFXL$="l"THENPRINT"(om)laag";
5090 PRINT".";:RETURN
5200 IFO(13)=0ANDL=31THENPRINT"een tunnel onder water.":RETURN
5230 IF(L=13ANDC1=1)OR(L=14ANDC2=1)OR(L=17ANDC3=1)OR(L=18ANDC4=1)THENPRINT"putdeksel. ";
5240 IFL=13ORL=14ORL=17ORL=18THENPRINT"afvoer.":RETURN
5270 IFH=1AND(L=8ORL=36)THENPRINT"hetelucht ballon.":RETURN
5280 Z=INT(10*RND(.5))+1
5290 IFL=6ANDZ=1THENPRINT"Adriaan met twee staven dynamiet."
5300 IFL=3ANDZ=3THENPRINT"Zoete met een koppel bloedhonden."
5310 IFL=7ANDZ=5THENPRINT"Berend met een bulldozer."
5320 IFL=33ANDZ<5THENPRINT"Er vliegt een vleermuis langs."
5330 IFL=27ANDZ<3THENPRINT"Er zit spinrag in Uw haar."
5340 IFL=25ANDZ<3THENPRINT"Een rat strijkt langs Uw been."
5350 IFL=4ANDZ=7THENPRINT"Een pad springt in het kanaal."
5360 IFL=28ANDO(14)=0ANDZ<5THENPRINT"Een hongerige meeuw cirkelt rond."
5370 IFL=2ANDZ=8THENPRINT"Een aapachtig figuur kijkt op U neer."
5390 RETURN
6000 IFC$="gezondheid"ORC$="wordt beter"ORC$="beterschap"THENS=0:PRINT"Genezen.":GOTO1190:ELSE1200
6100 IFO(19)=0THENPRINT"U hebt het al.":GOTO1190
6115 IFO(19)=40AND(O(7)=0ORO(7)=L)THENO(19)=0:I=I+1:GOTO1000
6130 IFO(19)=LTHENO(19)=0:I=I+1:GOTO1000:ELSE1990
6150 IFO(13)=0THENPRINT"Hebt U al.":GOTO1190
6160 IFO(13)=40ANDL=14THENO(13)=0:I=I+1:GOTO1000
6170 IFO(13)=LTHENO(13)=0:I=I+1:GOTO1000:ELSE1990
6200 PRINTCHR$(133)"U had nog net genoeg kracht om weg te":PRINTCHR$(133)"komen.":S=1:L=11:GOTO990
6300 IFV=0THENPRINT"Panter laat dat niet toe.":GOTO1190:ELSEL=19:GOTO1000
6400 Z=3+ABS(5*Y-85)/6:PRINTH$CHR$(4)CHR$(Z)CHR$(Y)"- - -"CHR$(4)CHR$(Z+1)CHR$(Y-1)"-     -"CHR$(4)CHR$(Z+2)CHR$(Y-1)"======="CHR$(4)CHR$(Z+3)CHR$(Y-1)"-     -"CHR$(4)CHR$(Z+4)CHR$(Y)"-   -"
6450 PRINTCHR$(4)CHR$(Z+5)CHR$(Y+1)".`."CHR$(4)CHR$(Z+6)CHR$(Y+1)". ."CHR$(4)CHR$(Z+7)CHR$(Y+1)"---"CHR$(4)CHR$(Z+8)CHR$(Y+1)"***"CHR$(4)CHR$(Z+9)CHR$(Y+1)"---"
6490 FORX=1TO1000:NEXTX:RETURN
6500 FORX=0TO20:OUT80,1:OUT80,0:FORY=0TO50:NEXT:NEXT:RETURN
6550 PRINTH$"   Zo bouwt U een heteluchtballon:"
6570 PRINT:PRINT:PRINTTAB(8)"#1   ballon":PRINTTAB(8)"#2   kachel":PRINTTAB(8)"#3   brandstof":PRINTTAB(8)"#4   gondel of schuit":PRINTTAB(8)"#5   kabel of touw":PRINTTAB(8)"#6   lucifers of aansteker"
6600 PRINT:PRINT:PRINT"   Bouw op een geschikte plaats !":GOSUB160:GOTO1000
7000 IFE=0THENPRINT"U kunt het niet vinden.":GOTO1190
7030 IFL<>16THENPRINT"Is hier niet.":GOTO1190
7040 PRINT"Combinatieslot.":PRINT"Type eerste getal  - ";:GOSUB150:F$(1)=C$:GOSUB6500:IFF$(1)<>S$(1)THEN7120
7070 PRINT"Type tweede getal  - ";:GOSUB150:F$(2)=C$:GOSUB6500:IFF$(1)+F$(2)<>S$(1)+S$(2)THEN7120
7100 PRINT"Type laatste getal - ";:GOSUB150:F$(3)=C$:GOSUB6500:IFF$(1)+F$(2)+F$(3)=S$(1)+S$(2)+S$(3)THENF=1:PRINT:PRINT"Klik ........ Er zit een testament in.":GOTO1190
7120 PRINT"Fout.":GOTO1190
7200 PRINTH$:PRINT:PRINT:PRINT:PRINTSTRING(41,42);
7210 PRINTSPC(38)"**        LAATSTE WILSBESCHIKKING       **"SPC(38)"**     Ik, Wout van Duysz ter Ghasth,   **     in goede gezondheid en bij       **     mijn volle verstand, laat        *";
7220 PRINT"*     al mijn bezittingen, met"SPC(9)"**     inbegrip van Korenvliet,"SPC(9)"**     na aan diegene die deze          **     kluis opent, wie dat ook         **     zijn moge, zelfs Olivier.        **";
7290 PRINTSPC(38)STRING(41,42)CHR$(4)CHR$(24)CHR$(10)"<<< gefeliciteerd >>>";:GOSUB165:GOTO65432
7500 PRINTH$:PRINT"Welkom in Rittenburg. U hebt onlangs    vernomen dat Uw excentrieke oom Wout is overleden. Het gerucht gaat dat deze    oude zonderling het landhuis Korenvliet heeft nagelaten aan degene die zijn     kluis vindt en weet te openen.":PRINT
7510 PRINT"Om het spel te spelen moet U objecten   en Uw omgeving onderzoeken en manipu-   leren door het gebruik van eenvoudige   opdrachten, zoals:"
7520 PRINT:PRINT"neem mand, ga zuid, leg iets weg, stop, ga door deur, ga in vijver, inventaris, bekijk iets, ga uit landhuis, help,     open deur, kijk (om U heen), verwijder  deksel, ga naar winkel"
7530 PRINT:PRINT"Richtingen mogen worden afgekort:       ga N,W,O,Z; U=uit, L=omlaag, H=omhoog":PRINT:GOTO160
8000 DATAballon,neergestorte weerballon,3,kachel,kleine houtkachel,1,mand,grote rieten mand,12,houtblokken,houtblokken,40,koord,rol koord,17,lucifers,doosje lucifers,15,tas,grote tas,16,rubberboot,rubberboot,1,bord,bord,8
8100 DATAvisnet,visnet,7,sportschoenen,sportschoenen,10,bijl,bijl,10,zwembril,zwembril,40,zalm,zalm,29,beker,kristallen beker,19,fles,lege champagnefles,33,boek,boek,14,schilderij,schilderij van Oom Wout,16,snorkel,snorkel,40,landhuis,Korenvliet,9,landhuis
8110 DATAKorenvliet,1,schuur,oude verlaten schuur,36,tafel,houten tafel,37,klok,Friese staartklok,14,kluis,kluis,40,kist,kist Chablis,18,bomen,bomen,2,deur,deur,20,deur,deur,16,panter,een geimporteerde panter,18,winkel,supermarkt,9,trap,trap,19
8120 DATAziekenhuis,ziekenhuis,9,op het binnenplein,in een bos,in een weiland,een glibberige kanaalkant,de oever van een vijver,op een braakliggend terrein,op een rotspaadje,de rand van een afgraving,op de hoofdstraat,in de supermarkt
8130 DATAin het ziekenhuis,in de foyer,in de huiskamer,in de studeerkamer,in een tuinkamer,op de overloop,in het atrium,westvleugel van wijnkelder,oostvleugel van wijnkelder,boven aan een trap,een uitlaat van het riool
8140 DATAeen bocht in het riool,vertakking in het riool,een uitlaat van het riool,een bocht in het riool,een uitlaat in het riool,een uitlaat in het riool,op de vijver,in de Zuidbaai,onder het wateroppervlak
8150 DATAonder het wateroppervlak,een ondergrondse stroom,in een grot,in een heteluchtballon,in een heteluchtballon,op een plateau,in een schuur
8160 DATAw,2,z,4,-,0,o,1,z,3,n,9,n,2,o,4,-,0,w,3,o,5,n,1,w,4,-,0,-,0,z,9,o,7,-,0,w,6,o,8,-,0,w,7,-,0,-,0,z,2,n,6,-,0,u,9,-,0,-,0,u,9,-,0,-,0,u,9,z,13,-,0,n,12,o,14,z,17,w,13,o,15,z,16,w,14,-,0,-,0,n,14,w,17,-,0,u,1,n,13,o,16,o,19,-,0,-,0,w
8170 DATA18,h,20,-,0,l,19,-,0,-,0,u,13,z,22,-,0,n,21,o,23,-,0,w,22,n,24,z,25,u,14,z,23,-,0,n,23,w,26,-,0,u,17,l,27,o,25,u,18,h,26,-,0,u,5,z,29,-,0,n,28,-,0,-,0,u,28,z,31,-,0,h,29,n,30,-,0,o,31,w,33,-,0,o,32,-,0,-,0,u,8,-,0,-,0,u,36,-,0,-,0
8180 DATA-,0,-,0,-,0,u,36,-,0,-,0,uitlaat is afgedekt,er past iets niet,binnenin is een briefje met nummer,13,14,17,18,21,24,26,27
65430 PRINTCHR$(8)CHR$(133)"Stop?";:TS=USR(0):IFTS<>3ANDTS<>106THENPRINTSTRING(6,8)SPC(6)STRING(5,8);:TS=1:RETURN
65432 PRINTH$:POKE24588,0:POKE24595,0:A=PEEK(24668):I=USR1(0):CLEAR50,(2*A+(A=3))*8192+24575:END::
65520 REM Nat.Lab. P2000 Computer Club
65521 REM programma nr 48
65522 REM KORENVLIET
65523 REM versie U6 dd 02-06-83
65524 REM vrijgegeven dd 04-07-83
65525 REM copyright Hans Pennings
