*
'set display color white'
'clear'
'enable print gmeta_cpc_STEP'
'set t STEP'

ist=1
ied=4

while (ist<=ied)
 if (ist=1)
 'set vpage 0.5 5.5 3.8 7.6'   
 am1=0.5
 am2=12.7
 endif
 if (ist=2)
 'set vpage 5.5 10.5 3.8 7.6' 
 am1=1.0 
 am2=25.4
 endif
 if (ist=3)
 'set vpage 0.5 5.5 0.1 3.9'
 am1=2.0
 am2=50.8
 endif
 if (ist=4)
 'set vpage 5.5 10.5 0.1 3.9'   
 am1=4.0
 am2=101.6
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs    5 15 25 35 45 55 65 75 85 95'
 'set ccols  26 25 24 23 22 21 31 33 35 37 39'
 'd pp'ist''    
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   5 35 65 95'          
 'd pp'ist''    
 'draw title 'am1' inch ('am2'mm)'
*'run $SHOME/$LOGNAME/grads/cbar.gs'
 'run cbar.gs'
 ist=ist+1
endwhile

***
'set vpage 0.0 11.0 0.3 8.5'
'draw title Ini time:YMDH  Valid Forecast Period:YMD1 - YMD2 hours'
'set vpage 0.0 11.0 0.0 8.1'
'draw title Ensemble based probability of precip. amount exceeding'
'print'
'disable print gmeta_cpc_STEP'
'printim gmeta_cpc_STEP.png png x695 y545 white'
