#!/bin/ksh

s=$SHOME/yan.luo/web_glb_js
cd $s/base

TODAY=`date +%Y%m%d`
Y=`date +%Y`
M=`date +%b`
D=`date +%d`
H=09

PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -24 $TODAY$H`
PAST1=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -48 $TODAY$H`
PAST2=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -72 $TODAY$H`
PAST3=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -96 $TODAY$H`
PAST4=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -120 $TODAY$H`
PAST5=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -144 $TODAY$H`
PAST6=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -168 $TODAY$H`
PAST7=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -192 $TODAY$H`
PAST8=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -216 $TODAY$H`
PAST9=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -240 $TODAY$H`
PAST10=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -264 $TODAY$H`
PAST11=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -288 $TODAY$H`
PAST12=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -312 $TODAY$H`
PAST13=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -336 $TODAY$H`
PAST14=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -360 $TODAY$H`
PAST15=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -384 $TODAY$H`
PAST16=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -408 $TODAY$H`
PAST17=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -432 $TODAY$H`
PAST18=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -456 $TODAY$H`
PAST19=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -480 $TODAY$H`
PAST20=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -504 $TODAY$H`
PAST21=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -528 $TODAY$H`
PAST22=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -552 $TODAY$H`
PAST23=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -576 $TODAY$H`
PAST24=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -600 $TODAY$H`
PAST25=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -624 $TODAY$H`
PAST26=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -648 $TODAY$H`
PAST27=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -672 $TODAY$H`
PAST28=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -696 $TODAY$H`
PAST29=`echo ${PAST} | cut -c 1-8`
PAST=` /apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate -720 $TODAY$H`
PAST30=`echo ${PAST} | cut -c 1-8`




echo $TODAY $PAST1 $PAST2 $PAST3 $PAST4 $PAST5 $PAST6 $PAST7 $PAST8 $PAST9 $PAST10 $PAST11 $PAST12 $PAST13 $PAST14 $PAST15 $PAST16 $PAST17 $PAST18 $PAST19 $PAST20 $PAST21 $PAST22 $PAST23 $PAST24 $PAST25 $PAST26 $PAST27 $PAST28  $PAST29  $PAST30

echo 'path='$s

sed -e "s!YYYYMMDD!$TODAY!g" -e "s!PASTDAY1 !$PAST1!g" -e "s!PASTDAY2 !$PAST2!g" -e "s!PASTDAY3 !$PAST3!g" -e "s!PASTDAY4 !$PAST4!g" -e "s!PASTDAY5 !$PAST5!g" -e "s!PASTDAY6 !$PAST6!g" -e "s!PASTDAY7 !$PAST7!g" -e "s!PASTDAY8!$PAST8!g" -e "s!PASTDAY9!$PAST9!g" -e "s!PASTDAY10!$PAST10!g"  -e "s!PASTDAY11!$PAST11!g" -e "s!PASTDAY12!$PAST12!g" -e "s!PASTDAY13!$PAST13!g" -e "s!PASTDAY14!$PAST14!g" -e "s!PASTDAY15!$PAST15!g" -e "s!PASTDAY16!$PAST16!g" -e "s!PASTDAY17!$PAST17!g" -e "s!PASTDAY18!$PAST18!g" -e "s!PASTDAY19!$PAST19!g" -e "s!PASTDAY20!$PAST20!g" -e "s!PASTDAY21!$PAST21!g" -e "s!PASTDAY22!$PAST22!g" -e "s!PASTDAY23!$PAST23!g" -e "s!PASTDAY24!$PAST24!g" -e "s!PASTDAY25!$PAST25!g" -e "s!PASTDAY26!$PAST26!g" -e "s!PASTDAY27!$PAST27!g" -e "s!PASTDAY28!$PAST28!g" -e "s!PASTDAY29!$PAST29!g" -e "s!PASTDAY30!$PAST30!g" $s/base/pqpf_html.base > $s/html/pqpf_html.base.htm

sed -e "s!YYYYMMDD!$TODAY!g" -e "s!PASTDAY1 !$PAST1!g" -e "s!PASTDAY2 !$PAST2!g" -e "s!PASTDAY3 !$PAST3!g" -e "s!PASTDAY4 !$PAST4!g" -e "s!PASTDAY5 !$PAST5!g" -e "s!PASTDAY6 !$PAST6!g" -e "s!PASTDAY7 !$PAST7!g" -e "s!PASTDAY8!$PAST8!g" -e "s!PASTDAY9!$PAST9!g" -e "s!PASTDAY10!$PAST10!g"  -e "s!PASTDAY11!$PAST11!g" -e "s!PASTDAY12!$PAST12!g" -e "s!PASTDAY13!$PAST13!g" -e "s!PASTDAY14!$PAST14!g" -e "s!PASTDAY15!$PAST15!g" -e "s!PASTDAY16!$PAST16!g" -e "s!PASTDAY17!$PAST17!g" -e "s!PASTDAY18!$PAST18!g" -e "s!PASTDAY19!$PAST19!g" -e "s!PASTDAY20!$PAST20!g" -e "s!PASTDAY21!$PAST21!g" -e "s!PASTDAY22!$PAST22!g" -e "s!PASTDAY23!$PAST23!g" -e "s!PASTDAY24!$PAST24!g" -e "s!PASTDAY25!$PAST25!g" -e "s!PASTDAY26!$PAST26!g" -e "s!PASTDAY27!$PAST27!g" -e "s!PASTDAY28!$PAST28!g" -e "s!PASTDAY29!$PAST29!g" -e "s!PASTDAY30!$PAST30!g" $s/base/rmop_html.base > $s/html/rmop_html.base.htm

sed -e "s!YYYYMMDD!$TODAY!g" $s/base/get_html.sh.base > $s/base/get_html.sh
chmod +x $s/base/get_html.sh
$s/base/get_html.sh
/bin/rm $s/base/get_html.sh $s/html/pqpf_html.base.htm $s/html/rmop_html.base.htm

