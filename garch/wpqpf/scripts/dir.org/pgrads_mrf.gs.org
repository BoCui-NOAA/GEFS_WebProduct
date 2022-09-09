*
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65'
'set mproj nps'
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'

'set display color white'
'clear'

ist=3
ied=9
'enable print gmeta_mrf1'

while (ist<=ied)

 'set t 'ist''
 if (ist=3)
 'set vpage 0.5 5.5 3.8 7.6'   
 tm1=12
 tm2=36
 endif
 if (ist=5)
 'set vpage 5.5 10.5 3.8 7.6' 
 tm1=36
 tm2=60
 endif
 if (ist=7)
 'set vpage 0.5 5.5 0.1 3.9'
 tm1=60
 tm2=84
 endif
 if (ist=9)
 'set vpage 5.5 10.5 0.1 3.9'   
 tm1=84
 tm2=108
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
 'set ccols  0   21  22  31   33   35   37   39'
 'd pmrf + pmrf(t+1)'
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   0.01 2.5 5.0 10.0 25.0'
 'd pmrf + pmrf(t+1)'
 'draw title 'tm1'-'tm2' hours forecast (mm)'
 'run cbar.gs'
 ist=ist+2

endwhile

***
'set vpage 0.0 11.0 0.3 8.5'
*'draw title NCEP/MRF Precipitation Forecast (Initial: YMDH)'
'draw title NCEP/GFS Precipitation Forecast (Initial: YMDH)'
'print'
'disable print gmeta_mrf1'
'printim gmeta_mrf1.png png x695 y545 white'
'clear'
ist=11
ied=17
'enable print gmeta_mrf2'

while (ist<=ied)

 'set t 'ist''
 if (ist=11)
 'set vpage 0.5 5.5 3.8 7.6'   
 tm1=108
 tm2=132
 endif
 if (ist=13)
 'set vpage 5.5 10.5 3.8 7.6' 
 tm1=132
 tm2=156
 endif
 if (ist=15)
 'set vpage 0.5 5.5 0.1 3.9'
 tm1=156
 tm2=180
 endif
 if (ist=17)
 'set vpage 5.5 10.5 0.1 3.9'   
 tm1=180
 tm2=204
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
 'set ccols  0   21  22  31   33   35   37   39'
 'd pmrf + pmrf(t+1)'
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   0.01 2.5 5.0 10.0 25.0'
 'd pmrf + pmrf(t+1)'
 'draw title 'tm1'-'tm2' hours forecast (mm)'
 'run cbar.gs'
 ist=ist+2

endwhile

***
'set vpage 0.0 11.0 0.3 8.5'
*'draw title NCEP/MRF Precipitation Forecast (Initial: YMDH)'
'draw title NCEP/GFS Precipitation Forecast (Initial: YMDH)'
'print'
'disable print gmeta_mrf2'
'printim gmeta_mrf2.png png x695 y545 white'
'clear'
ist=19
ied=25
'enable print gmeta_mrf3'

while (ist<=ied)

 'set t 'ist''
 if (ist=19)
 'set vpage 0.5 5.5 3.8 7.6'   
 tm1=204
 tm2=228
 endif
 if (ist=21)
 'set vpage 5.5 10.5 3.8 7.6' 
 tm1=228
 tm2=252
 endif
 if (ist=23)
 'set vpage 0.5 5.5 0.1 3.9'
 tm1=252
 tm2=276
 endif
 if (ist=25)
 'set vpage 5.5 10.5 0.1 3.9'   
 tm1=276
 tm2=300
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs  0.01 5.0 10.0 15.0 20.0 25.0 30.0'
 'set ccols  0   21  22  31   33   35   37   39'
 'd pmrf + pmrf(t+1)'
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   0.01 2.5 5.0 10.0 25.0'
 'd pmrf + pmrf(t+1)'
 'draw title 'tm1'-'tm2' hours forecast (mm)'
 'run cbar.gs'
 ist=ist+2

endwhile

***
'set vpage 0.0 11.0 0.3 8.5'
*'draw title NCEP/MRF Precipitation Forecast (Initial: YMDH)'
'draw title NCEP/GFS Precipitation Forecast (Initial: YMDH)'
'print'
'disable print gmeta_mrf3'
'printim gmeta_mrf3.png png x695 y545 white'
