ts=CSTYMD           
te=CEDYMD       

'open /ptmp/wx20yz/qgrads/prEXPID1.ctl'
'open /ptmp/wx20yz/qgrads/prEXPID2.ctl'

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
grfile='/ptmp/wx20yz/qgrads/'oname'_850hPa.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.6 11 4.0 8.5'
var1='ac'icnt
ymin=0.8
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
qday10=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday20=digs(word,3)

'set x 2'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday11=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday21=digs(word,3)

'set x 3'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday12=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday22=digs(word,3)

'set x 4'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday13=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday23=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax

'set x 1'
'set cstyle 1'
'set ccolor 1'
'd 'var1
'set cstyle 5'
'set ccolor 1'
'd 'var1'.2'

'set x 2'
'set cstyle 1'
'set ccolor 2'
'd 'var1
'set cstyle 5'
'set ccolor 2'
'd 'var1'.2'

'set x 3'
'set cstyle 1'
'set ccolor 3'
'd 'var1
'set cstyle 5'
'set ccolor 3'
'd 'var1'.2'

'set x 4'
'set cstyle 1'
'set ccolor 4'
'd 'var1
'set cstyle 5'
'set ccolor 4'
'd 'var1'.2'

'draw title 'oname' 850 hPa Specific Humidity Correlation Scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 7.6 cdas='qday10
'set string 1 tl 4'
'draw string 0.2 7.2 gdas='qday20  
'set string 2 tl 4'
'draw string 0.2 6.8 1dEXPID1='qday11  
'set string 2 tl 4'
'draw string 0.2 6.4 1dEXPID2='qday21  
'set string 3 tl 4'
'draw string 0.2 6.0 2dEXPID1='qday12  
'set string 3 tl 4'
'draw string 0.2 5.6 2dEXPID2='qday22  
'set string 4 tl 4'
'draw string 0.2 5.2 3dEXPID1='qday13  
'set string 4 tl 4'
'draw string 0.2 4.8 3dEXPID2='qday23  

'set vpage 0.6 11 0.0 4.5'
var1='rm'icnt
ymin=0.4
ymax=1.6

'set lev 850'
'set y 1'

'set t 1'
'set x 1'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday10=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday20=digs(word,3)

'set x 2'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday11=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday21=digs(word,3)

'set x 3'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday12=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday22=digs(word,3)

'set x 4'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday13=digs(word,3)

'define tcnt=ave('var1'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
qday23=digs(word,3)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set x 1'
'set cstyle 1'
'set ccolor 1'
'd 'var1
'set cstyle 5'
'set ccolor 1'
'd 'var1'.2'

'set x 2'
'set cstyle 1'
'set ccolor 2'
'd 'var1
'set cstyle 5'
'set ccolor 2'
'd 'var1'.2'

'set x 3'
'set cstyle 1'
'set ccolor 3'
'd 'var1
'set cstyle 5'
'set ccolor 3'
'd 'var1'.2'

'set x 4'
'set cstyle 1'
'set ccolor 4'
'd 'var1
'set cstyle 5'
'set ccolor 4'
'd 'var1'.2'

'draw title 'oname' 850 hPa Specific Humidity RMS errors'

'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 0.2 3.8 cdas='qday10
'set string 1 tl 4'
'draw string 0.2 3.4 gdas='qday20   
'set string 2 tl 4'
'draw string 0.2 3.0 1dEXPID1='qday11   
'set string 2 tl 4'
'draw string 0.2 2.6 1dEXPID2='qday21  
'set string 3 tl 4'
'draw string 0.2 2.2 2dEXPID1='qday12  
'set string 3 tl 4'
'draw string 0.2 1.8 2dEXPID2='qday22  
'set string 4 tl 4'
'draw string 0.2 1.4 3dEXPID1='qday13  
'set string 4 tl 4'
'draw string 0.2 1.0 3dEXPID2='qday23  

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

*
*  for vertical plot
*  =================
*

grfile='/ptmp/wx20yz/qgrads/'oname'_vertical.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 5.8 11.0 0 8.5'
var1='rm'icnt
xmin=-0.4
xmax=1.6 
'set vrange 'xmin' 'xmax
*'set vrange2 'xmin' 'xmax
'set grads off'

'set y 1'
'set z 1 8'

'set t 1'
'set x 1'
'define tx10=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tx20=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 2'
'define tx11=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tx21=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 3'
'define tx12=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tx22=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 4'
'define tx13=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tx23=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 2'
'set z 1 8'

'set t 1'
'set x 1'
'define ty10=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define ty20=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 2'
'define ty11=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define ty21=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 3'
'define ty12=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define ty22=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 4'
'define ty13=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define ty23=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set ccolor 1'
'set cstyle 1'
'd tx10'
'set ccolor 1'
'set cstyle 5'
'd tx20'

'set ccolor 2'
'set cstyle 1'
'd tx11'
'set ccolor 2'
'set cstyle 5'
'd tx21'

'set ccolor 3'
'set cstyle 1'
'd tx12'
'set ccolor 3'
'set cstyle 5'
'd tx22'

'set ccolor 4'
'set cstyle 1'
'd tx13'
'set ccolor 4'
'set cstyle 5'
'd tx23'


'set ccolor 1'
'set cstyle 1'
'd ty10'
'set ccolor 1'
'set cstyle 5'
'd ty20'

'set ccolor 2'
'set cstyle 1'
'd ty11'
'set ccolor 2'
'set cstyle 5'
'd ty21'

'set ccolor 3'
'set cstyle 1'
'd ty12'
'set ccolor 3'
'set cstyle 5'
'd ty22'

'set ccolor 4'
'set cstyle 1'
'd ty13'
'set ccolor 4'
'set cstyle 5'
'd ty23'

'draw xlab RMS errors '

'set vpage 0.0 5.2 0 8.5'
xmin=0.7
xmax=1.0
var1='ac'icnt
'set vrange 'xmin' 'xmax
*'set vrange2 'xmin' 'xmax
'set grads off'
'set t 1'
'set y 4'
'set x 1'

'define tz10=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tz20=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 2'
'define tz11=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tz21=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 3'
'define tz12=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tz22=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set x 4'
'define tz13=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tz23=ave('var1'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set ccolor 1'
'set cstyle 1'
'd tz10'
'set ccolor 1'
'set cstyle 5'
'd tz20'

'set ccolor 2'
'set cstyle 1'
'd tz11'
'set ccolor 2'
'set cstyle 5'
'd tz21'

'set ccolor 3'
'set cstyle 1'
'd tz12'
'set ccolor 3'
'set cstyle 5'
'd tz22'

'set ccolor 4'
'set cstyle 1'
'd tz13'
'set ccolor 4'
'set cstyle 5'
'd tz23'

'draw xlab Correlation scores'
*

'set vpage 0 11 0 8.5'
'set string 4 c 4'
'set strsiz 0.20'
'draw string 5.5 8.2 Specific Humidity Verification ('ts' - 'te')'
'set vpage 0 11 0 8.5'
'set strsiz 0.16'
'set string 1 tl 4'
'draw string 5.0 6.2 GDAS-CDAS'
'set string 1 tl 4'
'draw string 5.0 5.8 GDAS-F00'
'set string 2 tl 4'
'draw string 5.0 5.4 1-day-EXPID1'   
'set string 2 tl 4'
'draw string 5.0 5.0 1-day-EXPID2'   
'set string 3 tl 4'
'draw string 5.0 4.6 2-day-EXPID1'   
'set string 3 tl 4'
'draw string 5.0 4.2 2-day-EXPID2'  
'set string 4 tl 4'
'draw string 5.0 3.8 3-day-EXPID1'   
'set string 4 tl 4'
'draw string 5.0 3.4 3-day-EXPID2'  

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit


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

