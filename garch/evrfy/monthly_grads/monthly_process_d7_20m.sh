
set -x

>monthly.dat
jump=1

#if [ $jump -eq 1 ]; then
for yyyy in 2009
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 if [ $mm -eq 12 ]; then
  ntyr=`expr $yyyy + 1`
  ntmt=01
 else
  ntyr=$yyyy
  ntmt=`expr $mm + 1`
  if [ $ntmt -le 9 ]; then
  ntmt=0$ntmt
  fi
 fi
 dom=`grep "$mm" $home/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_d7_20m.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2010
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 if [ $mm -eq 12 ]; then
  ntyr=`expr $yyyy + 1`
  ntmt=01
 else
  ntyr=$yyyy
  ntmt=`expr $mm + 1`
  if [ $ntmt -le 9 ]; then
  ntmt=0$ntmt
  fi
 fi
 dom=`grep "$mm" $home/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_d7_20m.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2011
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 if [ $mm -eq 12 ]; then
  ntyr=`expr $yyyy + 1`
  ntmt=01
 else
  ntyr=$yyyy
  ntmt=`expr $mm + 1`
  if [ $ntmt -le 9 ]; then
  ntmt=0$ntmt
  fi
 fi
 dom=`grep "$mm" $home/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_d7_20m.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2012
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 if [ $mm -eq 12 ]; then
  ntyr=`expr $yyyy + 1`
  ntmt=01
 else
  ntyr=$yyyy
  ntmt=`expr $mm + 1`
  if [ $ntmt -le 9 ]; then
  ntmt=0$ntmt
  fi
 fi
 dom=`grep "$mm" $home/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_d7_20m.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2013
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 if [ $mm -eq 12 ]; then
  ntyr=`expr $yyyy + 1`
  ntmt=01
 else
  ntyr=$yyyy
  ntmt=`expr $mm + 1`
  if [ $ntmt -le 9 ]; then
  ntmt=0$ntmt
  fi
 fi
 dom=`grep "$mm" $home/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_d7_20m.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2014
do
 for mm in 01 02 03 04 05
 do

 echo " We are processing the month of $mm and year of $yyyy"
 if [ $mm -eq 12 ]; then
  ntyr=`expr $yyyy + 1`
  ntmt=01
 else
  ntyr=$yyyy
  ntmt=`expr $mm + 1`
  if [ $ntmt -le 9 ]; then
  ntmt=0$ntmt
  fi
 fi
 dom=`grep "$mm" $home/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_d7_20m.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

awk -f awk.c monthly.dat >monthly_g.dat

rm monthly_grads.dat

monthly_grads

mv monthly_grads.dat monthly_grads_d7.dat
