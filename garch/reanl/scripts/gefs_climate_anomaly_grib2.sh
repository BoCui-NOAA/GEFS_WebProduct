########################################
# Script: gefs_climate_anomaly.sh 
# ABSTRACT:  This script produces GRIB
#  files of climate anomaly forecast
########################################

if [ $# -lt 2 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
   echo "2). FHR (forecast hours)     "
   exit 8
fi

set +x
echo " "
echo " Entering sub script climate_anomaly.sh"
echo " iob input initial time is: $CDATE=$1 "
echo " job input forecast time is: $fhr=$2   "
echo " "
set -x

mkdir /ptmp/wx20yz/anom_grib2
cd    /ptmp/wx20yz/anom_grib2

CDATE=$1             
fhr=$2

YMD=`echo $CDATE | cut -c1-8`
PDY=`echo $CDATE | cut -c1-8`
cyc=`echo $CDATE | cut -c9-10`

export EXECUTIL=/nwprod/util/exec
export NDATE=$EXECUTIL/ndate
export FIXGEFS=/nwprod/fix
export COM=/com/gens/prod
export EXECGEFS=/global/save/wx20yz/grib2/gefs_climate_anomaly.fd

ymdh=${PDY}${cyc}
export PDYm1=`$NDATE -24  $ymdh | cut -c1-8`
export PDYm2=`$NDATE -48  $ymdh | cut -c1-8`
export PDYm3=`$NDATE -72  $ymdh | cut -c1-8`
export PDYm4=`$NDATE -96  $ymdh | cut -c1-8`
export PDYm5=`$NDATE -120 $ymdh | cut -c1-8`
export PDYm6=`$NDATE -144 $ymdh | cut -c1-8`
export PDYm7=`$NDATE -168 $ymdh | cut -c1-8`
export PDYm8=`$NDATE -192 $ymdh | cut -c1-8`
export PDYm9=`$NDATE -216 $ymdh | cut -c1-8`
export PDYm10=`$NDATE -240 $ymdh | cut -c1-8`
export PDYm11=`$NDATE -264 $ymdh | cut -c1-8`
export PDYm12=`$NDATE -288 $ymdh | cut -c1-8`
export PDYm13=`$NDATE -312 $ymdh | cut -c1-8`
export PDYm14=`$NDATE -336 $ymdh | cut -c1-8`
export PDYm15=`$NDATE -360 $ymdh | cut -c1-8`
export PDYm16=`$NDATE -384 $ymdh | cut -c1-8`
export PDYm17=`$NDATE -408 $ymdh | cut -c1-8`
export PDYm18=`$NDATE -432 $ymdh | cut -c1-8`

###
########################################
# define the time that the bias between CDAS and GDAS available: $BDATE
########################################
###

for FHR in $fhr 
do

 FDATE=`$NDATE +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MD=`echo $FDATE | cut -c5-8`         

 #for ens in $MEMLIST                                         
 for ens in p01                                               
 do

 ln -fs /ptmp/wx20yz/anom_grib2/ge${ens}.t${cyc}z.pgrb2a_bcf${FHR} fcst_$ens.dat
 ln -fs $FIXGEFS/cmean_1d.1959$MD mean_$ens.dat
 ln -fs $FIXGEFS/cstdv_1d.1959$MD stdv_$ens.dat

 ### get analysis difference between CDAS and GDAS
 ### note: "cyc" will be defined by forecast valid time - Yuejian Zhu

 bcyc=`expr $cyc + $FHR`

 while [ $bcyc -ge 24 ]; do
  (( bcyc -= 24 ))
 done

 if [ $bcyc -eq 0 ]; then
  bcyc=00
 fi       

 ### set ifbias=0 as default, bias information available
 ifbias=0
 if [ -s $COM/gefs.${PDYm2}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 ]; then
   ln -fs $COM/gefs.${PDYm2}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 bias_$ens.dat

 elif [ -s $COM/gefs.${PDYm3}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 ]; then
   ln -fs $COM/gefs.${PDYm3}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 bias_$ens.dat

 elif [ -s $COM/gefs.${PDYm4}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 ]; then
   ln -fs $COM/gefs.${PDYm4}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 bias_$ens.dat

 elif [ -s $COM/gefs.${PDYm5}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 ]; then
   ln -fs $COM/gefs.${PDYm5}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 bias_$ens.dat

 elif [ -s $COM/gefs.${PDYm6}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 ]; then
   ln -fs $COM/gefs.${PDYm6}/${bcyc}/pgrba/glbanl.t${bcyc}z.pgrba_mdf00 bias_$ens.dat

 else
   ifbias=1
 fi

 echo "&namin " >input_$ens
 echo "cfcst='fcst_$ens.dat'," >>input_$ens
 echo "cmean='mean_$ens.dat'," >>input_$ens
 echo "cstdv='stdv_$ens.dat'," >>input_$ens
 echo "cbias='bias_$ens.dat'," >>input_$ens
 echo "canom='anom_$ens.dat'," >>input_$ens
 echo "ibias=$ifbias," >>input_$ens
 echo "/" >>input_$ens

 export pgm=gefs_climate_anomaly_${ens}_${FHR}
 #startmsg
 $EXECGEFS/gefs_climate_anomaly <input_$ens >output_$ens.$FHR
 #export err=$?;err_chk

 mv anom_$ens.dat ge${ens}.t${cyc}z.pgrb2a_anf${FHR}

 done

 rm fcst_*.dat mean_*.dat stdv_*.dat

#cat output_$ens.$FHR

# ls -l ge*.t${cyc}z.pgrba_anf${FHR}

done

set +x
echo " "
echo "Leaving sub script climate_anomaly.sh"
echo " "
set -x

