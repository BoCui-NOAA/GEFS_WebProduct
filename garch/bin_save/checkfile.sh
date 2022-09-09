#!/bin/sh
set -x

export SGLOBAL=/global/shared/stat    
export SHOME=/global/save    
export CHOME=/climate/save    

 echo `date`
 CDATE=$(date +%Y%m%d)00
 CDATEM1=` /nwprod/util/exec/ndate -24 $CDATE`
 CDATEM2=` /nwprod/util/exec/ndate -48 $CDATE`
 DAY=`echo ${CDATE} | cut -c 1-8`
 DAYM1=`echo ${CDATEM1} | cut -c 1-8`
 DAYM2=`echo ${CDATEM2} | cut -c 1-8`

rm checkfile.log

for exp in cmc ecm fno ; do

   file1=${SGLOBAL}/${exp}/pgbf00.${DAY}00 
   file2=${SGLOBAL}/${exp}/pgbf00.${DAYM1}12 

  for file in $file1 $file2; do
   ls $file 
   if [ $? -ne 0 ]; then
     echo " $file is missing " >>checkfile.log
   fi
  done
done

for exp in pra prs ; do
   file1=${SGLOBAL}/${exp}/pgbf00.${DAY}00
   file2=${SGLOBAL}/${exp}/pgbf00.${DAYM1}06
   file3=${SGLOBAL}/${exp}/pgbf00.${DAYM1}12
   file4=${SGLOBAL}/${exp}/pgbf00.${DAYM1}18
  for file in $file1 $file2 $file3 $file4 ; do
   ls $file 
   if [ $? -ne 0 ]; then
     echo " $file is missing " >>checkfile.log
   fi
  done
done

for exp in pra ; do
   file1=${SGLOBAL}/${exp}/PGBf00.${DAY}00
   file2=${SGLOBAL}/${exp}/PGBf00.${DAYM1}12
  for file in $file1 $file2 $file3 $file4 ; do
   ls $file 
   if [ $? -ne 0 ]; then
     echo " $file is missing " >>checkfile.log
   fi
  done
done

#-------UKMET data
   file1=${SGLOBAL}/prk/ukmet.${DAY}00
   file2=${SGLOBAL}/prk/ukmet.${DAYM1}12
  for file in $file1 $file2 ; do
   ls $file 
   if [ $? -ne 0 ]; then
     echo " $file is missing " >>checkfile.log
   fi
  done

#-------CDAS data
   file=${SGLOBAL}/prc/pgbf00.${DAYM2}00
   ls $file 
   if [ $? -ne 0 ]; then
     echo " $file is missing " >>checkfile.log
   fi


#-----send mail to $LOGNAME if data are missing
if [ -s checkfile.log ]; then
mail -s "CIRRUS missing global archive data for $DAY" fanglin.yang@noaa.gov <checkfile.log
mv checkfile.log  $CHOME/$LOGNAME/checkfile.log${DAY}
fi

exit



