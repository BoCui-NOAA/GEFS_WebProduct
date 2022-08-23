ts=CSTYMD           
te=CEDYMD       

'open /ptmp/wx20yz/cgrads/prEXPID1.ctl'
'open /ptmp/wx20yz/cgrads/prEXPID2.ctl'
'open /ptmp/wx20yz/cgrads/prEXPID3.ctl'
'open /ptmp/wx20yz/cgrads/prEXPID4.ctl'

icnt=1

while (icnt<=2)

 if (icnt=1) 
  oname='nh'
  tname='NH'
 endif
 if (icnt=2)
  oname='sh'
  tname='SH'
 endif
 if (icnt=3)
  oname='tr'
  tname='TROP'
 endif

'set display color white'
'clear'
*
* NH & SH 500 hPa H
*
grfile='/ptmp/wx20yz/cgrads/z'oname'_500hPa.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.6 11 4.0 8.5'
var1='ac'icnt
ymin=0.98
ymax=1.0

'set lev 500'
'set y 4'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
kday0=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
eday0=digs(word,3)

'define tcnt=ave('var1'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
mday0=digs(word,3)

'define tcnt=ave('var1'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
nday0=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set ccolor 2'
'd 'var1'.2'
'set ccolor 3'
'd 'var1'.3'
'set ccolor 4'
'd 'var1'.4'
'draw title 'tname' 500 hPa Height Analysis Anomally Correlation Scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 7.6 UKM='kday0
'set string 2 tl 4'
'draw string 0.2 7.2 ECM='eday0   
'set string 3 tl 4'
'draw string 0.2 6.8 CMC='mday0   
'set string 4 tl 4'
'draw string 0.2 6.4 FNO='nday0   

'set vpage 0.6 11 0.0 4.5'
var1='rm'icnt
ymin=4.0
ymax=16.

'set lev 500'
'set y 1'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
kday0=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
eday0=digs(word,3)

'define tcnt=ave('var1'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
mday0=digs(word,3)

'define tcnt=ave('var1'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
nday0=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set ccolor 2'
'd 'var1'.2'
'set ccolor 3'
'd 'var1'.3'
'set ccolor 4'
'd 'var1'.4'
'draw title 'tname' 500 hPa Height Analysis RMS errors'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 3.8 UKM='kday0
'set string 2 tl 4'
'draw string 0.2 3.4 ECM='eday0   
'set string 3 tl 4'
'draw string 0.2 3.0 CMC='mday0   
'set string 4 tl 4'
'draw string 0.2 2.6 FNO='nday0   

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

icnt=icnt+1

endwhile

'set display color white'
'clear'
*
* TROP 200 hPa wind vector
*
oname='tr'
tname='TROP'
icnt=15
grfile='/ptmp/wx20yz/cgrads/r'oname'_200hPa.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.6 11 4.0 8.5'
var1='ac'icnt
ymin=0.90
ymax=1.0

'set lev 200'
'set y 4'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
kday0=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
eday0=digs(word,3)

'define tcnt=ave('var1'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
mday0=digs(word,3)

'define tcnt=ave('var1'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
nday0=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set ccolor 2'
'd 'var1'.2'
'set ccolor 3'
'd 'var1'.3'
'set ccolor 4'
'd 'var1'.4'
'draw title 'tname' 200 hPa Wind Vector Analysis AC Scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 7.6 UKM='kday0
'set string 2 tl 4'
'draw string 0.2 7.2 ECM='eday0
'set string 3 tl 4'
'draw string 0.2 6.8 CMC='mday0
'set string 4 tl 4'
'draw string 0.2 6.4 FNO='nday0

'set vpage 0.6 11 0.0 4.5'
var1='rm'icnt
ymin=2.0
ymax=8.

'set lev 200'
'set y 1'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
kday0=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
eday0=digs(word,3)

'define tcnt=ave('var1'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
mday0=digs(word,3)

'define tcnt=ave('var1'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
nday0=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set ccolor 2'
'd 'var1'.2'
'set ccolor 3'
'd 'var1'.3'
'set ccolor 4'
'd 'var1'.4'
'draw title 'tname' 200 hPa Wind Vector Analysis RMS errors'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 3.8 UKM='kday0
'set string 2 tl 4'
'draw string 0.2 3.4 ECM='eday0
'set string 3 tl 4'
'draw string 0.2 3.0 CMC='mday0
'set string 4 tl 4'
'draw string 0.2 2.6 FNO='nday0

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

'set display color white'
'clear'
*
* TROP 850 Wind Vector
*
grfile='/ptmp/wx20yz/cgrads/r'oname'_850hPa.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.6 11 4.0 8.5'
var1='ac'icnt
ymin=0.80
ymax=1.0

'set lev 850'
'set y 4'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
kday0=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
eday0=digs(word,3)

'define tcnt=ave('var1'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
mday0=digs(word,3)

'define tcnt=ave('var1'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
nday0=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set ccolor 2'
'd 'var1'.2'
'set ccolor 3'
'd 'var1'.3'
'set ccolor 4'
'd 'var1'.4'
'draw title 'tname' 850 hPa Wind Vector Analysis AC Scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 7.6 UKM='kday0
'set string 2 tl 4'
'draw string 0.2 7.2 ECM='eday0
'set string 3 tl 4'
'draw string 0.2 6.8 CMC='mday0
'set string 4 tl 4'
'draw string 0.2 6.4 FNO='nday0

'set vpage 0.6 11 0.0 4.5'
var1='rm'icnt
ymin=1.0
ymax=4.

'set lev 850'
'set y 1'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
kday0=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
eday0=digs(word,3)

'define tcnt=ave('var1'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
mday0=digs(word,3)

'define tcnt=ave('var1'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
nday0=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set ccolor 2'
'd 'var1'.2'
'set ccolor 3'
'd 'var1'.3'
'set ccolor 4'
'd 'var1'.4'
'draw title 'tname' 850 hPa Wind Vector Analysis RMS errors'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 3.8 UKM='kday0
'set string 2 tl 4'
'draw string 0.2 3.4 ECM='eday0
'set string 3 tl 4'
'draw string 0.2 3.0 CMC='mday0
'set string 4 tl 4'
'draw string 0.2 2.6 FNO='nday0

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

'quit'

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

