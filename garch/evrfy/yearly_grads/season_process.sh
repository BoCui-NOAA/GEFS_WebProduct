
set +x

#>season.dat

#for fdays in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
for fdays in 00
do

 export fdays=$fdays
 export FDAYS=`expr $fdays + 1`
 if [ $FDAYS -le 9 ]; then
  FDAYS=0$FDAYS
 fi

for yyyysea in         2000sum 2000fal 0001win \
               2001spr 2001sum 2001fal 0102win \
               2002spr 2002sum 2002fal 0203win \
               2003spr 2003sum 2003fal 0304win 
do
               
 echo " We are processing year and season of $yyyysea "
 season=`echo $yyyysea | cut -c5-7`
 if [ "$season" = "win" ]; then
  YR1=`echo $yyyysea | cut -c1-2`
  YR2=`echo $yyyysea | cut -c3-4`
  STYMD=20${YR1}12${FDAYS}
  EDYMD=20${YR2}03${FDAYS}
 elif [ "$season" = "spr" ]; then
  YEAR=`echo $yyyysea | cut -c1-4`
  STYMD=${YEAR}03${FDAYS}
  EDYMD=${YEAR}06${FDAYS}
 elif [ "$season" = "sum" ]; then
  YEAR=`echo $yyyysea | cut -c1-4`
  STYMD=${YEAR}06${FDAYS}
  EDYMD=${YEAR}09${FDAYS}
 elif [ "$season" = "fal" ]; then
  YEAR=`echo $yyyysea | cut -c1-4`
  STYMD=${YEAR}09${FDAYS}
  EDYMD=${YEAR}12${FDAYS}
 fi

 export STYMD=$STYMD
 export EDYMD=$EDYMD

 #dom=`grep "$mm" /nfsuser/g01/wx20yz/bin/mon2mon | awk '{print $4}'`
 echo $yyyysea `RUN_4_GRADS.sh | grep "Result value" | awk '{print $4}'` >>season.dat_test

done

done

#awk -f awk.c season.dat >season_g.dat


#rm season_grads.dat

#season_grads
