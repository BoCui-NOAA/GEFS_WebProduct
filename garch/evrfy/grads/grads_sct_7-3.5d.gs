ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'

'set display color white'
'clear'
grfile='/ptmp/wx20yz/grads/500h_egrate_3.5-7d_sct.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.1 9.5 0.0 8.5'
'set grads off'
'set vrange 0.0 100.0'
'set vrange2 0.0 100.0'
'set gxout scatter'
'set y 1'
'set z 1'
'set t 1 TDAYS'
'set x 8'
'set ccolor 1'
'set cmark 1'
'd rm1(x=15)-rm1;rm2(x=15)-rm2'

'set ccolor 2'
'set cmark 2'
'd rm14(x=15)-rm14;rm15(x=15)-rm15'

'draw xlab MRF'
'draw ylab CTL'
'draw line 2.0 1.0 7.9 7.5'
'draw title 500mb Height Error Growth from 3.5 days to 7 days \ Period of CSTYMD-CEDYMD'
'run /nfsuser/g01/wx20yz/grads/linesm.gs leg_l2 2.2 6.4 3.2 7.2'
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit
