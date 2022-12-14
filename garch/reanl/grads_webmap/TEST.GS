*
'open favg.ctl'
'open fp10.ctl'
'open fp90.ctl'
'open aavg.ctl'
'open ap10.ctl'
'open ap90.ctl'

'run /nfsuser/g01/wx20yz/grads/rgbset.gs'

*'set lon 210 310'
*'set lat 10 65'
'set lon 150 350'
'set lat 5 90'
'set mproj nps'
*'set mpvals -120 -75 20 55'
'set mpvals -115 -80 15 85'
'set mpdset mres'
'set map 15 3 2'

'set t STEP'
'set display color white'
'clear'
'enable print amap_YMDH_HOUR.gs'
'set vpage 0.0 4.1 0.5 7.5'
'set grads off'
'set gxout shaded'
'set clevs 10 20 30 40 50 60 70 80 90'
'set ccols 49 47 45 43 41 21 23 25 27 29'
'd tmp2m.5'
*'cbar'
'set grads off'
'set gxout contour'
'set cint 4'
'd tmp2m.2'
*'draw title 10% ens prob fcst'

'set vpage 3.45 7.55 0.5 7.5'
'set grads off'
'set gxout shaded'
'set clevs 10 20 30 40 50 60 70 80 90'
'set ccols 49 47 45 43 41 21 23 25 27 29'
'd tmp2m.4'
*'run cbarn.gs 0.8 0 6.5 0.5'
'run cbarn.gs'
'set grads off'
'set gxout contour'
'set cint 4'
'd tmp2m.1'
*'draw title 50% ens prob fcst'

'set vpage 6.9 11.0 0.5 7.5'
'set grads off'
'set gxout shaded'
'set clevs 10 20 30 40 50 60 70 80 90'
'set ccols 49 47 45 43 41 21 23 25 27 29'
'd tmp2m.6'
*'cbar'
'set grads off'
'set gxout contour'
'set cint 4'
'd tmp2m.3'
*'draw title 90% ens prob fcst'

'set vpage 0.0 11.0 0.0 8.5'
'set string 1 c 7'
'set strsiz 0.24'
'draw string 5.5 8.2 Temperature at 2-meter, HOUR-hour forecast'
'set strsiz 0.20'
'draw string 5.5 7.8 Ini. time:YMDH   Valid time:FDATE'
'set string 4 c 6'
'set strsiz 0.14'
'draw string 5.5 7.4 Contour-forecast; Shaded-forecast anomalies'
*'draw title 2-meter temperature HOUR-hour forecast (ini:YMDH)'
'set strsiz 0.12'
'draw string 2.2 6.8 10% ens prob fcst'
'draw string 5.5 6.8 50% ens prob fcst'
'draw string 8.8 6.8 90% ens prob fcst'
'set string 4'
'set strsiz 0.08'
'draw string 9.6 0.15 YUEJIAN ZHU, GCWMB/EMC/NCEP/NOAA'
'print'
'printim amap_YMDH_HOUR.gif '
'disable print amap_YMDH_HOUR.gs'
'quit'
