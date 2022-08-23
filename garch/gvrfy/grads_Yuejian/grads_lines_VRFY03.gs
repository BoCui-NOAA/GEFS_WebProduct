ts=CSTYMD           
te=CEDYMD       

*LINES

*OPENFILE1
*OPENFILE2
*OPENFILE3
*OPENFILE4
*OPENFILE5
*OPENFILE6

ymin=0.0
ymax=1.0
bmaxac=0.1
bmaxrms=10.0

'set display color white'
'clear'
*
* NH & SH 500 mb geopotential height (Z)
*
regs=1
rege=2

*ZISTFDAY
*ZIEDFDAY

while (istday <= iedday)
iday=istday+1

reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

var='ac'reg''
say var
grfile=''greg'500z_'istday'days_ac.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.2 11 3.8 8.5'

'set x 'iday
'set y 4'
'set z 3'

'set t 1'
'define tcnt=ave('var'.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr1vlev=digs(word,3)

if (lines>=2)
'define tcnt=ave('var'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr2vlev=digs(word,3)
endif     

if (lines>=3)
'define tcnt=ave('var'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr3vlev=digs(word,3)
endif

if (lines>=4)
'define tcnt=ave('var'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr4vlev=digs(word,3)
endif

if (lines>=5)
'define tcnt=ave('var'.5,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr5vlev=digs(word,3)
endif

if (lines>=6)
'define tcnt=ave('var'.6,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr6vlev=digs(word,3)
endif

*ymin=0.0
ymin=getymin(iday)
ymax=1.0
bmax=0.2

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
*'set cthick 5'
'set cmark 1'
*DVAR1
'set ccolor 2'
'set cmark 2'
*DVAR2
'set ccolor 3'
'set cmark 3'
*DVAR3
'set ccolor 4'
'set cmark 4'
*DVAR4
'set ccolor 5'
'set cmark 5'
*DVAR5
'set ccolor 6'
'set cmark 6'
*DVAR6

'draw title 'titreg' 500 hPa Geopotential Height at day 'istday' \ for 'ts' - 'te' '
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
*'set strsiz 0.12'
'set strsiz 0.15'
'set string 1 tl 6'
*DRAW1
'set string 2 tl 6'
*DRAW2
'set string 3 tl 6'
*DRAW3
'set string 4 tl 6'
*DRAW4
'set string 5 tl 6'
*DRAW5
'set string 6 tl 6'
*DRAW6

if (lines>=2)
'set vpage 0.2 11 2 4.9'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmaxac' 'bmaxac
'set gxout bar'
'set time 'ts' 'te
'set ccolor 3'
'set cmark  3'
'set cstyle 1'
'set cthick 4'
'd 'var'.1 - 'var'.3'
'draw ylab PP1-PP3'

'set vpage 0.2 11 0 2.9'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmaxac' 'bmaxac
'set gxout bar'
'set time 'ts' 'te
'set ccolor 4'
'set cmark  4'
'set cstyle 1'
'set cthick 4'
'd 'var'.2 - 'var'.4'
'draw ylab PP2-PP4'

endif

'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit


var='rm'reg''
say var
grfile=''greg'500z_'istday'days_rms.gr'
say grfile
'enable print 'grfile
'reset'

'set vpage 0.2 11 3.8 8.5'
'set x 'iday
'set y 1'
'set z 3'

'set t 1'
'define tcnt=ave('var'.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr1vlev=digs(word,3)

if (lines>=2)
'define tcnt=ave('var'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr2vlev=digs(word,3)
endif

if (lines>=3)
'define tcnt=ave('var'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr3vlev=digs(word,3)
endif

if (lines>=4)
'define tcnt=ave('var'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr4vlev=digs(word,3)
endif

if (lines>=5)
'define tcnt=ave('var'.5,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr5vlev=digs(word,3)
endif

if (lines>=6)
'define tcnt=ave('var'.6,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr6vlev=digs(word,3)
endif

rmin=getrmin(iday)
rmax=getrmax(iday)
bmax=0.2

'set time 'ts' 'te
'set vrange 'rmin' 'rmax
'set ccolor 1'
'set cmark 1'
*DVAR1
'set ccolor 2'
'set cmark 2'
*DVAR2
'set ccolor 3'
'set cmark 3'
*DVAR3
'set ccolor 4'
'set cmark 4'
*DVAR4
'set ccolor 5'
'set cmark 5'
*DVAR5
'set ccolor 6'
'set cmark 6'
*DVAR6

'draw title 'titreg' 500 hPa Geopotential Height at day 'istday' \ for 'ts' - 'te' '
'draw ylab RMS errors'

'set vpage 0 11 0 8.5'
*'set strsiz 0.12'
'set strsiz 0.15'
'set string 1 tl 6'
*DRAW1
'set string 2 tl 6'
*DRAW2
'set string 3 tl 6'
*DRAW3
'set string 4 tl 6'
*DRAW4
'set string 5 tl 6'
*DRAW5
'set string 6 tl 6'
*DRAW6

if (lines>=2)
'set vpage 0.2 11 2 4.9'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmaxrms' 'bmaxrms
'set gxout bar'
'set time 'ts' 'te
'set ccolor 3'
'set cmark  3'
'set cstyle 1'
'set cthick 4'
'd 'var'.1 - 'var'.3'
'draw ylab PP1-PP3'

'set vpage 0.2 11 0 2.9'
'set grads off'
'set barbase 0.0|bottom|top'
'set baropts outline'
'set vrange -'bmaxrms' 'bmaxrms
'set gxout bar'
'set time 'ts' 'te
'set ccolor 4'
'set cmark  4'
'set cstyle 1'
'set cthick 4'
'd 'var'.2 - 'var'.4'
'draw ylab PP2-PP4'

endif

'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

reg=reg+1
endwhile

istday=istday+1
endwhile

*VISTFDAY
*VIEDFDAY
flds=6
flde=15

while (istday <= iedday)
iday=istday+1

*
* TR 850 mb U RMS & 850 mb V RMS & 850 mb SPD RMS & 850 mb VTR RMS
*

fld=flds
while (fld <= flde)

titnam=getnam(fld)
fnam=getfnam(fld)

var='ac'fld''
say var

grfile='tr850'fnam'_'istday'days_ac_rms.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.2 11 3.8 8.5'

'set x 'iday
'set y 4'
'set z 2'

'set t 1'
'define tcnt=ave('var'.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr1vlev=digs(word,3)

if (lines>=2)
'define tcnt=ave('var'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr2vlev=digs(word,3)
endif

if (lines>=3)
'define tcnt=ave('var'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr3vlev=digs(word,3)
endif

if (lines>=4)
'define tcnt=ave('var'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr4vlev=digs(word,3)
endif

if (lines>=5)
'define tcnt=ave('var'.5,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr5vlev=digs(word,3)
endif

if (lines>=6)
'define tcnt=ave('var'.6,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr6vlev=digs(word,3)
endif

ymin=0.5
ymax=1.0

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'set cmark 1'
*DVAR1
'set ccolor 2'
'set cmark 2'
*DVAR2
'set ccolor 3'
'set cmark 3'
*DVAR3
'set ccolor 4'
'set cmark 4'
*DVAR4
'set ccolor 5'
'set cmark 5'
*DVAR5
'set ccolor 6'
'set cmark 6'
*DVAR6
'draw title TROPICAL 850 hPa 'titnam' at day 'istday' \ for 'ts' - 'te''
'draw ylab AC scores'

'set vpage 0 11 0 8.5'
*'set strsiz 0.12'
'set strsiz 0.15'
'set string 1 tl 6'
*TDRAW1
'set string 2 tl 6'
*TDRAW2
'set string 3 tl 6'
*TDRAW3
'set string 4 tl 6'
*TDRAW4
'set string 5 tl 6'
*TDRAW5
'set string 6 tl 6'
*TDRAW6

var='rm'fld''
say var

'set vpage 0.2 11 0 4.7'

'set x 'iday
'set y 1'
'set z 2'

'set t 1'
'define tcnt=ave('var'.1,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr1vlev=digs(word,3)

if (lines>=2)
'define tcnt=ave('var'.2,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr2vlev=digs(word,3)
endif    

if (lines>=3)
'define tcnt=ave('var'.3,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr3vlev=digs(word,3)
endif

if (lines>=4)
'define tcnt=ave('var'.4,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr4vlev=digs(word,3)
endif

if (lines>=5)
'define tcnt=ave('var'.5,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr5vlev=digs(word,3)
endif

if (lines>=6)
'define tcnt=ave('var'.6,time='ts',time='te')'
'd tcnt'
say result
line=sublin(result,1)
word=subwrd(line,4)
pr6vlev=digs(word,3)
endif

ymin=0.0
ymax=7.0
bmax=2.0

'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'set cmark 1'
*DVAR1
'set ccolor 2'
'set cmark 2'
*DVAR2
'set ccolor 3'
'set cmark 3'
*DVAR3
'set ccolor 4'
'set cmark 4'
*DVAR4
'set ccolor 5'
'set cmark 5'
*DVAR5
'set ccolor 6'
'set cmark 6'
*DVAR6
'draw ylab RMS errors'

'set vpage 0 11 0 8.5'
*'set strsiz 0.12'
'set strsiz 0.15'
'set string 1 tl 6'
*BDRAW1
'set string 2 tl 6'
*BDRAW2
'set string 3 tl 6'
*BDRAW3
'set string 4 tl 6'
*BDRAW4
'set string 5 tl 6'
*BDRAW5
'set string 6 tl 6'
*BDRAW6

'print'
'disable print'

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

fld=fld+3
endwhile

istday=istday+1
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
    if(nc  = 10 ); break; endif
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
if(fld=12);greg='Wind-Speed';endif;
if(fld=15);greg='Wind-Vector';endif;
return greg
function getfnam(fld)
if(fld=6);greg='u';endif;
if(fld=9);greg='v';endif;
if(fld=12);greg='s';endif;
if(fld=15);greg='r';endif;
return greg
function getymin(iday)
if(iday=1);ymin=0.95;endif;
if(iday=2);ymin=0.95;endif;
if(iday=3);ymin=0.9;endif;
if(iday=4);ymin=0.8;endif;
if(iday=5);ymin=0.6;endif;
if(iday=6);ymin=0.5;endif;
if(iday=7);ymin=0.0;endif;
if(iday=8);ymin=0.0;endif;
if(iday=9);ymin=0.0;endif;
if(iday=10);ymin=0.0;endif;
if(iday=11);ymin=0.0;endif;
if(iday=12);ymin=0.0;endif;
if(iday=13);ymin=0.0;endif;
if(iday=14);ymin=0.0;endif;
if(iday=15);ymin=0.0;endif;
if(iday=16);ymin=0.0;endif;
return ymin
function getrmin(iday)
if(iday=1);rmin=0.0;endif;
if(iday=2);rmin=0.0;endif;
if(iday=3);rmin=5.0;endif;
if(iday=4);rmin=10.;endif;
if(iday=5);rmin=15.;endif;
if(iday=6);rmin=20.;endif;
if(iday=7);rmin=20.;endif;
if(iday=8);rmin=30.;endif;
if(iday=9);rmin=0.0;endif;
if(iday=10);rmin=0.0;endif;
if(iday=11);rmin=0.0;endif;
if(iday=12);rmin=0.0;endif;
if(iday=13);rmin=0.0;endif;
if(iday=14);rmin=0.0;endif;
if(iday=15);rmin=0.0;endif;
if(iday=16);rmin=0.0;endif;
return rmin
function getrmax(iday)
if(iday=1);rmax=20.;endif;
if(iday=2);rmax=30.;endif;
if(iday=3);rmax=40.;endif;
if(iday=4);rmax=60.;endif;
if(iday=5);rmax=90.;endif;
if(iday=6);rmax=120.;endif;
if(iday=7);rmax=140.;endif;
if(iday=8);rmax=160.;endif;
if(iday=9);rmax=160.;endif;
if(iday=10);rmax=160.;endif;
if(iday=11);rmax=160.;endif;
if(iday=12);rmax=0.0;endif;
if(iday=13);rmax=0.0;endif;
if(iday=14);rmax=0.0;endif;
if(iday=15);rmax=0.0;endif;
if(iday=16);rmax=0.0;endif;
return rmax
