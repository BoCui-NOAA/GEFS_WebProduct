ts=CSTYMD           
te=CEDYMD       

'open $GDIR/prEXPID1.ctl'

icnt=1

while (icnt<=3)

 if (icnt=1) 
  oname='nh'
 endif
 if (icnt=2)
  oname='sh'
 endif
 if (icnt=3)
  oname='tr'
 endif

'set display color white'
'clear'
*
* NH 850 hPa Q
*
grfile='$GDIR/'oname'_850hPa.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.6 11 4.0 8.5'
var1='ac'icnt
ymin=0.5
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
qday0=digs(word,3)

'set x 2'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday1=digs(word,3)

'set x 3'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday2=digs(word,3)

'set x 4'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday3=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set x 2'
'set ccolor 2'
'd 'var1
'set x 3'
'set ccolor 3'
'd 'var1
'set x 4'
'set ccolor 4'
'd 'var1
'draw title 850 hPa Specific Humidity Correlation Scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 7.6 gdas='qday0
'set string 2 tl 4'
'draw string 0.2 7.2 1day='qday1   
'set string 3 tl 4'
'draw string 0.2 6.8 2day='qday2   
'set string 4 tl 4'
'draw string 0.2 6.4 3day='qday3   

'set vpage 0.6 11 0.0 4.5'
var1='rm'icnt
ymin=0.0
ymax=3.0

'set lev 850'
'set y 1'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday0=digs(word,3)

'set x 2'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday1=digs(word,3)

'set x 3'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday2=digs(word,3)

'set x 4'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday3=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set ccolor 1'
'd 'var1
'set x 2'
'set ccolor 2'
'd 'var1
'set x 3'
'set ccolor 3'
'd 'var1
'set x 4'
'set ccolor 4'
'd 'var1
'draw title 850 hPa Specific Humidity RMS errors'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 3.8 gdas='qday0
'set string 2 tl 4'
'draw string 0.2 3.4 1day='qday1   
'set string 3 tl 4'
'draw string 0.2 3.0 2day='qday2   
'set string 4 tl 4'
'draw string 0.2 2.6 3day='qday3   

'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

*
*  for vertical plot
*  =================
*

grfile='$GDIR/'oname'_vertical.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 5.8 11.0 0 8.5'
var1='rm'icnt
xmin=-1.0
xmax=2.5 
'set vrange 'xmin' 'xmax
*'set vrange2 'xmin' 'xmax
'set grads off'

'set y 1'
'set z 1 8'

'set t 1'
'set x 1'
'define tx1=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 2'
'define tx2=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 3'
'define tx3=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 4'
'define tx4=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 2'
'set z 1 8'

'set t 1'
'set x 1'
'define ty1=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 2'
'define ty2=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 3'
'define ty3=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 4'
'define ty4=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set ccolor 1'
'set cstyle 1'
'd tx1'
'set ccolor 2'
'd tx2'
'set ccolor 3'
'd tx3'
'set ccolor 4'
'd tx4'

'set ccolor 1'
'set cstyle 2'
'd ty1'
'set ccolor 2'
'd ty2'
'set ccolor 3'
'd ty3'
'set ccolor 4'
'd ty4'
'draw xlab RMS errors (dash-bias)'

'set vpage 0.0 5.2 0 8.5'
xmin=0.5
xmax=1.05
var1='ac'icnt
'set vrange 'xmin' 'xmax
*'set vrange2 'xmin' 'xmax
'set grads off'
'set t 1'
'set y 4'
'set x 1'
'define tx1=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 2'
'define tx2=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 3'
'define tx3=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set x 4'
'define tx4=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set ccolor 4'
'set cstyle 1'
'd tx4'
'set ccolor 1'
'd tx1'
'set ccolor 2'
'd tx2'
'set ccolor 3'
'd tx3'
'draw xlab Correlation scores'
*

'set vpage 0 11 0 8.5'
'set string 4 c 4'
'set strsiz 0.20'
'draw string 5.5 8.2 Specific Humidity Verification ('ts' - 'te')'
'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 5.0 6.2 UKM-GDAS'
'set string 2 tl 4'
'draw string 5.0 5.8 1-day'   
'set string 3 tl 4'
'draw string 5.0 5.4 2-day'   
'set string 4 tl 4'
'draw string 5.0 5.0 3-day'   

'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit


icnt=icnt+1

endwhile

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

