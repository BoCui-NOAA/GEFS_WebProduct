
'set mproj latlon'
'set lon -30 80'  
'set lat -40 40'
'set gxout shaded'
*
'set display color white'
'clear'

'enable print gmeta_SAF1'
step=4
stepend=11
while (step<=stepend)

'set t 'step''   

 if (step=4)
 'set vpage 0.5 5.5 3.8 7.6'
 times='12-36'
 endif
 if (step=6)
 'set vpage 5.5 10.5 3.8 7.6' 
 times='36-60'
 endif
 if (step=8)
 'set vpage 0.5 5.5 0.1 3.9'
 times='60-84'
 endif
 if (step=10)
 'set vpage 5.5 10.5 0.1 3.9'
 times='84-108'
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs    5 15 25 35 45 55 65 75 85 95'
 'set ccols  26 25 24 23 22 21 31 33 35 37 39'
*'set ccols  29 27 26 24 23 21 31 33 35 37 39 0'
 'd pp8'    
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   5 35 65 95'          
 'd pp8 '   
 'draw title 'times' hours forecast' 
 'run cbar.gs'
 step=step+2
endwhile

 'set vpage 0.0 11.0 0.3 8.5'
 'draw title Initial time:YMDH precip. amount = 5 mm/day'
 'set vpage 0.0 11.0 0.0 8.1'
 'draw title Ensemble based probability of precip. amount exceeding'
 'print'
 'disable print gmeta_SAF1'
 'printim gmeta_SAF1.png png x695 y545 white'
 'c'

'enable print gmeta_SAF2'
step=12
stepend=19
while (step<=stepend)

'set t 'step''

 if (step=12)
 'set vpage 0.5 5.5 3.8 7.6'
 times='108-132'
 endif
 if (step=14)
 'set vpage 5.5 10.5 3.8 7.6'
 times='132-156'
 endif
 if (step=16)
 'set vpage 0.5 5.5 0.1 3.9'
 times='156-180'
 endif
 if (step=18)
 'set vpage 5.5 10.5 0.1 3.9'
 times='180-204'
 endif

 'set grads off'
 'set gxout shaded'
 'set clevs    5 15 25 35 45 55 65 75 85 95'
 'set ccols  26 25 24 23 22 21 31 33 35 37 39'
*'set ccols  29 27 26 24 23 21 31 33 35 37 39 0'
 'd pp8'
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
 'set clevs   5 35 65 95'
 'd pp8 '
 'draw title 'times' hours forecast'
 'run cbar.gs'
 step=step+2
endwhile

 'set vpage 0.0 11.0 0.3 8.5'
 'draw title Initial time:YMDH precip. amount = 5 mm/day'
 'set vpage 0.0 11.0 0.0 8.1'
 'draw title Ensemble based probability of precip. amount exceeding'
 'print'
 'disable print gmeta_SAF2'
 'printim gmeta_SAF2.png png x695 y545 white'
