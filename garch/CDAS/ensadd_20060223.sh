
nhoursx=/nfsuser/g01/wx20yz/bin/ndate
#set -x

for mm in 01 02 03 04 05 06 07 08 09 10 11 12
do

 DD=`grep $mm /nfsuser/g01/wx20yz/bin/mon2mon | cut -c12-13`

 dd=01
 if [ $mm -eq 02 ]; then
  DD=29
 fi

 while [ $dd -le $DD ]; do

   CDATE=1959$mm$dd\00
   echo "adding message to cmean_1d.1959$mm$dd "
   $HOME/bin/ensadd_new.sh 1 2 7 cmean_1d.1959$mm$dd cmean_1di.1959$mm$dd cmean_1dn.1959$mm$dd
   mv cmean_1dn.1959$mm$dd cmean_1d.1959$mm$dd
   rm cmean_1di.1959$mm$dd
   echo "adding message to cstdv_1d.1959$mm$dd "
   $HOME/bin/ensadd_new.sh 1 2 8 cstdv_1d.1959$mm$dd cstdv_1di.1959$mm$dd cstdv_1dn.1959$mm$dd
   mv cstdv_1dn.1959$mm$dd cstdv_1d.1959$mm$dd
   rm cstdv_1di.1959$mm$dd

  dd=`expr $dd + 1 `

  if [ $dd -le 9 ]; then
   dd=0$dd
  fi   

 done

done
