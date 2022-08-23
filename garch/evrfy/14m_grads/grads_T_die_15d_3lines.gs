ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'
'open prEXPID2.ctl'
'open prEXPID3.ctl'

'set display color white'
'clear'
regs=1
rege=2

reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

grfile=''greg'500h_tg_die.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.0'                    
'set grads off'
'set xlab  off'
'set z 1'   
'set t 1'

if (reg=1)
 var1='tg1'
 var2='tg7'
 var3='tg13'
endif
if (reg=2)
 var1='tg2'
 var2='tg8'
 var3='tg14'
endif

'set x 2 16'
'set y 1'       
'define ta=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tc=ave('var2'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define te=ave('var2'.3,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set y 4'       
'define tb=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define td=ave('var2'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tf=ave('var2'.3,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set t 1'
'set vrange -12. 28.'           
'set ccolor 1'
'set cmark 1'
'd (ta + tb - 200/11)'
'set ccolor 2'
'set cmark 2'
'd (tc + td - 200/11)'
'set ccolor 3'
'set cmark 3'
'd (te + tf - 200/11)'
'draw xlab Forecast days'
'draw ylab Percentage above/below zero'
*'draw string 1.92 0.55 0'
*'draw string 2.48 0.55 1'
*'draw string 3.04 0.55 2'
*'draw string 3.60 0.55 3'
*'draw string 4.16 0.55 4'
*'draw string 4.72 0.55 5'
*'draw string 5.28 0.55 6'
*'draw string 5.84 0.55 7'
*'draw string 6.40 0.55 8'
*'draw string 6.96 0.55 9'
*'draw string 7.52 0.55 10'
*'draw string 8.08 0.55 11'
*'draw string 8.64 0.55 12'
*'draw string 9.20 0.55 13'
*'draw string 9.76 0.55 14'
*'draw string 10.32 0.55 15'
'draw string 1.92 0.55 1'
'draw string 2.52 0.55 2'
'draw string 3.12 0.55 3'
'draw string 3.72 0.55 4'
'draw string 4.32 0.55 5'
'draw string 4.92 0.55 6'
'draw string 5.52 0.55 7'
'draw string 6.12 0.55 8'
'draw string 6.72 0.55 9'
'draw string 7.32 0.55 10'
'draw string 7.92 0.55 11'
'draw string 8.52 0.55 12'
'draw string 9.12 0.55 13'
'draw string 9.72 0.55 14'
'draw string 10.32 0.55 15'
'set vpage 0.0 11.0 0.0 8.5'                    
'draw title Percentage Excessive Outliers of That Expected \ for 'titreg' 500 mb Height Talagrand Distribution\Average For 'ts' - 'te''
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_pac_3lines 8.6 1.0 10.1 2.2'

'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

'set display color white'
'clear'
grfile=''greg'500h_tg-1_die.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.0'                    
'set grads off'
'set xlab  off'
'set x 2 16'
'set z 1'   
'set t 1'

if (reg=1)
 var1='tg4'
 var2='tg10'
 var3='tg16'
endif
if (reg=2)
 var1='tg5'
 var2='tg11'
 var3='tg17'
endif

'set y 1'       
'define ta=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tc=ave('var2'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define te=ave('var2'.3,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'set y 4'       
'define tb=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define td=ave('var2'.2,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)
'define tf=ave('var2'.3,time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set t 1'
'set vrange -8. 8.'           
'set ccolor 1'
'set cmark 1'
'd (ta + tb - 200/11)'
'set ccolor 2'
'set cmark 2'
'd (tc + td - 200/11)'
'set ccolor 3'
'set cmark 3'
'd (te + tf - 200/11)'
'draw xlab Forecast days'
'draw ylab Percentage above/below zero (T-1)'
'draw string 1.92 0.55 1'
'draw string 2.52 0.55 2'
'draw string 3.12 0.55 3'
'draw string 3.72 0.55 4'
'draw string 4.32 0.55 5'
'draw string 4.92 0.55 6'
'draw string 5.52 0.55 7'
'draw string 6.12 0.55 8'
'draw string 6.72 0.55 9'
'draw string 7.32 0.55 10'
'draw string 7.92 0.55 11'
'draw string 8.52 0.55 12'
'draw string 9.12 0.55 13'
'draw string 9.72 0.55 14'
'draw string 10.32 0.55 15'
'set vpage 0.0 11.0 0.0 8.5'
'draw title Percentage Excessive Outliers of That Expected \ for 'titreg' 500 mb Height Talagrand Distribution\Average For 'ts' - 'te''
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_pac_3lines 8.6 1.0 10.1 2.2'

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
