ts=00z01sep99
te=00z23sep99
var1=ac1

'open prs_15d.ctl'
'open prx_15d.ctl'

ymin=0.0
ymax=1.0
bmax=0.2

'set display color white'
'clear'
*
* NH 500 mb Z
*
grfile='/nfstmp/wx20yz/grads/nh500_6days.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 2 8.5'

'set x 7'
'set y 4'
'set z 3'

'set t 1'
'define tcnt=ave('var1'.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prsnh500=digs(word,3)
'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prxnh500=digs(word,3)

ymin=0.0
ymax=1.0
bmax=0.2

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd ac1.1'
'set ccolor 2'
'd ac1.2'
'draw title NH 500 mb Geopotential Height at day 6'
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.12'
'set string 1 tl 6'
'draw string 2.5 7.2 PRS='prsnh500
'set string 2 tl 6'
'draw string 2.5 6.8 PRX='prxnh500

'set vpage 0 11 0 3'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmax' 'bmax
'set gxout bar'
'set time 'ts' 'te
'set ccolor 2'
'set cmark  2'
'set cstyle 1'
'set cthick 4'
'd ac1.1 - ac1.2'
'draw ylab PRS-PRX'
*
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

*
* SH 500 mb Z
*
grfile='/nfstmp/wx20yz/grads/sh500_6days.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 2 8.5'

'set x 7'
'set y 4'
'set z 3'

'set t 1'
'define tcnt=ave(ac2.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prsnh500=digs(word,3)
'define tcnt=ave(ac2.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prxnh500=digs(word,3)

ymin=0.0
ymax=1.0
bmax=0.2

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd ac2.1'
'set ccolor 2'
'd ac2.2'
'draw title SH 500 mb Geopotential Height at day 6'
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.12'
'set string 1 tl 6'
'draw string 2.5 7.2 PRS='prsnh500
'set string 2 tl 6'
'draw string 2.5 6.8 PRX='prxnh500

'set vpage 0 11 0 3'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmax' 'bmax
'set gxout bar'
'set time 'ts' 'te
'set ccolor 2'
'set cmark  2'
'set cstyle 1'
'set cthick 4'
'd ac2.1 - ac2.2'
'draw ylab PRS-PRX'
*
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit
*
* NH 500 mb Z
*
grfile='/nfstmp/wx20yz/grads/nh500_7days.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 2 8.5'

'set x 8'
'set y 4'
'set z 3'

'set t 1'
'define tcnt=ave('var1'.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prsnh500=digs(word,3)
'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prxnh500=digs(word,3)

ymin=0.0
ymax=1.0
bmax=0.2

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd ac1.1'
'set ccolor 2'
'd ac1.2'
'draw title NH 500 mb Geopotential Height at day 7'
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.12'
'set string 1 tl 6'
'draw string 2.5 7.2 PRS='prsnh500
'set string 2 tl 6'
'draw string 2.5 6.8 PRX='prxnh500

'set vpage 0 11 0 3'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmax' 'bmax
'set gxout bar'
'set time 'ts' 'te
'set ccolor 2'
'set cmark  2'
'set cstyle 1'
'set cthick 4'
'd ac1.1 - ac1.2'
'draw ylab PRS-PRX'
*
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

*
* SH 500 mb Z
*
grfile='/nfstmp/wx20yz/grads/sh500_7days.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 2 8.5'

'set x 8'
'set y 4'
'set z 3'

'set t 1'
'define tcnt=ave(ac2.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prsnh500=digs(word,3)
'define tcnt=ave(ac2.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prxnh500=digs(word,3)

ymin=0.0
ymax=1.0
bmax=0.2

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd ac2.1'
'set ccolor 2'
'd ac2.2'
'draw title SH 500 mb Geopotential Height at day 7'
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.12'
'set string 1 tl 6'
'draw string 2.5 7.2 PRS='prsnh500
'set string 2 tl 6'
'draw string 2.5 6.8 PRX='prxnh500

'set vpage 0 11 0 3'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmax' 'bmax
'set gxout bar'
'set time 'ts' 'te
'set ccolor 2'
'set cmark  2'
'set cstyle 1'
'set cthick 4'
'd ac2.1 - ac2.2'
'draw ylab PRS-PRX'
*
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

function digs(string,num)
  nc=0
  pt=""
  while(pt = "")
    nc=nc+1
    zzz=substr(string,nc,1)
    if(zzz = "."); break; endif
  endwhile
  end=nc+num
  str=substr(string,1,end)
return str

