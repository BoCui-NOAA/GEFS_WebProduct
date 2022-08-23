ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'
'open prEXPID2.ctl'

'set display color white'
'clear'
*
* NH & SH 2 meters Temperature (T)
*
regs=1
rege=3
istday=1
iedday=8

while (istday <= iedday)
iday=istday+1

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
if (reg=3) 
var1='ac27'
var2='ac28'
var3='ac33'
var4='ac34'
endif

grfile=''greg'2mt_'istday'days_ac.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.5'

'set x 'iday
'set y 4'
'set z 1'

'set t 1'

'define tcnt=ave('var4',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prsnt2m=digs(word,3)

'define tcnt=ave('var4'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prxnt2m=digs(word,3)

ymin=getmin(istday)
ymax=getmax(istday)

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd 'var4'.1'
'set ccolor 2'
'd 'var4'.2'
'draw title 'titreg' 2-meter Temperature at day 'istday' \ for 'ts' - 'te' '
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
'set strsiz 0.18'
'set string 1 tl 6'
'draw string 8.0 1.9 ENS_s='prsnt2m
'set string 2 tl 6'
'draw string 8.0 1.5 ENS_b='prxnt2m

*
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

if (reg=1)
 var1='rm1'
 var2='rm2'
 var3='rm7'
 var4='rm8'
 var5='sp1'
endif
if (reg=2)
 var1='rm14'
 var2='rm15'
 var3='rm20'
 var4='rm21'
 var5='sp2'
endif
if (reg=3)
 var1='rm27'
 var2='rm28'
 var3='rm33'
 var4='rm34'
 var5='sp3'
endif

grfile=''greg'2mt_'istday'days_rms.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0 11 0 8.5'

'set x 'iday
'set z 1'

'set t 1'
'set y 1'

'define tcnt=ave('var4'/100,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prant2m=digs(word,3)

'define tcnt=ave('var4'.2/100,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prbnt2m=digs(word,3)

'set y 2'

'define tcnt=ave('var5',time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prdnt2m=digs(word,3)

'define tcnt=ave('var5'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
prent2m=digs(word,3)

ymin=getrmin(istday)
ymax=getrmax(istday)

'set y 1'
'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd 'var4'/100'
'set ccolor 2'
'd 'var4'.2/100'

'set y 2'
'set cstyle 5'
'set ccolor 1'
'd 'var5''
'set cstyle 5'
'set ccolor 2'
'd 'var5'.2'
'set cstyle 5'
'draw title 'titreg' 2 meter Temperature at day 'istday' \ for 'ts' - 'te' '
'draw ylab RMS errors'

'set vpage 0 11 0 8.5'
'set strsiz 0.18'
'set string 1 tl 6'
'draw string 8.0 1.6 ENS_s='prant2m
'set string 2 tl 6'
'draw string 8.0 1.3 ENS_b='prbnt2m

'set string 1 tl 6'
'draw string 3.0 1.6 SPR_s='prdnt2m
'set string 2 tl 6'
'draw string 3.0 1.3 SPR_b='prent2m
*
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

reg=reg+1
endwhile

istday=istday+1
endwhile

*'quit'
*
function digs(string,num)
  nc=0
  pt=""
  while(pt = "")
    nc=nc+1
    zzz=substr(string,nc,1)
    if(zzz = "."); break; endif
    if(nc = 20); break; endif
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
if(iday=1);ymax=1.1;endif;
if(iday=2);ymax=1.1;endif;
if(iday=3);ymax=1.0;endif;
if(iday=4);ymax=1.0;endif;
if(iday=5);ymax=1.0;endif;
if(iday=6);ymax=1.0;endif;
if(iday=7);ymax=1.0;endif;
if(iday=8);ymax=1.0;endif;
if(iday=9);ymax=0.8;endif;
if(iday=10);ymax=0.7;endif;
if(iday=11);ymax=0.7;endif;
if(iday=12);ymax=0.7;endif;
if(iday=13);ymax=0.6;endif;
if(iday=14);ymax=0.6;endif;
if(iday=15);ymax=0.6;endif;
return ymax
function getmin(iday)
if(iday=1);ymin=0.9;endif;
if(iday=2);ymin=0.9;endif;
if(iday=3);ymin=0.8;endif;
*if(iday=3);ymin=0.8;endif;
if(iday=4);ymin=0.8;endif;
if(iday=5);ymin=0.8;endif;
if(iday=6);ymin=0.7;endif;
if(iday=7);ymin=0.7;endif;
if(iday=8);ymin=0.7;endif;
if(iday=9);ymin=-0.2;endif;
if(iday=10);ymin=-0.3;endif;
if(iday=11);ymin=0.0;endif;
if(iday=12);ymin=0.0;endif;
if(iday=13);ymin=0.0;endif;
if(iday=14);ymin=0.0;endif;
if(iday=15);ymin=0.0;endif;
return ymin
function getrmax(iday)
if(iday=1);ymax=3.;endif;
if(iday=2);ymax=3.;endif;
if(iday=3);ymax=4.;endif;
if(iday=4);ymax=4.;endif;
if(iday=5);ymax=5.;endif;
if(iday=6);ymax=5.;endif;
if(iday=7);ymax=6;endif;
if(iday=8);ymax=6.;endif;
if(iday=9);ymax=6.;endif;
if(iday=10);ymax=7.;endif;
if(iday=11);ymax=7.;endif;
if(iday=12);ymax=10.;endif;
if(iday=13);ymax=0.6;endif;
if(iday=14);ymax=0.6;endif;
if(iday=15);ymax=0.6;endif;
return ymax
function getrmin(iday)
if(iday=1);ymin=-1.;endif;
if(iday=2);ymin=-1.;endif;
if(iday=3);ymin=-1.;endif;
if(iday=4);ymin=-1.;endif;
if(iday=5);ymin=-1.;endif;
if(iday=6);ymin=-1.;endif;
if(iday=7);ymin=-1.;endif;
if(iday=8);ymin=-1.;endif;
if(iday=9);ymin=-1.;endif;
if(iday=10);ymin=-1.;endif;
if(iday=11);ymin=-1.;endif;
if(iday=12);ymin=0.0;endif;
if(iday=13);ymin=0.0;endif;
if(iday=14);ymin=0.0;endif;
if(iday=15);ymin=0.0;endif;
return ymin
