
'open nmc_ctl'
'open cmc_ctl'

*'run $SHOME/$LOGNAME/grads/rgbset.gs'
'run rgbset.gs'
'set gxout shaded'
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
'enable print gmeta_gfs_global_2007020100a'
'set display color white'
'clear'
istart=1
'set vpage 0.0 8.5 5.00 10.7'

'set t 3'
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc'
'define tcnt=aave(apcpsfc,lon=0,lon=360,lat=-90,lat=90)'
'd tcnt'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
*'d apcpsfc'
'draw ylab 1-day forecast (NCEP)'

*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'

istart=1
'set vpage 0.0 8.5 0.00 5.7'
'set t 2'
'set grads off'
'set gxout shaded'
'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
'set ccols  0   21  22  31   33   35   37   39'
'd apcpsfc.2(t=2)+apcpsfc.2(t=3)'
'define tcnt=aave(apcpsfc.2(t=2)+apcpsfc.2(t=3),lon=0,lon=360,lat=-90,lat=90)'
'd tcnt'
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set cstyle 1'
'set clevs   0.01 2.5 5.0 10.0 25.0'
*'d apcpsfc.2(t=2)+apcpsfc.2(t=3)'
'draw ylab 1-day forecast (CMC)'

*'run $SHOME/$LOGNAME/grads/cbar.gs'
'run cbar.gs'


'set vpage 0.0 8.5 0.0 11.0'
'set strsiz 0.16'
'draw string 4.25 10.9 Quantitative Precipitation Forecast (QPF)'
'set strsiz 0.16'
'draw string 4.25 10.6 Ini: 2007020100'
'set strsiz 0.08'
'draw string 1.6 0.15 YUEJIAN ZHU, GMB/EMC/NCEP/NOAA'
'print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

'disable print gmeta_gfs_global_2007020100a'

'quit'

