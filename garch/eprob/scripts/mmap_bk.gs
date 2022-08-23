
'open mmap.ctl'
'run /nfsuser/g01/wx20yz/grads/rgbset.gs'
'set display color white'

tit1='Ensemble mean 500 hPa height fcst with relative measure of predictability'
tit2='( colors, representing '
tit4=' % fcst probability )'

icnt=1

* for time step from 3 ( 24 hours lead time ) to 23 ( 240 hours lead time )
isteps=3
istepe=33

istep=isteps
while (istep<=istepe)
fhours=gethrs(istep)
tit3=gettls(istep)
*

'set lat 10 80'
'set lon 170 300'

'clear'
'enable print mmap_IYMDH_'fhours'.gr'
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
'run cbarn.gs'
'set gxout contour'
'set ccolor 1'
'set cint 40'
'set cthick 8'
'd hgtprs'
'set string 4'
'set strsiz 0.15'
*'draw title 'tit1' \ 'tit2''tit3''tit4' \ ini: IYMDH fcst: 'fhours' hours '
'draw string 5.5 8.3 'tit1
'set string 4'
'set strsiz 0.12'
'draw string 5.5 8.0 'tit2''tit3''tit4
'set string 4'
'set strsiz 0.12'
'draw string 5.5 7.8 ini: IYMDH fcst: 'fhours' hours '
'set string 4'
'set strsiz 0.10'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'
'disable print'

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
*'quit'

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
return fhours

function gettls(istep)
if(istep=3); fhours='1.3 10.6 18.3 25.0 33.5 44.5 57.8 66.1 74.2 82.9 93.8';endif
if(istep=5); fhours='2.4 12.4 18.0 23.3 28.8 36.1 43.9 52.0 62.1 73.0 88.9';endif
if(istep=7); fhours='3.7 12.2 16.5 20.2 24.4 30.3 36.9 45.7 56.8 66.4 77.7';endif
if(istep=9); fhours='4.8 11.7 15.2 18.3 21.6 27.2 33.6 43.1 51.5 56.5 61.3';endif
if(istep=11);fhours='5.7 11.3 14.0 16.6 19.8 24.7 32.1 40.1 47.3 50.0 51.7';endif
if(istep=13);fhours='6.4 10.9 13.1 15.3 18.5 23.1 29.5 37.3 41.9 43.8 44.3';endif
if(istep=15);fhours='7.0 10.6 12.6 14.5 17.4 22.0 28.6 34.2 36.2 35.7 35.6';endif
if(istep=17);fhours='7.5 10.4 12.1 14.0 16.6 21.4 26.7 31.1 32.0 30.3 26.5';endif
if(istep=19);fhours='7.8 10.3 11.8 13.4 16.3 20.4 25.8 29.8 28.7 24.3 23.4';endif
if(istep=21);fhours='8.1 10.2 11.6 13.0 15.2 19.6 24.5 26.8 26.0 24.0 23.2';endif
if(istep=23);fhours='8.3 10.2 11.3 12.9 15.4 18.6 21.5 24.3 22.4 20.2 23.9';endif
if(istep=25);fhours='8.4 10.2 11.3 12.9 14.8 17.7 20.7 23.5 21.0 20.4 21.7';endif
if(istep=27);fhours='8.5 10.1 11.2 12.7 14.3 17.7 19.1 20.7 21.4 18.1 21.8';endif
if(istep=29);fhours='8.6 10.1 11.3 12.4 14.5 17.8 18.6 19.5 19.4 17.3 20.5';endif
if(istep=31);fhours='8.7 10.1 11.1 12.3 14.5 17.2 19.7 19.0 18.7 17.3 19.2';endif
if(istep=33);fhours='8.9  9.8 10.7 12.1 14.1 18.0 20.8 22.1 23.3 26.2 32.0';endif
return fhours
