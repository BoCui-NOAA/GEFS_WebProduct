
'open grads.ctl'

'set display color white'
'clear'
 
'enable print gmeta' 
'set grads off'

'set t 1 200'
'set y 1'
'set z 1'
'set vrange 0.0 0.07'
'set x 1'
'set ccolor 1'
'set cmark  1'
'd xxx'
'set x 2'
'set ccolor 2'
'set cmark  2'
'd xxx'
'set x 3'
'set ccolor 3'
'set cmark  3'
'd xxx'

'draw title DECAYING AVERAGE WEIGHTING'

'draw ylab Normalized Values'

'run /global/save/wx20yz/grads/linesmpos.gs leg_lines 2.5 5.5 4.5 7.0'

'print'
