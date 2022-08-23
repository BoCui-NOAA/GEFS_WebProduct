ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'
'open prEXPID2.ctl'

'set display color white'
'clear'

regs=1
rege=2
reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

grfile='/ptmp/wx20yz/grads/'greg'500h_ac_die.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.5'                    
'set grads off'
'set xlab  off'
'set x 1 31'
'set y 4'       
'set z 1'   
'set t 1'

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

'define ta=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tb=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
*'define tc=ave(ac10,time='ts',time='te')'
'define tc=ave('var3',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define td=ave('var4'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set t  1'
'set vrange 0.0 1.0'           
'set ccolor 1'
'set cmark 1'
'd ta'
'set ccolor 2'
'set cmark 2'
'd tb'
'set ccolor 3'
'set cmark 3'
'd tc'
'set ccolor 4'
'set cmark 4'
'd td'
'draw title 'titreg' 500 mb Height ( wave 1-20 ) \ Average For 'ts' - 'te''
'draw title 'titreg' 500 mb Height ( wave 1-20 ) \ Average For 'ts' - 'te''
'draw xlab Forecast days'
'draw ylab Anomaly correlation scores'
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
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_4alines 2.3 1.2 3.8 2.2'

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

'set display color white'
'clear'
grfile='/ptmp/wx20yz/grads/'greg'500h_rms_die.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.5'
'set grads off'
'set xlab  off'
'set x 1 31'
'set y 1'      
'set z 1'
'set t 1'

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

'define ta=ave('var1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'define tb=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'define tc=ave('var3',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'define td=ave('var4'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 2'
'define te=ave('var5',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 3'
'define tf=ave('var3',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set t  1'
'set vrange 0.0 160'
'set ccolor 1'
'set cmark 1'
'd ta'
'set ccolor 2'
'set cmark 2'
'd tb'
'set ccolor 3'
'set cmark 3'
'd tc'
'set ccolor 4'
'set cmark 4'
'd td'
'set ccolor 5'
'set cmark 5'
'd te'
'set ccolor 6'
'set cmark 6'
'd tf'
'draw title 'titreg' 500 mb Height \ Average For 'ts' - 'te''
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
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_6lines 8.6 1.0 10.1 2.2'

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

reg=reg+1
endwhile

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
function gettnam(field)
if(field=1);tnam="nh1000zac_die";endif
if(field=2);tnam="sh1000zac_die";endif
if(field=3);tnam="nh500zac_die";endif
if(field=4);tnam="sh500zac_die";endif
if(field=5);tnam="tr850uac_die";endif
if(field=6);tnam="tr850vac_die";endif
if(field=7);tnam="tr850sac_die";endif
if(field=8);tnam="tr200uac_die";endif
if(field=9);tnam="tr200vac_die";endif
if(field=10);tnam="tr200sac_die";endif
if(field=11);tnam="nh1000zrms_die";endif
if(field=12);tnam="sh1000zrms_die";endif
if(field=13);tnam="nh500zrms_die";endif
if(field=14);tnam="sh500zrms_die";endif
if(field=15);tnam="tr850urms_die";endif
if(field=16);tnam="tr850vrms_die";endif
if(field=17);tnam="tr850srms_die";endif
if(field=18);tnam="tr850rrms_die";endif
if(field=19);tnam="tr200urms_die";endif
if(field=20);tnam="tr200vrms_die";endif
if(field=21);tnam="tr200srms_die";endif
if(field=22);tnam="tr200rrms_die";endif
return tnam
