*
 ist=7
 ied=10
while (ist<=ied)

 if (ist=7)
    plot=a 
    amt1=1.0
 endif
 if (ist=8)
    plot=b 
    amt1=5.0
 endif
 if (ist=9)
    plot=c 
    amt1=10.0
 endif
 if (ist=10)
    plot=d 
    amt1=25.0
 endif

'clear'
'set vpage 0.0 11.0 0.0 8.5'
*'set strsiz 0.2'
*'draw string 5.5 8.2 Ini time:YMDH  Valid Period:YMD1 - YMD2'
*'draw string 5.5 7.8 Ensemble based probability of precip. amount exceeding '
*'set strsiz 0.15'
*'draw string 5.5 7.3 'amt1' mm '
'set lon 0 360'
'set lat -90 90'
'set vpage 0.0 11.0 0.0 8.0'
'set mproj latlon'
'set gxout shaded'
'set display color white'
'enable print gmeta_g'plot'STEP'
'set t STEP'
'set grads off'
'set gxout shaded'
'set clevs    5 15 25 35 45 55 65 75 85 95'
'set ccols  26 25 24 23 22 21 31 33 35 37 39'
*'set ccols  29 27 26 24 23 21 31 33 35 37 39 0'
'd pp'ist''    
'set gxout contour'
'set cthick 2'
'set ccolor 1'
'set clevs  50'             
'd pp'ist''    
'run cbar.gs'
'set vpage 0.0 11.0 0.0 8.5'
'set strsiz 0.2'
'draw string 5.5 8.2 Ini time:YMDH  Valid Period:YMD1 - YMD2'
'draw string 5.5 7.8 Ensemble based probability of precip. amount exceeding '
'set strsiz 0.15'
'draw string 5.5 7.3 'amt1' mm '
***
'print'
'disable print gmeta_g'plot'STEP'
'printim gmeta_g'plot'STEP.png png x695 y545 white'

 ist=ist+1
endwhile

