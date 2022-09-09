
'open nmc_ctl'
'open cmc_ctl'

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
*** t=5 (0-24 hrs)
*** t=7 (12-36 hrs)
*** t=9 (24-48 hrs)
*** t=11 (36-60 hrs)
*** t=13 (48-72 hrs)
*** t=15 (60-84 hrs)
*** t=17 (72-96 hrs)
***
'enable print gmeta_gfs_2007020100a'
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

ttime=istart*4+1

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc'
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

ttime=istart*5+1

'set t 'ttime''
tm1=ttime-1
tm2=ttime-2
tm3=ttime-3
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'draw ylab 'istart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: 2007020100'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_gfs_2007020100a'

'enable print gmeta_gfs_2007020100b'
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

ttime=istart*4+17

jstart=istart+4
'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc'
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

ttime=istart*4+17
jstart=istart+4

'set t 'ttime''
tm1=ttime-1
tm2=ttime-2
tm3=ttime-3
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: 2007020100'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_gfs_2007020100b'

'enable print gmeta_gfs_2007020100c'
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

ttime=istart*4+33
jstart=istart+8

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc'
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

ttime=istart*4+33
jstart=istart+8

'set t 'ttime''
tm1=ttime-1
tm2=ttime-2
tm3=ttime-3
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: 2007020100'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_gfs_2007020100c'

'enable print gmeta_gfs_2007020100d'
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

ttime=istart*4+49
jstart=istart+12

'set t 'ttime''
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc'
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

ttime=istart*4+49
jstart=istart+12

'set t 'ttime''
tm1=ttime-1
tm2=ttime-2
tm3=ttime-3
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
'd apcpsfc.2(t='ttime')+apcpsfc.2(t='tm1')+apcpsfc.2(t='tm2')+apcpsfc.2(t='tm3')'
'draw ylab 'jstart'-day forecast'

if (istart=4)
*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'
endif

istart=istart+1
endwhile

'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: 2007020100'
'set string 4'
'draw string 2.25 10.5 NCEP'
'draw string 6.25 10.5 CMC'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_gfs_2007020100d'
'quit'

