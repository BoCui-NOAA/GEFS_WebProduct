
'open mmap.ctl'
'run rgbset.gs'
'set display color white'

tit1='Relative measure of predictability (colors)'             
tit2='for ensemble mean forecast (contours) of 500 hPa height'

icnt=0

* for time step from 3 ( 24 hours lead time ) to 23 ( 240 hours lead time )
isteps=3
istepe=33

istep=isteps
while (istep<=istepe)
fhours=gethrs(istep)
vdays=getvday(istep)
*

'set lat 10 70'
'set lon 0 130'

'clear'
'enable print mmap_IYMDH_'fhours'.gr'
'set vpage 0 11 0.1 8.5'
'set t 'istep''
'set lev 500'
'set grads off'
*'set gxout grfill'
'set gxout shaded'
'set clevs    10  20  30   40  50  60  70  80  90 '
'set ccols  45  44  43  42   41  21  22  23  24  25'
*'set clevs    25   50   75  '  
*'set ccols  48   42   62   68 '
'd hstdvprs' 
'run cbarn.gs 0.8 0 6.5 0.5'
'set gxout contour'
'set ccolor 1'
'set cint 40'
'set cthick 8'
'd hgtprs'
'set vpage 0 11 0.0 8.5'
*'draw title 'tit1' \ 'tit2' \ ini: IYMDH fcst: 'fhours' hours '
'set string 1'
'set strsiz 0.22'
'draw string 5.5 8.2 'tit1
'set string 1'
'set strsiz 0.22'
'draw string 5.5 7.9 'tit2
'set strsiz 0.16'
'draw string 5.5 7.5 ini: IYMDH valid: 'vdays' fcst: 'fhours' hours '
jstep=istep-1
'set string 4'
'set strsiz 0.12'
'examp.gs 'jstep
'set strsiz 0.12'
'draw string 1.6 0.95 Probability (%)'
'set string 1'
'set strsiz 0.12'
'draw string 1.6 0.60 Measure of predictability (%)'
'set string 4'
'set strsiz 0.08'
'draw string 9.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'printim mmap_IYMDH_'fhours'_pac.png png x1100 y850 white'
*'print'
*'disable print'

if(icnt=1)
say 'type in c to continue or quit to exit'
pull corquit
corquit
endif
if(icnt=0)
'c'
endif

istep=istep+2
endwhile

*'clear'
'quit'

function gethrs(istep)
if(istep=1);fhours='00';endif
if(istep=2);fhours='12';endif
if(istep=3);fhours='24';endif
if(istep=4);fhours='36';endif
if(istep=5);fhours='48';endif
if(istep=6);fhours='60';endif
if(istep=7);fhours='72';endif
if(istep=8);fhours='84';endif
if(istep=9);fhours='96';endif
if(istep=10);fhours='108';endif
if(istep=11);fhours='120';endif
if(istep=12);fhours='132';endif
if(istep=13);fhours='144';endif
if(istep=14);fhours='156';endif
if(istep=15);fhours='168';endif
if(istep=16);fhours='180';endif
if(istep=17);fhours='192';endif
if(istep=18);fhours='204';endif
if(istep=19);fhours='216';endif
if(istep=20);fhours='228';endif
if(istep=21);fhours='240';endif
if(istep=22);fhours='252';endif
if(istep=23);fhours='264';endif
if(istep=24);fhours='276';endif
if(istep=25);fhours='288';endif
if(istep=26);fhours='300';endif
if(istep=27);fhours='312';endif
if(istep=28);fhours='324';endif
if(istep=29);fhours='336';endif
if(istep=30);fhours='348';endif
if(istep=31);fhours='360';endif
if(istep=32);fhours='372';endif
if(istep=33);fhours='384';endif
return fhours

function getvday(istep)
if(istep=1);vdays='VYMDP0';endif
if(istep=2);vdays='VYMDP1';endif
if(istep=3);vdays='VYMDP2';endif
if(istep=4);vdays='VYMDP3';endif
if(istep=5);vdays='VYMDP4';endif
if(istep=6);vdays='VYMDP5';endif
if(istep=7);vdays='VYMDP6';endif
if(istep=8);vdays='VYMDP7';endif
if(istep=9);vdays='VYMDP8';endif
if(istep=10);vdays='VYMDP9';endif
if(istep=11);vdays='VYMD10';endif
if(istep=12);vdays='VYMD11';endif
if(istep=13);vdays='VYMD12';endif
if(istep=14);vdays='VYMD13';endif
if(istep=15);vdays='VYMD14';endif
if(istep=16);vdays='VYMD15';endif
if(istep=17);vdays='VYMD16';endif
if(istep=18);vdays='VYMD17';endif
if(istep=19);vdays='VYMD18';endif
if(istep=20);vdays='VYMD19';endif
if(istep=21);vdays='VYMD20';endif
if(istep=22);vdays='VYMD21';endif
if(istep=23);vdays='VYMD22';endif
if(istep=24);vdays='VYMD23';endif
if(istep=25);vdays='VYMD24';endif
if(istep=26);vdays='VYMD25';endif
if(istep=27);vdays='VYMD26';endif
if(istep=28);vdays='VYMD27';endif
if(istep=29);vdays='VYMD28';endif
if(istep=30);vdays='VYMD29';endif
if(istep=31);vdays='VYMD30';endif
if(istep=32);vdays='VYMD31';endif
if(istep=33);vdays='VYMD32';endif
return vdays

