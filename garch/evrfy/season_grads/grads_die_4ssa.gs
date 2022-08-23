'open season.ctl'
'set display color white'
'clear'

ts=00Z01JUL00
te=00Z01JAN04
'set y 1'
'set z 1'
'set x 1 16'
grfile='500h_season_4ss_NH.gr'
say grfile
'enable print 'grfile
'reset'

var1=nhacmrf
var2=nhacctl
var3=nhacens
'set vpage 0.0 5.8 4.0 8.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set t 1'
'set vrange 0.0 1.0'         
'set ccolor 1'
'set cmark 1'
'd 'var3''
'set t 5'
'set ccolor 2'
'set cmark 2'
'd 'var3''
'set t 9'
'set ccolor 3'
'set cmark 3'
'd 'var3''
'set t 13'
'set ccolor 4'
'set cmark 4'
'd 'var3''
'draw xlab Forecast days'
'draw ylab PAC'
'draw title NH 500hPa height (ENS)'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

var1=nhrmmrf
var2=nhrmctl
var3=nhrmens
var4=nhrmsrd
'set vpage 0.0 5.8 0.0 4.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set vrange 0 120'      
'set t 1'
'set ccolor 1'
'set cmark 1'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'set t 5'
'set ccolor 2'
'set cmark 2'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'set t 9'
'set ccolor 3'
'set cmark 3'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'set t 13'
'set ccolor 4'
'set cmark 4'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'draw xlab Forecast days'
'draw ylab RMS errors'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

var1=nhacmrf
var3=nhacctl
var2=nhacens
'set vpage 5.2 11.0 4.0 8.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set vrange 0.0 1.0'
'set t 1'
'set ccolor 1'
'set cmark 1'
'd 'var3''
'set t 5'
'set ccolor 2'
'set cmark 2'
'd 'var3''
'set t 9'
'set ccolor 3'
'set cmark 3'
'd 'var3''
'set t 13'
'set ccolor 4'
'set cmark 4'
'd 'var3''
'draw xlab Forecast days'
'draw ylab PAC'
'draw title NH 500hPa height (CTL)'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

var1=nhrmmrf
var3=nhrmctl
var2=nhrmens
var4=nhrmsrd
'set vpage 5.2 11.0 0.0 4.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set vrange 0 120'
'set t 1'
'set ccolor 1'
'set cmark 1'
'set cstyle 1'
'd 'var3''
'set t 5'
'set ccolor 2'
'set cmark 2'
'set cstyle 1'
'd 'var3''
'set t 9'
'set ccolor 3'
'set cmark 3'
'set cstyle 1'
'd 'var3''
'set t 13'
'set ccolor 4'
'set cmark 4'
'set cstyle 1'
'd 'var3''
'draw xlab Forecast days'
'draw ylab RMS error'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

'set vpage 0.0 11.0 0.0 8.5'
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_4ss_4lines 1.2 4.5 2.5 5.5'
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_4ss_4lines 4.0 0.5 5.3 1.5'
'set vpage 0.0 11.0 0.8 8.5'
'draw title SUMMER SEASONS, 2000-2003'

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

ts=00Z01JUL00
te=00Z01JAN04
'set y 1'
'set z 1'
'set x 1 16'
grfile='500h_season_4ss_SH.gr'
say grfile
'enable print 'grfile
'reset'

var1=shacmrf
var2=shacctl
var3=shacens
'set vpage 0.0 5.8 4.0 8.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set t 1'
'set vrange 0.0 1.0'         
'set ccolor 1'
'set cmark 1'
'd 'var3''
'set t 5'
'set ccolor 2'
'set cmark 2'
'd 'var3''
'set t 9'
'set ccolor 3'
'set cmark 3'
'd 'var3''
'set t 13'
'set ccolor 4'
'set cmark 4'
'd 'var3''
'draw xlab Forecast days'
'draw ylab PAC'
'draw title SH 500hPa height (ENS)'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

var1=shrmmrf
var2=shrmctl
var3=shrmens
var4=shrmsrd
'set vpage 0.0 5.8 0.0 4.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set vrange 0 160'      
'set t 1'
'set ccolor 1'
'set cmark 1'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'set t 5'
'set ccolor 2'
'set cmark 2'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'set t 9'
'set ccolor 3'
'set cmark 3'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'set t 13'
'set ccolor 4'
'set cmark 4'
'set cstyle 1'
'd 'var3''
'set cstyle 5'
'd 'var4''
'draw xlab Forecast days'
'draw ylab RMS errors'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

var1=shacmrf
var3=shacctl
var2=shacens
'set vpage 5.2 11.0 4.0 8.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set vrange 0.0 1.0'
'set t 1'
'set ccolor 1'
'set cmark 1'
'd 'var3''
'set t 5'
'set ccolor 2'
'set cmark 2'
'd 'var3''
'set t 9'
'set ccolor 3'
'set cmark 3'
'd 'var3''
'set t 13'
'set ccolor 4'
'set cmark 4'
'd 'var3''
'draw xlab Forecast days'
'draw ylab PAC'
'draw title SH 500hPa height (CTL)'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

var1=shrmmrf
var3=shrmctl
var2=shrmens
var4=shrmsrd
'set vpage 5.2 11.0 0.0 4.2'
'set grads off'
'set xlab off'

'set cthick 6'
'set vrange 0 160'
'set t 1'
'set ccolor 1'
'set cmark 1'
'set cstyle 1'
'd 'var3''
'set t 5'
'set ccolor 2'
'set cmark 2'
'set cstyle 1'
'd 'var3''
'set t 9'
'set ccolor 3'
'set cmark 3'
'set cstyle 1'
'd 'var3''
'set t 13'
'set ccolor 4'
'set cmark 4'
'set cstyle 1'
'd 'var3''
'draw xlab Forecast days'
'draw ylab RMS error'
'draw string 1.92 0.55 0'
'draw string 2.48 0.55 1'
'draw string 3.04 0.55 2'
'draw string 3.60 0.55 3'
'draw string 4.16 0.55 4'
'draw string 4.72 0.55 5'
'draw string 5.28 0.55 6'
'draw string 5.84 0.55 7'
'draw string 6.40 0.55 8'
'draw string 6.96 0.55 9'
'draw string 7.52 0.55 10'
'draw string 8.08 0.55 11'
'draw string 8.64 0.55 12'
'draw string 9.20 0.55 13'
'draw string 9.76 0.55 14'
'draw string 10.32 0.55 15'

'set vpage 0.0 11.0 0.0 8.5'
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_4ss_4lines 1.2 4.5 2.5 5.5'
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_4ss_4lines 4.0 0.5 5.3 1.5'
'set vpage 0.0 11.0 0.8 8.5'
'draw title SUMMER SEASONS, 2000-2003'

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




