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
115 poke782,ho
116 poke783,0
117 sys65520
118 return
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
304 return
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
950 rem stop
951 stop
