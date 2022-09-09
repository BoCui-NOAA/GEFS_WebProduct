
if [ $# -lt 2 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
   echo "2). FHR (forecast hours)     "
   exit 8
fi

tmpdir=/ptmp/wx20yz/cweights
mkdir $tmpdir
cd    $tmpdir

nhoursx=/nwprod/util/exec/ndate

CDATE=$1             
fhr=$2
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`

echo " ***************************************"
echo " JOB INPUT INITIAL  TIME IS: $CDATE "
echo " JOB INPUT FORECAST TIME IS: $fhr   "
echo " ***************************************"

for FHR in $fhr 
do

 FDATE=`$nhoursx +$FHR $CDATE`
 HH=`echo $FDATE | cut -c9-10`
 MDH=`echo $FDATE | cut -c5-10`         
 MD=`echo $FDATE | cut -c5-8`         
 #members=15
 members=32

 for ens in c00 p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14
 do

 #cp /com/mrf/prod/ens.$YMD/ens${ens}.t${CYC}z.pgrbf${FHR} fcst_$ens.dat
 cp /com/gens/para/gefs.$YMD/${CYC}/pgrba/ge${ens}.t${CYC}z.pgrbaf${FHR} fcst_$ens.dat

 {
 echo "&namin " >input_$ens
 echo "cfcst='fcst_$ens.dat'," >>input_$ens
 echo "cwght='wght_$ens.dat'," >>input_$ens
 echo "members=$members," >>input_$ens
 echo "/" >>input_$ens

 $HOME/reanl/exec/weights.exe <input_$ens >output_$ens

 mv wght_$ens.dat ge${ens}.t${CYC}z.pgrb_wtf${FHR}
 } &  

 done

 wait

 rm fcst_*.dat 

 cat output_$ens

 ls -l ge*.t${CYC}z.pgrb_wtf${FHR}

done

