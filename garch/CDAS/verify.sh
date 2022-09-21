
nhoursx=/nfsuser/g01/wx20yz/bin/ndate
#set -x

for mm in 01 02 03 04 05 06 07 08 09 10 11 12
do

 DD=`grep $mm /nfsuser/g01/wx20yz/bin/mon2mon | cut -c12-13`

 dd=01

 while [ $dd -le $DD ]; do

   CDATE=1959$mm$dd\00
   MDH=`echo $CDATE | cut -c3-10`
   MDHm6=`$nhoursx -06 $CDATE | cut -c3-10`
  
   RC=`wgrib cmean_1d.1959$mm$dd | wc -l`
   echo "cmean_1d.1959$mm$dd (records) = $RC"
   RC=`wgrib cstdv_1d.1959$mm$dd | wc -l`
   echo "cstdv_1d.1959$mm$dd (records) = $RC"

  dd=`expr $dd + 1 `

  if [ $dd -le 9 ]; then
   dd=0$dd
  fi   

 done

done
