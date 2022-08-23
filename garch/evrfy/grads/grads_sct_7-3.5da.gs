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
'set t 1'

var1='rm1'
var2='rm2'
var3='rm14'
var4='rm15'

*'d ave('var1',time='ts',time='te')'
*'d ave('var2',time='ts',time='te')'

istday=2
iedday=15
istd=istday

while (istd<=iedday)

*'set x 8'
'set x 'istd
'define aaa=ave('var1',time='ts',time='te')'
'd aaa'
say result
line=sublin(result,1)
word=subwrd(line,4)

'define bbb=ave('var2',time='ts',time='te')'
'd bbb'
say result
line=sublin(result,1)
word=subwrd(line,4)

*'set ccolor 1'
*'set cmark 1'
*'d aaa;bbb'

*'define ccc=ave('var3',time='ts',time='te')'
*'d ccc'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)

*'define ddd=ave('var4',time='ts',time='te')'
*'d ddd'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)


*'set x 15'
*'define aaa=ave('var1',time='ts',time='te')'
*'d aaa'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)

*'define bbb=ave('var2',time='ts',time='te')'
*'d bbb'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)

*'define ccc=ave('var3',time='ts',time='te')'
*'d ccc'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)

*'define ddd=ave('var4',time='ts',time='te')'
*'d ddd'
*say result
*line=sublin(result,1)
*word=subwrd(line,4)

*'print'
*'disable print'
*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

istd=istd+1
endwhile
'quit'


