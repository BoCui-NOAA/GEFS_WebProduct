
'open test.ctl'

'run rgbset.gs'
'set display color white'
'clear'
'set gxout shaded'
'set grads off'

*'set e 1'
*'define e1 = const(const(maskout(tmp2m,tmp2m-97.7),1),0,-u)'
'define e1 = sum(const(const(maskout(tmp2m,tmp2m-97.7),1),0,-u),e=1,e=3)'

'set e 2'
*'define e2 = const(const(maskout(tmp2m,tmp2m-97.7),1),0,-u)'

'set e 3'
*'define e3 = const(const(maskout(tmp2m,tmp2m-97.7),1),0,-u)'

*'set e 4'
*'define e4 = const(maskout(tmp2m,tmp2m-84.0),1)'
*
*'set e 5'
*'define e5 = const(maskout(tmp2m,tmp2m-84.0),1)'
*
*'set e 6'
*'define e6 = const(maskout(tmp2m,tmp2m-84.0),1)'
*
*'set e 7'
*'define e7 = const(maskout(tmp2m,tmp2m-84.0),1)'
*
*'set e 8'
*'define e8 = const(maskout(tmp2m,tmp2m-84.0),1)'
*
*'set e 9'
*'define e9 = const(maskout(tmp2m,tmp2m-84.0),1)'
*
*'set e 10'
*'define e10 = const(maskout(tmp2m,tmp2m-84.0),1)'

*'d maskout(e1+e2+e3,e1+e2+e3-2)'
'd maskout(e1,e1-2)'

'cbar'
