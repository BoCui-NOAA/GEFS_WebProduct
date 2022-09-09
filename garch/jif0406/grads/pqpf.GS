
'open FILENAME1'
'open FILENAME2'

*'run $SHOME/$LOGNAME/grads/rgbset.gs'
'run rgbset.gs'
*'set lon 210 310'
'set lon 180 340'
*'set lat 10 65 '
'set lat 10 85 '
'set mproj nps '
*'set mpvals -120 -75 20 55'
'set mpvals -130 -65 20 70'
'set gxout shaded'
'set mpdset mres'
'set display color white'
'clear'

***
*** t=3 (0-24 hrs)
*** t=4 (12-36 hrs)
*** t=5 (24-48 hrs)
*** t=6 (36-60 hrs)
*** t=7 (48-72 hrs)
*** t=8 (60-84 hrs)
*** t=9 (72-96 hrs)
*** t=10 (84-108 hrs)
*** t=11 (96-120 hrs)
***
'enable print gmeta_AMT1_YYMMDDHHa'
'set display color white'
'clear'
istart=1
iend=4
while (istart<=iend)
 if (istart=1)
 'set vpage 0.0 4.8 7.47 10.7'
 endif
 if (istart=2)
 'set vpage 0.0 4.8 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 0.0 4.8 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 0.0 4.8 0.18 3.41'
 endif

ttime=istart*2+2

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc'
'draw ylab 'istart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

istart=1
iend=4
while (istart<=iend)
 if (istart=1)
 'set vpage 3.7 8.5 7.47 10.70'
 endif
 if (istart=2)
 'set vpage 3.7 8.5 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 3.7 8.5 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 3.7 8.5 0.18 3.41'
 endif

ttime=istart*2+2

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc.2'
'draw ylab 'istart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/day)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: YYMMDDHH'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

'printim aAMT1_YYMMDDHH.png png x600 y800 white'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHa'

'enable print gmeta_AMT1_YYMMDDHHb'
'set display color white'
'clear'
istart=1
iend=4
while (istart<=iend)
 if (istart=1)
 'set vpage 0.0 4.8 7.47 10.7'
 endif
 if (istart=2)
 'set vpage 0.0 4.8 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 0.0 4.8 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 0.0 4.8 0.18 3.41'
 endif

ttime=istart*2+9

jstart=istart+4
'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAM/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

istart=1
iend=4
while (istart<=iend)
 if (istart=1)
 'set vpage 3.7 8.5 7.47 10.70'
 endif
 if (istart=2)
 'set vpage 3.7 8.5 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 3.7 8.5 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 3.7 8.5 0.18 3.41'
 endif

ttime=istart*2+9
jstart=istart+4

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc.2'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/day)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: YYMMDDHH'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

'printim bAMT1_YYMMDDHH.png png x600 y800 white'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHb'

'enable print gmeta_AMT1_YYMMDDHHc'
'set display color white'
'clear'
istart=1
iend=4
while (istart<=iend)
 if (istart=1)
 'set vpage 0.0 4.8 7.47 10.7'
 endif
 if (istart=2)
 'set vpage 0.0 4.8 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 0.0 4.8 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 0.0 4.8 0.18 3.41'
 endif

ttime=istart*2+17
jstart=istart+8

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

istart=1
iend=4
while (istart<=iend)
 if (istart=1)
 'set vpage 3.7 8.5 7.47 10.70'
 endif
 if (istart=2)
 'set vpage 3.7 8.5 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 3.7 8.5 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 3.7 8.5 0.18 3.41'
 endif

ttime=istart*2+17
jstart=istart+8

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc.2'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/day)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: YYMMDDHH'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

'printim cAMT1_YYMMDDHH.png png x600 y800 white'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHc'

'enable print gmeta_AMT1_YYMMDDHHd'
'set display color white'
'clear'
istart=1
iend=3
while (istart<=iend)
 if (istart=1)
 'set vpage 0.0 4.8 7.47 10.7'
 endif
 if (istart=2)
 'set vpage 0.0 4.8 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 0.0 4.8 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 0.0 4.8 0.18 3.41'
 endif

ttime=istart*2+25
jstart=istart+12

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc'
'draw ylab 'jstart'-day forecast'

if (istart=3)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

istart=1
iend=3
while (istart<=iend)
 if (istart=1)
 'set vpage 3.7 8.5 7.47 10.70'
 endif
 if (istart=2)
 'set vpage 3.7 8.5 5.04 8.27'
 endif
 if (istart=3)
 'set vpage 3.7 8.5 2.61 5.84'
 endif
 if (istart=4)
 'set vpage 3.7 8.5 0.18 3.41'
 endif

ttime=istart*2+25
jstart=istart+12

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  5 15 25 35 45 55 65 75 85 95'
'set ccols  0 41 31 32 33 34 35 36 37 38 39'
'd probsfc.2'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs 5 35 65 95  '
'd probsfc.2'
'draw ylab 'jstart'-day forecast'

if (istart=3)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Ens Prob of Precip Amount Exceeding 'AMT2' inch ('AMT1' mm/day)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: YYMMDDHH'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

'printim dAMT1_YYMMDDHH.png png x600 y800 white'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_AMT1_YYMMDDHHd'
'quit'

