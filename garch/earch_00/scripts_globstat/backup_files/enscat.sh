

### Script is updated by Yuejian Zhu (wd20yz)

### Export variables:
### DARCH----> Data archive directory
### FHOUR----> Forecasting hours
### RUN------> Which run it is.
### CYC------> Processing cycle ( 00 or 12 )
 
export TMPDIR DARCH FHOUR RUN CYC
echo "$TMPDIR $DARCH $FHOUR $RUN $CYC "

###
### Field definition
###  z1000 --- 11
###  z700  --- 12
###  z500  --- 13
###  z250  --- 14
###  u10m  --- 15
###  u850  --- 16
###  u500  --- 17
###  u250  --- 18
###  v10m  --- 19
###  v850  --- 20
###  v500  --- 21
###  v250  --- 22
###  t2m   --- 23
###  t850  --- 24
###  rh700 --- 25
###  precip--- 26
###  prmsl --- 27
###  tmax  --- 28
###  tmin  --- 29
###

for field in 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
do
   case $field in
     11) Field=z1000;echo $field;;
     12) Field=z700;echo $field;;
     13) Field=z500;echo $field;;
     14) Field=z250;echo $field;;
     15) Field=u10m;echo $field;;
     16) Field=u850;echo $field;;
     17) Field=u500;echo $field;;
     18) Field=u250;echo $field;;
     19) Field=v10m;echo $field;;
     20) Field=v850;echo $field;;
     21) Field=v500;echo $field;;
     22) Field=v250;echo $field;;
     23) Field=t2m;echo $field;;
     24) Field=t850;echo $field;;
     25) Field=rh700;echo $field;;
     26) Field=precip;echo $field;;
     27) Field=prmsl;echo $field;;
     28) Field=tmax;echo $field;;
     29) Field=tmin;echo $field;;
   esac
   if [ -s $TMPDIR/$RUN.f$FHOUR.$Field ]; then
      cat $TMPDIR/$RUN.f$FHOUR.$Field >> $DARCH/enspost.T${CYC}Z.$Field 
      echo" cat $TMPDIR/$RUN.f$FHOUR.$field >> $DARCH/enspost.T${CYC}Z.$Field "
      rm  $TMPDIR/$RUN.f$FHOUR.$Field
   else
      echo "$TMPDIR/$RUN.f$FHOUR.$Field is not found " 
   fi
done

