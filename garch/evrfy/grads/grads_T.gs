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

grfile='/ptmp/wx20yz/grads/'greg'500h_tg.gr'
say grfile
'enable print 'grfile
'reset'
'set vpage 0.0 8.5 0.0 11.0'                    
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

'set x 1 11'       

'set y 3'
'define ta=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 7'
'define tb=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 11'
'define tc=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 17'
'define td=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set y 31'
'define te=ave('var2',time='ts',time='te')'
say result
line=sublin(result,1)
word=subwrd(line,4)

'set t 1'
'set vpage 0.0 8.5 8.2 11.0'
'set gxout bar'
'set grads off'
'set bargap 40'
'set vrange 0. 34.'           
'set ccolor 1'
'd ta'                   
'draw ylab Percentage'
'draw string 3.5 1.5 '1 day''
*'set vpage 0.0 8.5 0.0 11.0'                    
'draw title Talagrand Distribution ('titreg' 500mb Z)\ for 'ts'-'te'' 

'set vpage 0.0 8.5 6.2 9.0'
'set gxout bar'
'set grads off'
'set bargap 40'
'set vrange 0. 34.'           
'set ccolor 2'
'd tb'                   
'draw ylab Percentage'
'draw string 3.5 1.5 '3 days''

'set vpage 0.0 8.5 4.2 7.0'
'set gxout bar'
'set grads off'
'set bargap 40'
'set vrange 0. 34.'           
'set ccolor 3'
'd tc'                   
'draw ylab Percentage'
'draw string 3.5 1.5 '5 days''

'set vpage 0.0 8.5 2,2 5.0'
'set gxout bar'
'set grads off'
'set bargap 40'
'set vrange 0. 34.'           
'set ccolor 4'
'd td'                   
'draw ylab Percentage'
'draw string 3.5 1.5 '8 days''

'set vpage 0.0 8.5 0.2 3.0'
'set gxout bar'
'set grads off'
'set bargap 40'
'set vrange 0. 34.'           
'set ccolor 5'
'd te'                   
'draw xlab 10 members at T00Z'
'draw ylab Percentage'
'draw string 3.5 1.5 '15 days''


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
