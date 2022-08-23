*
'open A_AMOUNT.t_ICz.pqrf.ctl'
'open A_AMOUNT.t_ICz.pqsf.ctl'
'open A_AMOUNT.t_ICz.pqif.ctl'
'open A_AMOUNT.t_ICz.pqff.ctl'
'open A_AMOUNT.t_ICz.pqpf.ctl'

*'run $SHOME/$LOGNAME/grads/rgbset.gs'
'run rgbset.gs'
'set lon 210 310'
'set lat 10 65'
'set mproj nps'
'set mpvals -120 -75 20 55'
'set gxout shaded'
'set mpdset mres'

istime=7
*ietime=25 
ietime=361

while (istime<=ietime)

'set display color white'
'clear'

'set clopts 1 1 0.12'

'set t 'istime''
tm1=istime-7
tm2=istime-1
ist=1
ied=4
'enable print a_AMOUNT__CDATE_F'tm1'-'tm2'.gr'

while (ist<=ied)

 if (ist=1)
 'set vpage 0.5 5.5 3.8 7.6'
 itp=total
 endif
 if (ist=2)
 'set vpage 5.5 10.5 3.8 7.6'
 itp=rain
 endif
 if (ist=3)
 'set vpage 0.5 5.5 0.1 3.9'
 itp=snow
 endif
 if (ist=4)
 'set vpage 5.5 10.5 0.1 3.9'
 itp='freezing + ice pellets'
 endif

 'set grads off'
 'set gxout shaded'
* 'set clevs  0   5   20  35   50   65   80   95'
* 'set ccols  0   21  22  23   31   33   35   37   39'
 if (ist=1)
*'set display grey white'
 'set display color white'
 'set gxout shaded'
 'set clevs  0   5   20  35  50  65  80  95'
 'set ccols  0   72  73  74  75  76  77  78  79'
* good grep scale for grads display, but not converted
* 'set ccols  0   9   14  11  15  13  10  12  8 '
 'd probsfc.5'
 endif
 if (ist=2)
'set display color white'
 'set gxout shaded'
 'set clevs  0   5   20  35  50  65  80  95'
 'set ccols  0   32  33  34  35  36  37  38  39'
 'd probsfc.1'
 endif
 if (ist=3)
 'set gxout shaded'
 'set clevs  0   5   20  35  50  65  80  95'
 'set ccols  0   41  42  43  44  45  46  47  48'
 'd probsfc.2'
 endif
 if (ist=4)
 'set gxout shaded'
 'set clevs  0   5   20  35  50  65  80  95'
 'set ccols  0   22  23  24  25  26  27  28  29'
 'd (probsfc.3 + probsfc.4)'
 endif
 'set gxout contour'
 'set cthick 2'
 'set ccolor 1'
*'set clevs  0  5  20  35   50   65   80   95'
 'set clevs  0  35   65  95'
 if (ist=1)
 'd probsfc.5'
 endif
 if (ist=2)
 'd probsfc.1'
 endif
 if (ist=3)
 'd probsfc.2'
 endif
 if (ist=4)
 'd (probsfc.3 + probsfc.4)'
 endif
 'draw title 'tm1'-'tm2' hours ('itp')'
*'run $SHOME/$LOGNAME/grads/cbar.gs'
 'run cbar.gs'
 ist=ist+1

endwhile

***

ymdh2=getmax(tm2)
ymdh1=getmax(tm1)

'set vpage 0.0 11.0 0.0 8.5'
'draw title Ensemble Based Probabilistic Quantitative Precipitation Type Forecast \ Ini:_CDATE Valid:'ymdh1'-'ymdh2' Amount>=_AMTmm/6hrs'
'print'
'printim a_AMOUNT__CDATE_F'tm1'-'tm2'.png x1000 y780 png'
*'printim a_AMOUNT__CDATE_F'tm1'-'tm2'.png x1100 y850 png'
*'printim a_AMOUNT__CDATE_F'tm1'-'tm2'.png x695 y545 png'
'disable print a_AMOUNT__CDATE_F'tm1'-'tm2'.gr'

istime=istime+6

*say 'type in c to continue or quit to exit'
*pull corquit
*corquit

endwhile

'quit'

function getmax(tm)
if(tm=0);ymdh=_YMDH0;endif;
if(tm=6);ymdh=_YMDH6;endif;
if(tm=12);ymdh=_YMDH12;endif;
if(tm=18);ymdh=_YMDH18;endif;
if(tm=24);ymdh=_YMDH24;endif;
if(tm=30);ymdh=_YMDH30;endif;
if(tm=36);ymdh=_YMDH36;endif;
if(tm=42);ymdh=_YMDH42;endif;
if(tm=48);ymdh=_YMDH48;endif;
if(tm=54);ymdh=_YMDH54;endif;
if(tm=60);ymdh=_YMDH60;endif;

if(tm=66);ymdh=_YMDH66;endif;
if(tm=72);ymdh=_YMDH72;endif;
if(tm=78);ymdh=_YMDH78;endif;
if(tm=84);ymdh=_YMDH84;endif;
if(tm=90);ymdh=_YMDH90;endif;
if(tm=96);ymdh=_YMDH96;endif;
if(tm=102);ymdh=_YMDH102;endif;
if(tm=108);ymdh=_YMDH108;endif;
if(tm=114);ymdh=_YMDH114;endif;
if(tm=120);ymdh=_YMDH120;endif;

if(tm=126);ymdh=_YMDH126;endif;
if(tm=132);ymdh=_YMDH132;endif;
if(tm=138);ymdh=_YMDH138;endif;
if(tm=144);ymdh=_YMDH144;endif;
if(tm=150);ymdh=_YMDH150;endif;
if(tm=156);ymdh=_YMDH156;endif;
if(tm=162);ymdh=_YMDH162;endif;
if(tm=168);ymdh=_YMDH168;endif;
if(tm=174);ymdh=_YMDH174;endif;
if(tm=180);ymdh=_YMDH180;endif;

if(tm=186);ymdh=_YMDH186;endif;
if(tm=192);ymdh=_YMDH192;endif;
if(tm=198);ymdh=_YMDH198;endif;
if(tm=204);ymdh=_YMDH204;endif;
if(tm=210);ymdh=_YMDH210;endif;
if(tm=216);ymdh=_YMDH216;endif;
if(tm=222);ymdh=_YMDH222;endif;
if(tm=228);ymdh=_YMDH228;endif;
if(tm=234);ymdh=_YMDH234;endif;
if(tm=240);ymdh=_YMDH240;endif;

if(tm=246);ymdh=_YMDH246;endif;
if(tm=252);ymdh=_YMDH252;endif;
if(tm=258);ymdh=_YMDH258;endif;
if(tm=264);ymdh=_YMDH264;endif;
if(tm=270);ymdh=_YMDH270;endif;
if(tm=276);ymdh=_YMDH276;endif;
if(tm=282);ymdh=_YMDH282;endif;
if(tm=288);ymdh=_YMDH288;endif;
if(tm=294);ymdh=_YMDH294;endif;
if(tm=300);ymdh=_YMDH300;endif;

if(tm=306);ymdh=_YMDH306;endif;
if(tm=312);ymdh=_YMDH312;endif;
if(tm=318);ymdh=_YMDH318;endif;
if(tm=324);ymdh=_YMDH324;endif;
if(tm=330);ymdh=_YMDH330;endif;
if(tm=336);ymdh=_YMDH336;endif;
if(tm=342);ymdh=_YMDH342;endif;
if(tm=348);ymdh=_YMDH348;endif;
if(tm=354);ymdh=_YMDH354;endif;
if(tm=360);ymdh=_YMDH360;endif;
return ymdh
