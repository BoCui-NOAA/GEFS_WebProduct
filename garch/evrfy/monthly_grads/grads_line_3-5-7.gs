ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'

'set display color white'
'clear'
*
* NH & SH 500 mb geopotential height (Z)
*
regs=1
rege=2

reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

if (reg=1) 
var1='ac1'
var2='ac2'
var3='ac7'
var4='ac8'
endif
if (reg=2) 
var1='ac14'
var2='ac15'
var3='ac20'
var4='ac21'
endif

grfile=''greg'500h_'istday'days_ac.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.5'

'set x 'iday
'set y 4'
'set z 1'

'set t 1'
'set x 11' 
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pranh500=digs(word,3)
'define tcnt=ave('var2',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prbnh500=digs(word,3)
'define tcnt=ave('var3',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prcnh500=digs(word,3)

ymin=getmin(istday)
ymax=getmax(istday)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd 'var1''
'set ccolor 2'
'd 'var2''
'set ccolor 3'
'd 'var3''
'draw title 'titreg' 500 mb Geopotential Height at day 'istday' \ for 'ts' - 'te' '
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.12'
'set string 1 tl 6'
'draw string 9.0 1.7 MRF='pranh500
'set string 2 tl 6'
'draw string 9.0 1.5 CTL='prbnh500
'set string 3 tl 6'
'draw string 9.0 1.3 ENS='prcnh500

*
'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

grfile=''greg'500h_'istday'days_ac.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.5'

'set x 'iday
'set y 4'
'set z 1'

'set t 1'
'set x 7'
'define tcnt=ave('var3',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pranh500=digs(word,3)
'set x 11'
'define tcnt=ave('var3',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prbnh500=digs(word,3)
'set x 17'
'define tcnt=ave('var3',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prcnh500=digs(word,3)
'set x 11'
'define tcnt=ave('var1',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prdnh500=digs(word,3)

ymin=getmin(istday)
ymax=getmax(istday)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd 'var1''
'set ccolor 2'
'd 'var2''
'set ccolor 3'
'd 'var3''
'draw title 'titreg' 500 mb Geopotential Height at day 'istday' \ for 'ts' - 'te
' '
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.12'
'set string 1 tl 6'
'draw string 9.0 1.7 MRF='pranh500
'set string 2 tl 6'
'draw string 9.0 1.5 CTL='prbnh500
'set string 3 tl 6'
'draw string 9.0 1.3 ENS='prcnh500

*
'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

reg=reg+1
endwhile

'quit'

*
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
function getreg(reg)
if(reg=1);titreg='NH';endif;
if(reg=2);titreg='SH';endif;
if(reg=3);titreg='TROPICS';endif;
if(reg=4);titreg='North America';endif;
return titreg
function getgreg(reg)
if(reg=1);greg='nh';endif;
if(reg=2);greg='sh';endif;
if(reg=3);greg='tr';endif;
if(reg=4);greg='na';endif;
return greg
function getnam(fld)
if(fld=6);greg='U-wind';endif;
if(fld=9);greg='V-wind';endif;
if(fld=12);greg='Speed';endif;
if(fld=15);greg='Vector';endif;
return greg
function getfnam(fld)
if(fld=6);greg='u';endif;
if(fld=9);greg='v';endif;
if(fld=12);greg='s';endif;
if(fld=15);greg='r';endif;
return greg
function getmax(iday)
if(iday=1);ymax=1.3;endif;
if(iday=2);ymax=1.2;endif;
if(iday=3);ymax=1.1;endif;
if(iday=4);ymax=1.0;endif;
if(iday=5);ymax=1.0;endif;
if(iday=6);ymax=1.0;endif;
if(iday=7);ymax=1.0;endif;
if(iday=8);ymax=1.0;endif;
if(iday=9);ymax=0.9;endif;
if(iday=10);ymax=0.9;endif;
if(iday=11);ymax=0.7;endif;
if(iday=12);ymax=0.7;endif;
if(iday=13);ymax=0.6;endif;
if(iday=14);ymax=0.6;endif;
if(iday=15);ymax=0.6;endif;
return ymax
function getmin(iday)
if(iday=1);ymin=0.8;endif;
if(iday=2);ymin=0.7;endif;
if(iday=3);ymin=0.6;endif;
if(iday=4);ymin=0.5;endif;
if(iday=5);ymin=0.3;endif;
if(iday=6);ymin=0.2;endif;
if(iday=7);ymin=0.0;endif;
if(iday=8);ymin=-0.1;endif;
if(iday=9);ymin=-0.2;endif;
if(iday=10);ymin=-0.3;endif;
if(iday=11);ymin=0.0;endif;
if(iday=12);ymin=0.0;endif;
if(iday=13);ymin=0.0;endif;
if(iday=14);ymin=0.0;endif;
if(iday=15);ymin=0.0;endif;
return ymin
function getrmax(iday)
if(iday=1);ymax=40.;endif;
if(iday=2);ymax=55.;endif;
if(iday=3);ymax=80.;endif;
if(iday=4);ymax=90.;endif;
if(iday=5);ymax=105.;endif;
if(iday=6);ymax=120.;endif;
if(iday=7);ymax=140;endif;
if(iday=8);ymax=150.;endif;
if(iday=9);ymax=160.;endif;
if(iday=10);ymax=170.;endif;
if(iday=11);ymax=170.;endif;
if(iday=12);ymax=200.;endif;
if(iday=13);ymax=0.6;endif;
if(iday=14);ymax=0.6;endif;
if(iday=15);ymax=0.6;endif;
return ymax
function getrmin(iday)
if(iday=1);ymin=0.0;endif;
if(iday=2);ymin=0.0;endif;
if(iday=3);ymin=0.0;endif;
if(iday=4);ymin=0.0;endif;
if(iday=5);ymin=0.0;endif;
if(iday=6);ymin=0.0;endif;
if(iday=7);ymin=0.0;endif;
if(iday=8);ymin=0.0;endif;
if(iday=9);ymin=0.0;endif;
if(iday=10);ymin=0.0;endif;
if(iday=11);ymin=0.0;endif;
if(iday=12);ymin=0.0;endif;
if(iday=13);ymin=0.0;endif;
if(iday=14);ymin=0.0;endif;
if(iday=15);ymin=0.0;endif;
return ymin


