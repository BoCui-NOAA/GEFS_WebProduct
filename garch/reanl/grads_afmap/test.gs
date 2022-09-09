
'open test.ctl'
'open testm.ctl'

'run rgbset.gs'
'set display color white'
'clear'

'set lon 150 350'
'set lat 5 90'
'set mproj nps'
'set mpvals -115 -78 13 80'
'set mpdset mres'
'set map 15 3 2'

'set gxout shaded'
'set grads off'
'enable print gmeta'

*** left map - one standard deviation

'define hefi1 = sum(const(const(maskout(tmin2m,tmin2m-84.1),1),0,-u),e=1,e=20)'
'define lefi1 = sum(const(const(maskout(tmin2m,tmin2m-15.9),0),1,-u),e=1,e=20)'

*'set t '
'set display color white'
'clear'
'set vpage 0.0 4.1 0.5 7.5'
'set grads off'
'set gxout shaded'
'set clevs 20 40 60 80 100'
'set ccols 0 41 43 45 47 49'
'd maskout(lefi1/20.0*100.0,lefi1-0.0001)'
*'d lefi1/20.0*100.0'
'run cbarn.gs'

'set clevs 20 40 60 80 100'
'set ccols 0 21 23 25 27 29'
'd maskout(hefi1/20.0*100.0,hefi1-0.0001)'
*'d hefi1/20.0*100.0'

'set grads off'
'set gxout contour'
'set ccolor 1'
'set cint 4'
'd tmin2m.2'


*** centre map - two standard deviation

'define hefi2 = sum(const(const(maskout(tmin2m,tmin2m-97.7),1),0,-u),e=1,e=20)'
'define lefi2 = sum(const(const(maskout(tmin2m,tmin2m-2.3),0),1,-u),e=1,e=20)'

*'set t '
'set vpage 3.45 7.55 0.5 7.5'
'set grads off'
'set gxout shaded'
'set clevs 20 40 60 80 100'
'set ccols 0 41 43 45 47 49'
'd maskout(lefi2/20.0*100.0,lefi2-0.0001)'
*'run cbarn.gs 0.5 0 4.5 0.5'

'set clevs 20 40 60 80 100'
'set ccols 0 21 23 25 27 29'
'd maskout(hefi2/20.0*100.0,hefi2-0.0001)'
*'run cbarn.gs 4.5 0 8.5 0.5'
 
'set grads off'
'set gxout contour'
'set ccolor 1'
'set cint 4'
'd tmin2m.2'

*** right map - three standard deviation

'define hefi3 = sum(const(const(maskout(tmin2m,tmin2m-99.8),1),0,-u),e=1,e=20)'
'define lefi3 = sum(const(const(maskout(tmin2m,tmin2m-0.02),0),1,-u),e=1,e=20)'

*'set t '
'set vpage 6.9 11.0 0.5 7.5'
'set grads off'
'set gxout shaded'
'set clevs 20 40 60 80 100'
'set ccols 0 41 43 45 47 49'
'd maskout(lefi3/20.0*100.0,lefi3-0.0001)'

'set clevs 20 40 60 80 100'
'set ccols 0 21 23 25 27 29'
'd maskout(hefi3/20.0*100.0,hefi3-0.0001)'
'run cbarn.gs'

'set grads off'
'set gxout contour'
'set ccolor 1'
'set cint 4'
'd tmin2m.2'

'set vpage 0.0 11.0 0.0 8.5'
'set string 1 c 7'
'set strsiz 0.24'
'draw string 5.5 8.2 Minimum Temperature at 2-meter, 120-hour forecast'
'set strsiz 0.20'
'draw string 5.5 7.8 Ini. time:2013012200   Valid time:2013012700'
'set string 4 c 6'
'set strsiz 0.14'
'draw string 5.5 7.4 Contour-mean forecast; Shaded-forecast anomalies'
'set strsiz 0.12'
'draw string 2.2 6.8 one stdv'
'draw string 5.5 6.8 two stdv'
'draw string 8.8 6.8 three stdv'
'set string 4'
'set strsiz 0.08'
'draw string 9.6 0.15 YUEJIAN ZHU, GCWMB/EMC/NCEP/NOAA'
'print'
'printim amap_na2013012200_120.gif gif x1100 y850 white'
'quit'

