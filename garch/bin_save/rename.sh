


stymd=971101
edymd=990228

while [ $stymd -le $edymd ]; do

ymd=$stymd
YMD=19$stymd

for RUNID in mrf t62 p10 p20 p30 p40 p50 p60 p70 p80 p90 \
 m01 m02 m04 m06 m08 m09 m11 m12 m15 m20 m25 m45
do

#if [ -s /global/rainarch/pqpf_$RUNID.$ymd\00 ]; then
#mv /global/rainarch/pqpf_$RUNID.$ymd\00 /global/rainarch/pqpf_$RUNID.$YMD\00
#echo "/global/rainarch/pqpf_$RUNID.$ymd to /global/rainarch/pqpf_$RUNID.$YMD"
#fi
if [ -s /global/rvrfy/rain_$RUNID.$ymd ]; then
mv /global/rvrfy/rain_$RUNID.$ymd /global/rvrfy/rain_$RUNID.$YMD
echo "move /global/rvrfy/rain_$RUNID.$ymd to /global/rvrfy/rain_$RUNID.$YMD"
fi

done

stymd=`/nwprod/util/exec/ndate +24 19$stymd\00 | cut -c3-8`

done
