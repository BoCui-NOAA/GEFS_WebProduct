
set +x

>monthly.dat
for yyyy in 2000
do
 for mm in 05 06 07 08 09 10 11 12 
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
 dom=`grep "$mm" /nfsuser/g01/wx20yz/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_3-5-7.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2001
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
 dom=`grep "$mm" /nfsuser/g01/wx20yz/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_3-5-7.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2002
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
 dom=`grep "$mm" /nfsuser/g01/wx20yz/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_3-5-7.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2003
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
 dom=`grep "$mm" /nfsuser/g01/wx20yz/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_3-5-7.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done

for yyyy in 2004
do
 for mm in 01 02 03 04 05 06 07 08 09 10
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
 dom=`grep "$mm" /nfsuser/g01/wx20yz/bin/mon2mon | awk '{print $4}'`
 export STYMD=$yyyy$mm\05
 export EDYMD=$ntyr$ntmt\05

 echo $yyyy$mm `RUN_4_GRADS_3-5-7.sh | grep "Result value" | awk '{print $4}'` >>monthly.dat

 done
done


awk -f awk_3-5-7.c monthly.dat >monthly_g.dat


rm monthly_grads.dat

monthly_grads_3-5-7
