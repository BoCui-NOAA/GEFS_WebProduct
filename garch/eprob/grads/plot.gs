
'open grads.ctl'
'open grads_br.ctl'

istday=1
iedday=15

while (istday <= iedday)

iday=istday

'clear'
'set vpage 0.0 11.0 0.0 8.5'
'enable print gmeta'iday''
'xyplot plot'iday''
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_lines 6.5 1.5 8.5 2.5'
'set vpage 1.7 4.7 5.5 8.0'
'set grads off'
'set xlab off'
'set t 'iday''
'set vrange 0.0 80000.'
'set gxout bar'
'set bargap 20'
'set ccolor 2'
'd xxx.1'
'set bargap 60'
'set ccolor 3'
'd xxx.2'
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

istday=istday+1

endwhile

