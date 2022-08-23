
set +x

>monthly.dat
for yyyy in 1996
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 dom=`grep "$mm" $SHOME/$LOGNAME/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\01
 export EDYMD=$yyyy$mm$dom 

 echo $yyyy$mm `RUN_4_GRADS.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

awk -f awk_pac_NH500Z.c monthly.dat >NH500Z_pac_$yyyy.dat
awk -f awk_pac_SH500Z.c monthly.dat >SH500Z_pac_$yyyy.dat
awk -f awk_rms_NH500Z.c monthly.dat >NH500Z_rms_$yyyy.dat
awk -f awk_rms_SH500Z.c monthly.dat >SH500Z_rms_$yyyy.dat

awk -f awk_rms_TR850U.c monthly.dat >TR850U_rms_$yyyy.dat
awk -f awk_rms_TR850V.c monthly.dat >TR850V_rms_$yyyy.dat
awk -f awk_rms_TR850S.c monthly.dat >TR850S_rms_$yyyy.dat
awk -f awk_rms_TR850R.c monthly.dat >TR850R_rms_$yyyy.dat

awk -f awk_rms_TR200U.c monthly.dat >TR200U_rms_$yyyy.dat
awk -f awk_rms_TR200V.c monthly.dat >TR200V_rms_$yyyy.dat
awk -f awk_rms_TR200S.c monthly.dat >TR200S_rms_$yyyy.dat
awk -f awk_rms_TR200R.c monthly.dat >TR200R_rms_$yyyy.dat

#rm monthly_grads.dat
#
#monthly_grads_3-5-7
