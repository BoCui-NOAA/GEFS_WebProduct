
'set mproj latlon'
*'set lon 90 150'  
*'set lat -15 15'
'set lon 160 230'  
'set lat 0 50'
'set gxout shaded'
*
'set display color white'
'clear'

'enable print gmeta_HWI1'
step=4
stepend=11
while (step<=stepend)

'set t 'step''   

 if (step=4)
 'set vpage 0.4 5.5 3.9 7.5'
 times='12-36'
 endif
 if (step=6)
 'set vpage 5.5 10.4 3.9 7.5' 
 times='36-60'
 endif
 if (step=8)
 'set vpage 0.4 5.5 0.4 4.0'
 times='60-84'
 endif
 if (step=10)
 'set vpage 5.5 10.4 0.4 4.0'
 times='84-108'
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
 'draw title 'times' hours forecast' 
 'run cbar.gs'
 step=step+2
endwhile

 'set vpage 0.0 11.0 0.3 8.5'
 'draw title Initial time:YMDH precip. amount = 10.0 mm/day'
 'set vpage 0.0 11.0 0.0 8.1'
 'draw title Ensemble based probability of precip. amount exceeding'
 'print'
 'disable print gmeta_HWI1'
 'printim gmeta_HWI1.png png x695 y545 white'
 'c'

'enable print gmeta_HWI2'
step=12
stepend=19
while (step<=stepend)

'set t 'step''

 if (step=12)
 'set vpage 0.4 5.5 3.9 7.5'
 times='108-132'
 endif
 if (step=14)
 'set vpage 5.5 10.4 3.9 7.5'
 times='132-156'
 endif
 if (step=16)
 'set vpage 0.4 5.5 0.4 4.0'
 times='156-180'
 endif
 if (step=18)
 'set vpage 5.5 10.4 0.4 4.0'
 times='180-204'
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
 'draw title 'times' hours forecast'
 'run cbar.gs'
 step=step+2
endwhile

 'set vpage 0.0 11.0 0.3 8.5'
 'draw title Initial time:YMDH precip. amount = 10.0 mm/day'
 'set vpage 0.0 11.0 0.0 8.1'
 'draw title Ensemble based probability of precip. amount exceeding'
 'print'
 'disable print gmeta_HWI2'
 'printim gmeta_HWI2.png png x695 y545 white'
