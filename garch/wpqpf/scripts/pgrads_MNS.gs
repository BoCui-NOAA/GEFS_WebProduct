'set lon 30 150'  
'set lat 0 65'
'set mproj nps'
'set mpvals 70 120 5 50'
*'set mpvals 60 110 5 50'
'set gxout shaded'
*
'set display color white'
'clear'

'enable print gmeta_MNS1'
step=4
stepend=10
while (step<=stepend)

'set t 'step''   

 if (step=4)
 'set vpage 0.5 5.5 3.8 7.6'
 tm1=12
 tm2=36
 endif
 if (step=6)
 'set vpage 5.5 10.5 3.8 7.6' 
 tm1=36
 tm2=60
 endif
 if (step=8)
 'set vpage 0.5 5.5 0.1 3.9'
 tm1=60
 tm2=84
 endif
 if (step=10)
 'set vpage 5.5 10.5 0.1 3.9'
 tm1=84
 tm2=108
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs    5 15 25 35 45 55 65 75 85 95'
 'set ccols  26 25 24 23 22 21 31 33 35 37 39'
*'set ccols  29 27 26 24 23 21 31 33 35 37 39 0'
 'd pp9'    
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   5 35 65 95'          
 'd pp9 '   
 'draw title 'tm1'-'tm2' hours forecast' 
 'run cbar.gs'
 step=step+2
endwhile

 'set vpage 0.0 11.0 0.3 8.5'
 'draw title Initial time:YMDH precip. amount = 10 mm / 24 hours'
 'set vpage 0.0 11.0 0.0 8.1'
 'draw title Ensemble based probability of precip. amount exceeding'
 'print'
 'disable print gmeta_MNS1'
 'printim gmeta_MNS1.png png x695 y545 white'
 'clear'

'enable print gmeta_MNS2'
step=12
stepend=18
while (step<=stepend)

'set t 'step''

 if (step=12)
 'set vpage 0.5 5.5 3.8 7.6'
 tm1=108
 tm2=132
 endif
 if (step=14)
 'set vpage 5.5 10.5 3.8 7.6'
 tm1=132
 tm2=156
 endif
 if (step=16)
 'set vpage 0.5 5.5 0.1 3.9'
 tm1=156
 tm2=180
 endif
 if (step=18)
 'set vpage 5.5 10.5 0.1 3.9'
 tm1=180
 tm2=204
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs    5 15 25 35 45 55 65 75 85 95'
 'set ccols  26 25 24 23 22 21 31 33 35 37 39'
*'set ccols  29 27 26 24 23 21 31 33 35 37 39 0'
 'd pp9'
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   5 35 65 95'
 'd pp9 '
 'draw title 'tm1'-'tm2' hours forecast'
 'run cbar.gs'
 step=step+2
endwhile

 'set vpage 0.0 11.0 0.3 8.5'
 'draw title Initial time:YMDH precip. amount = 10 mm / 24 hours'
 'set vpage 0.0 11.0 0.0 8.1'
 'draw title Ensemble based probability of precip. amount exceeding'
 'print'
 'disable print gmeta_MNS2'
 'printim gmeta_MNS2.png png x695 y545 white'
