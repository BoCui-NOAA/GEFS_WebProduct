
set +x

>monthly.dat
for yyyy in 1999
do
 for mm in 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2000
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2001
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2002
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2003
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2004
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12 
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2005
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2006
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2007
do
 for mm in 01 02 03 04 05 06 07 08 09 10 11 12
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done
for yyyy in 2008
do
 for mm in 01 02 03 04 05 06 07 08
 do

 echo " We are processing the month of $mm and year of $yyyy"
 fname=/global/noscrub/wx20yz/global/vfprob/PROB10s_avg.$yyyy$mm
 echo $yyyy$mm `cat $fname | sed -n "1211,1211 p" | cut -c35-65` >>monthly.dat

 done
done

#awk -f awk.c monthly.dat >monthly_g.dat

cp monthly.dat monthly_g.dat


rm monthly_grads.dat

monthly_grads
