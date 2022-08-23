ts=CSTYMD           
te=CEDYMD       

lines=4
fdays=9 

'open prEXPID1.ctl'
'open prEXPID2.ctl'
'open prEXPID3.ctl'
'open prEXPID4.ctl'
*OPENFILE5
*OPENFILE6

*#fld =  1 (nh1000zac)   2 (sh1000zac)   3 (nh500zac)   4 (sh500zac) 
*#fld =  5 (trp850uac)   6 (trp850vac)   7 (trp850sac)                 
*#fld =  8 (trp200uac)   9 (trp200vac)  10 (trp200sac)  
*#fld = 11 (nh1000zrms) 12 (sh1000zrms) 13 (nh500zrms) 14 (sh500zrms)
*#fld = 15 (trp850urms) 16 (trp850vrms) 17 (tr850srms) 18 (tr850rrms)
*#fld = 19 (trp200urms) 20 (trp200vrms) 21 (tr200srms) 22 (tr200rrms)
flds=1
flde=22

while (flds<=flde)

fvar=getfvar(flds)
fnam=getfnam(flds)

'set display color white'
'clear'
grfile=''fnam'.gr'
say grfile
'enable print 'grfile
'reset'

frms=1
frme=4
while (frms<=frme)
flef=getflef(frms)
frig=getfrig(frms)
fbot=getfbot(frms)
ftop=getftop(frms)
wtit=getwtit(frms)
utit=getutit(frms)
vlev=getlev(flds)

*fld =  1 -- 10        
if (flds<=10)
 if (frms=1);ymin=0;   ymax=1;  endif
 if (frms=2);ymin=0;   ymax=1;  endif
 if (frms=3);ymin=0;   ymax=1;  endif
 if (frms=4);ymin=0.4;   ymax=1;  endif
endif

*fld = 11 -- 14          
if (flds>10 & flds<=14)
 if (frms=1);ymin=0;   ymax=160;endif
 if (frms=2);ymin=-20; ymax=20; endif
 if (frms=3);ymin=40;  ymax=160;endif
 if (frms=4);ymin=-20; ymax=20; endif
endif
*fld = 15 -- 18           
if (flds>14 & flds<=18)
 if (frms=1);ymin=0;   ymax=8;  endif
 if (frms=2);ymin=-4;  ymax=6;  endif
 if (frms=3);ymin=2;   ymax=6;  endif
 if (frms=4);ymin=-6;  ymax=4;  endif
endif
*fld = 19 -- 22           
if (flds>18)
 if (frms=1);ymin=0;   ymax=16; endif
 if (frms=2);ymin=-8;  ymax=12;  endif
 if (frms=3);ymin=4;   ymax=20; endif
 if (frms=4);ymin=-12;  ymax=8;  endif
endif

'set vpage 'flef' 'frig' 'fbot' 'ftop''
'set grads off'
'set xlab  off'

*xlen=fdays+1
xlen=fdays+1
*'set x 1 'xlen
'set x 2 'xlen
'set y 'frms
'set z 'vlev

'set t 1'
'define t1'frms'=ave('fvar'.1,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

if (lines>=2)
'define t2'frms'=ave('fvar'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
endif

if (lines>=3)
'define t3'frms'=ave('fvar'.3,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
endif

if (lines>=4)
'define t4'frms'=ave('fvar'.4,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
endif

if (lines>=5)
'define t5'frms'=ave('fvar'.5,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
endif

if (lines>=6)
'define t6'frms'=ave('fvar'.6,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
endif

'set t 1'
'set vrange 'ymin' 'ymax
'set cthick 6'
'set cmark 1'
'd t1'frms''          
'set ccolor 2'
'set cmark 2'
'd t2'frms''        
'set ccolor 3'
'set cmark 3'
'd t3'frms''        
'set ccolor 4'
'set cmark 4'
'd t4'frms''        
'set ccolor 5'
'set cmark 5'
*DVAR5        
'set ccolor 6'
'set cmark 6'
*DVAR6        

'draw xlab Forecast days'
'set strsiz 0.1'

if (fdays=5)
'draw string 1.95 0.55 0'
'draw string 3.63 0.55 1'
'draw string 5.31 0.55 2'
'draw string 6.99 0.55 3'
'draw string 8.67 0.55 4'
'draw string 10.35 0.55 5'
endif

if (fdays=6)
'draw string 1.95 0.55 0'
'draw string 3.35 0.55 1'
'draw string 4.75 0.55 2'
'draw string 6.15 0.55 3'
'draw string 7.55 0.55 4'
'draw string 8.95 0.55 5'
'draw string 10.35 0.55 6'
endif

if (fdays=7)
'draw string 1.95 0.55 0'
'draw string 3.15 0.55 1'
'draw string 4.35 0.55 2'
'draw string 5.55 0.55 3'
'draw string 6.75 0.55 4'
'draw string 7.95 0.55 5'
'draw string 9.15 0.55 6'
'draw string 10.35 0.55 7'
endif

if (fdays=8)
'draw string 1.95 0.55 0'
'draw string 3.00 0.55 1'
'draw string 4.05 0.55 2'
'draw string 5.10 0.55 3'
'draw string 6.15 0.55 4'
'draw string 7.20 0.55 5'
'draw string 8.25 0.55 6'
'draw string 9.30 0.55 7'
'draw string 10.35 0.55 8'
endif

if (fdays=9)
'draw string 1.95 0.55 1'
'draw string 3.00 0.55 2'
'draw string 4.05 0.55 3'
'draw string 5.10 0.55 4'
'draw string 6.15 0.55 5'
'draw string 7.20 0.55 6'
'draw string 8.25 0.55 7'
'draw string 9.30 0.55 8'
'draw string 10.35 0.55 9'
endif

if (fdays=10)
'draw string 1.95 0.55 0'
'draw string 2.79 0.55 1'
'draw string 3.63 0.55 2'
'draw string 4.47 0.55 3'
'draw string 5.31 0.55 4'
'draw string 6.15 0.55 5'
'draw string 6.99 0.55 6'
'draw string 7.83 0.55 7'
'draw string 8.67 0.55 8'
'draw string 9.51 0.55 9'
'draw string 10.35 0.55 10'
endif

if (fdays=12)
'draw string 1.95 0.55 0'
'draw string 2.65 0.55 1'
'draw string 3.35 0.55 2'
'draw string 4.05 0.55 3'
'draw string 4.75 0.55 4'
'draw string 5.65 0.55 5'
'draw string 6.35 0.55 6'
'draw string 7.05 0.55 7'
'draw string 7.75 0.55 8'
'draw string 8.35 0.55 9'
'draw string 9.05 0.55 10'
'draw string 9.75 0.55 11'
'draw string 10.35 0.55 12'
endif

if (fdays=15)
'draw string 1.95 0.55 0'
'draw string 2.51 0.55 1'
'draw string 3.07 0.55 2'
'draw string 3.63 0.55 3'
'draw string 4.19 0.55 4'
'draw string 4.75 0.55 5'
'draw string 5.31 0.55 6'
'draw string 5.87 0.55 7'
'draw string 6.43 0.55 8'
'draw string 6.99 0.55 9'
'draw string 7.55 0.55 10'
'draw string 8.11 0.55 11'
'draw string 8.67 0.55 12'
'draw string 9.23 0.55 13'
'draw string 9.79 0.55 14'
'draw string 10.35 0.55 15'
endif


if(flds=1);'draw title NH 1000 mb Height ( wave 'wtit' )';endif
if(flds=2);'draw title SH 1000 mb Height ( wave 'wtit' )';endif
if(flds=3);'draw title NH 500 mb Height ( wave 'wtit' )';endif
if(flds=4);'draw title SH 500 mb Height ( wave 'wtit' )';endif
if(flds=5);'draw title Tropical 850 mb wind(u) ( wave 'wtit' )';endif
if(flds=6);'draw title Tropical 850 mb wind(v) ( wave 'wtit' )';endif
if(flds=7);'draw title Tropical 850 mb wind spd( wave 'wtit' )';endif
if(flds=8);'draw title Tropical 200 mb wind(u) ( wave 'wtit' )';endif
if(flds=9);'draw title Tropical 200 mb wind(v) ( wave 'wtit' )';endif
if(flds=10);'draw title Tropical 200 mb wind spd( wave 'wtit' )';endif
if(flds=11);'draw title NH 1000 mb Height ('utit') )';endif
if(flds=12);'draw title SH 1000 mb Height ('utit') )';endif
if(flds=13);'draw title NH 500 mb Height ('utit') )';endif
if(flds=14);'draw title SH 500 mb Height ('utit') )';endif
if(flds=15);'draw title Tropical wind(U) at 850 mb ('utit') )';endif
if(flds=16);'draw title Tropical wind(V) at 850 mb ('utit') )';endif
if(flds=17);'draw title Tropical wind spd at 850 mb ('utit') )';endif
if(flds=18);'draw title Tropical wind vtr at 850 mb ('utit') )';endif
if(flds=19);'draw title Tropical wind(U) at 200 mb ('utit') )';endif
if(flds=20);'draw title Tropical wind(V) at 200 mb ('utit') )';endif
if(flds=21);'draw title Tropical wind spd at 200 mb ('utit') )';endif
if(flds=22);'draw title Tropical wind vtr at 200 mb ('utit') )';endif

*if (frms=1)
*if (flds<=10)
*'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_lines 1.2 4.5 2.5 6.0'
*else
*'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_lines 1.2 6.3 2.5 7.7'
*endif
*endif

frms=frms+1
endwhile

if (flds<=10)
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_lines 1.2 4.5 2.5 6.0'
else
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_lines 1.2 6.3 2.5 7.7'
endif

'set vpage 0 11 1 8.5'
'draw title AVERAGE FOR 'ts' - 'te''

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

flds=flds+1
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
    if(nc  =  20); break; endif
  endwhile
  end=nc+num
  str=substr(string,1,end)
return str
function getflef(frame)
if(frame=1);flef=0.0;endif
if(frame=2);flef=5.0;endif
if(frame=3);flef=0.0;endif
if(frame=4);flef=5.0;endif
return flef
function getfrig(frame)
if(frame=1);frig=6.0;endif
if(frame=2);frig=11.;endif
if(frame=3);frig=6.0;endif
if(frame=4);frig=11.;endif
return frig
function getfbot(frame)
if(frame=1);fbot=4.0;endif
if(frame=2);fbot=4.0;endif
if(frame=3);fbot=0.0;endif
if(frame=4);fbot=0.0;endif
return fbot
function getftop(frame)
if(frame=1);ftop=8.2;endif
if(frame=2);ftop=8.2;endif
if(frame=3);ftop=4.2;endif
if(frame=4);ftop=4.2;endif
return ftop
function getwtit(frame)
if(frame=1);wtit="1-3 AC";endif
if(frame=2);wtit="4-9 AC";endif
if(frame=3);wtit="10-20 AC";endif
if(frame=4);wtit="1-20 AC";endif
return wtit
function getutit(frame)
if(frame=1);utit="F-A rms";endif
if(frame=2);utit="F-A mean";endif
if(frame=3);utit="F-C rms";endif
if(frame=4);utit="F-C mean";endif
return utit
function getfvar(field)
if(field=1);fvar="ac1";endif
if(field=2);fvar="ac2";endif
if(field=3);fvar="ac1";endif
if(field=4);fvar="ac2";endif
if(field=5);fvar="ac6";endif
if(field=6);fvar="ac9";endif
if(field=7);fvar="ac12";endif
if(field=8);fvar="ac6";endif
if(field=9);fvar="ac9";endif
if(field=10);fvar="ac12";endif
if(field=11);fvar="rm1";endif
if(field=12);fvar="rm2";endif
if(field=13);fvar="rm1";endif
if(field=14);fvar="rm2";endif
if(field=15);fvar="rm6";endif
if(field=16);fvar="rm9";endif
if(field=17);fvar="rm12";endif
if(field=18);fvar="rm15";endif
if(field=19);fvar="rm6";endif
if(field=20);fvar="rm9";endif
if(field=21);fvar="rm12";endif
if(field=22);fvar="rm15";endif
return fvar
function getfnam(field)
if(field=1);fnam="nh1000zac_die";endif
if(field=2);fnam="sh1000zac_die";endif
if(field=3);fnam="nh500zac_die";endif
if(field=4);fnam="sh500zac_die";endif
if(field=5);fnam="tr850uac_die";endif
if(field=6);fnam="tr850vac_die";endif
if(field=7);fnam="tr850sac_die";endif
if(field=8);fnam="tr200uac_die";endif
if(field=9);fnam="tr200vac_die";endif
if(field=10);fnam="tr200sac_die";endif
if(field=11);fnam="nh1000zrms_die";endif
if(field=12);fnam="sh1000zrms_die";endif
if(field=13);fnam="nh500zrms_die";endif
if(field=14);fnam="sh500zrms_die";endif
if(field=15);fnam="tr850urms_die";endif
if(field=16);fnam="tr850vrms_die";endif
if(field=17);fnam="tr850srms_die";endif
if(field=18);fnam="tr850rrms_die";endif
if(field=19);fnam="tr200urms_die";endif
if(field=20);fnam="tr200vrms_die";endif
if(field=21);fnam="tr200srms_die";endif
if(field=22);fnam="tr200rrms_die";endif
return fnam
function getlev(fields)
if(fields=1);lev=1;endif
if(fields=2);lev=1;endif
if(fields=3);lev=3;endif
if(fields=4);lev=3;endif
if(fields=5);lev=2;endif
if(fields=6);lev=2;endif
if(fields=7);lev=2;endif
if(fields=8);lev=4;endif
if(fields=9);lev=4;endif
if(fields=10);lev=4;endif
if(fields=11);lev=1;endif
if(fields=12);lev=1;endif
if(fields=13);lev=3;endif
if(fields=14);lev=3;endif
if(fields=15);lev=2;endif
if(fields=16);lev=2;endif
if(fields=17);lev=2;endif
if(fields=18);lev=2;endif
if(fields=19);lev=4;endif
if(fields=20);lev=4;endif
if(fields=21);lev=4;endif
if(fields=22);lev=4;endif
return lev
