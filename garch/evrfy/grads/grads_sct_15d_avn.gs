ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'

'set display color white'
'clear'
grfile='/ptmp/wx20yz/grads/nh500h_ac_sct.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.1 9.5 0.0 8.5'
'set grads off'
'set vrange -0.3 1.0'
'set vrange2 -0.3 1.0'
'set gxout scatter'
'set y 4'
'set z 1'
'set t 1 31'
'set x 1 7'
'set ccolor 1'
'set cmark 1'
'd ac1;ac2'
'set x 8 17'
'set ccolor 2'
'set cmark 2'
'd ac1;ac2'
'set x 18 31'
'set ccolor 3'
'set cmark 3'
'd ac1;ac2'
'draw xlab MRF'
'draw ylab CTL'
'draw line 2.0 1.0 7.9 7.5'
'draw title AC Scores for NH, Winter of 2000-2001'
'run /nfsuser/g01/wx20yz/grads/linesm.gs leg_l1 2.1 5.8 3.6 7.0'

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

'set display color white'
'clear'
grfile='/ptmp/wx20yz/grads/sh500h_ac_sct.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.1 9.5 0.0 8.5'
'set grads off'
'set vrange -0.3 1.0'
'set vrange2 -0.3 1.0'
'set gxout scatter'
'set y 4'
'set z 1'
'set t 1 90'
'set x 1 11'
'set ccolor 1'
'set cmark 1'
'd ac14;ac17'
'set x 12 21'
'set ccolor 2'
'set cmark 2'
'd ac14;ac17'
'set x 22 31'
'set ccolor 3'
'set cmark 3'
'd ac14;ac17'
'draw xlab MRF'
'draw ylab AVN'
'draw line 2.0 1.0 7.9 7.5'
'draw title AC Scores for SH, Winter of 2000-2001'

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit


