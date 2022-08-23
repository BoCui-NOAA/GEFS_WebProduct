ts=CSTYMD           
te=CEDYMD       

'open prEXPID1.ctl'

'set display color white'
'clear'

regs=1
rege=2
reg=regs
while (reg<=rege)
titreg=getreg(reg)
greg=getgreg(reg)

grfile='/ptmp/wx20yz/grads/'greg'500h.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 11.0 0.0 8.5'                    
'set grads off'
'set xlab  off'
'set x 7 17'
'set z 1'   
'set t 1'

if (reg=1)
 var1='ac1'
 var2='ac2'
 var3='ac7'
 rms1='rm1'
 rms2='rm2'
 rms3='rm7'
endif
if (reg=2)
 var1='ac14'
 var2='ac15'
 var3='ac20'
 rms1='rm14'
 rms2='rm15'
 rms3='rm20'
endif

'set y 4'       
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

'set y 1'
'define ra=ave('rms1',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'define rb=ave('rms2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'define rc=ave('rms3',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set vpage 0.0 5.0 0.0 4.5'
'set grads off'
'set t 1'
'set y 4'
'set vrange 20. 100'           
'set ccolor 1'
'set cmark 1'
'd ra'
'set ccolor 2'
'set cmark 2'
'd rb'
'draw xlab Forecast days'
'draw ylab RMS error'
'draw string 1.95 0.55 3'
'draw string 3.33 0.55 4'
'draw string 4.71 0.55 5'
'draw string 6.09 0.55 6'
'draw string 7.47 0.55 7'
'draw string 8.85 0.55 8'

'set vpage 0.0 5.0 4.0 8.5'
'set grads off'
'set t 1'
'set y 1'
'set vrange 0.45 0.95'          
'set ccolor 1'
'set cmark 1'
'd ta'
'set ccolor 2'
'set cmark 2'
'd tb'
'draw title 'titreg' 500 mb Height \ Average For 'ts' - 'te''
'draw ylab AC scores'
'draw string 1.95 0.55 3'
'draw string 3.33 0.55 4'
'draw string 4.71 0.55 5'
'draw string 6.09 0.55 6'
'draw string 7.47 0.55 7'
'draw string 8.85 0.55 8'
'run /nfsuser/g01/wx20yz/grads/linesmpos.gs leg_2lines 1.3 4.8 2.3 5.6'

istday=3
iedday=7 
while (istday <= iedday)
iday=istday*2+1

if (reg=1)
 var1='ac1'
 var2='ac2'
 var3='ac7'
endif
if (reg=2)
 var1='ac14'
 var2='ac15'
 var3='ac20'
endif

'set x 'iday
'set y 4'
'set z 1'

'set t 1'
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
vr1=getrang1(istday)
vr2=getrang2(istday)

'set vpage 4.2 11 'vr1' 'vr2''
'set grads off'
'set xlab on'
'set time 'ts' 'te
'set vrange 'ymin' 'ymax
'set ccolor 1'
'd 'var1''
'set ccolor 2'
'd 'var2''
*'draw title 'titreg' 500 mb Z at day 'istday' for 'ts' - 'te' '
'draw ylab AC scores'
'draw xlab 'istday'-day forecast'

'set strsiz 0.12'
'set string 1 tl 6'
'draw string 9.0 1.7 MRF='pranh500
'set string 2 tl 6'
'draw string 9.0 1.4 CTL='prbnh500

istday=istday+2
endwhile

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
function getmax(iday)
if(iday=1);ymax=1.3;endif;
if(iday=2);ymax=1.2;endif;
if(iday=3);ymax=1.0;endif;
if(iday=4);ymax=1.0;endif;
if(iday=5);ymax=1.0;endif;
if(iday=6);ymax=1.0;endif;
if(iday=7);ymax=0.9;endif;
if(iday=8);ymax=0.9;endif;
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
if(iday=3);ymin=0.7;endif;
if(iday=4);ymin=0.5;endif;
if(iday=5);ymin=0.4;endif;
if(iday=6);ymin=0.2;endif;
if(iday=7);ymin=0.2;endif;
if(iday=8);ymin=-0.1;endif;
if(iday=9);ymin=-0.2;endif;
if(iday=10);ymin=-0.3;endif;
if(iday=11);ymin=0.0;endif;
if(iday=12);ymin=0.0;endif;
if(iday=13);ymin=0.0;endif;
if(iday=14);ymin=0.0;endif;
if(iday=15);ymin=0.0;endif;
return ymin
function getrang1(iday)
if(iday=3);vr1=5.4;endif;
if(iday=5);vr1=2.7;endif;
if(iday=7);vr1=0.0;endif;
return vr1   
function getrang2(iday)
if(iday=3);vr2=8.5;endif;
if(iday=5);vr2=5.8;endif;
if(iday=7);vr2=3.1;endif;
return vr2   

