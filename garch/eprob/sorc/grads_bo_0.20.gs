
'open grads_bo_0.20.ctl'

'set display color white'
'clear'
 
'enable print gmeta' 
'set grads off'
'set xlab off'

'set t 180 200'
'set y 1'
'set z 1'
'set vrange 0.0 0.5'
'set x 1'
'set cmark 0'
'set cthick 10'
'set cstyle 2'
'set ccolor 1'
*'set cmark  1'
'd xxx'
'set x 2'
'set cthick 10'
'set cstyle 1'
'set ccolor 2'
'set cmark  0'
'd xxx'
'set x 3'
'set cthick 10'
'set cstyle 7'
'set ccolor 3'
'set cmark  0'
'd xxx'

'draw title DECAYING AVERAGE WEIGHTING'

'draw ylab Normalized Values'
'draw xlab Days'

'set strsiz 0.10' 
'draw string 1.84 0.58 -20'
'draw string 2.70 0.58 -18'
'draw string 3.56 0.58 -16'
'draw string 4.42 0.58 -14'
'draw string 5.28 0.58 -12'
'draw string 6.14 0.58 -10'
'draw string 7.00 0.58 -8'
'draw string 7.86 0.58 -6'
'draw string 8.72 0.58 -4'
'draw string 9.58 0.58 -2'
'draw string 10.44 0.58 0'
*'draw string 1.84 0.55 -80'
*'draw string 2.70 0.55 -72'
*'draw string 3.56 0.55 -63'
*'draw string 4.42 0.55 -56'
*'draw string 5.28 0.55 -48'
*'draw string 6.14 0.55 -40'
*'draw string 7.00 0.55 -32'
*'draw string 7.86 0.55 -24'
*'draw string 8.74 0.55 -16'
*'draw string 9.58 0.55 -8'
*'draw string 10.44 0.55 0'

'run /global/save/wx20yz/grads/linesmpos.gs leg_lines_bo_0.20 2.5 5.5 4.5 7.0'

'print'
