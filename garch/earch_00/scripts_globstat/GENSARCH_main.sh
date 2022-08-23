#/bin/sh
#BSUB -J GENSARCH_main.sh
#BSUB -o /ensemble/save/Yan.Luo/earch/scripts/GENSARCH_main.out
#BSUB -e /ensemble/save/Yan.Luo/earch/scripts/GENSARCH_main.err
#BSUB -q "dev"
#BSUB -b 11:00
#BSUB -W 3:00

set -x

date

echo " +++++++++++++++++++++++++++++++++++++++++++++++++"
echo " ++++++++     ENSEMBLE ARCHIVE       +++++++++++++++"
echo " +++++++++++++++++++++++++++++++++++++++++++++++++"


###
### get date
###

Date=${2:-$(date +%Y%m%d)}
export CDATE=${Date}00
echo "CDATE=$CDATE"

### CDATE=YYYYMMDDHH Y2K comparable
### export from outside of script

if [ "$CDATE" = "" ]; then
   echo "CDATE = $CDATE "
   echo "JOB EXIT NOW !!!!!!"
   exit
fi


export CDATE=$CDATE
export SCOM=/com
export DFROM=/p5com/gens/prod
export DFROM=$SCOM/gens/prod

echo " +++++++++++++++++++++++++++++++++++++++++++++++++"
echo " +++++ GLOBAL ENSEMBLE ARCHIVE on MIST   +++++++++"
echo " +++++++++++++++++++++++++++++++++++++++++++++++++"

###
### Define the time for each cycle and different days
###

export CDATEp06=`$nhours +06 $CDATE`
export CDATEm06=`$nhours -06 $CDATE`
export CDATEm12=`$nhours -12 $CDATE`
export CDATEm18=`$nhours -18 $CDATE`
export CDATEm24=`$nhours -24 $CDATE`
export CDATEm30=`$nhours -30 $CDATE`
export CDATEm36=`$nhours -36 $CDATE`
export CDATEm42=`$nhours -42 $CDATE`
export CDATEm48=`$nhours -48 $CDATE`
export CDATEm54=`$nhours -54 $CDATE`
export CDATEm60=`$nhours -60 $CDATE`
export CDATEm72=`$nhours -72 $CDATE`
export CDATEm84=`$nhours -84 $CDATE`
export CDATEm96=`$nhours -96 $CDATE`
export CDATEm108=`$nhours -108 $CDATE`
export CDATEm120=`$nhours -120 $CDATE`
export CDATEp00=$CDATE
export CDATEp12=`$nhours +12 $CDATE`
export CDATEp24=`$nhours +24 $CDATE`
export YMDM1=`$nhours -24 $CDATE | cut -c1-8`
export YMDM2=`$nhours -48 $CDATE | cut -c1-8`
export YMDM3=`$nhours -72 $CDATE | cut -c1-8`
export YMDM4=`$nhours -96 $CDATE | cut -c1-8`
export YMDM5=`$nhours -120 $CDATE | cut -c1-8`
export CYMD=`echo $CDATE | cut -c1-8`
export CYMDM1=`echo $CDATEm24 | cut -c1-8`
export YYYYMM=`$nhours -96 $CDATE | cut -c1-6`
export MMDD=`echo $CDATE | cut -c5-8`
export DD=`echo $CDATE | cut -c7-8`
export HH=`echo $CDATE | cut -c9-10`

################### Global ensemble data archive ####################

echo "++++++ Submite the NCEP ENSPOST_06 job ++++++"
export CDATE=$CDATEm18
out=$PTMP/$LOGNAME/ens06.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_06.sh
#sub -e CDATE -a GEN-MTN -w "+00" -t 3000 -j ens06 -o $out $job
bsub -q "dev" -W 3:00  -J ens06 -o  $out $job
#$job > $out 

echo "++++++ Submite the NCEP ENSPOST_12 job ++++++"
export CDATE=$CDATEm12
out=$PTMP/$LOGNAME/ens12.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_12.sh
#sub -e CDATE -a GEN-MTN -w "+00" -t 3000 -j ens12 -o $out $job
bsub -q "dev" -W 3:00  -J ens12 -o  $out $job
#$job > $out

echo "++++++ Submite the NCEP ENSPOST_18 job ++++++"
export CDATE=$CDATEm06
out=$PTMP/$LOGNAME/ens18.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_18.sh
#sub -e CDATE -a GEN-MTN -w "+00" -t 3000 -j ens18 -o $out $job
bsub -q "dev" -W 3:00  -J ens18 -o  $out $job
#$job > $out

sleep 1800

echo "++++++ Submite the NCEP ENSPOST_00 job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/ens00.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_00.sh
#sub -e CDATE -a GEN-MTN -w "+0030" -t 3000 -j ens00 -o $out $job
bsub -q "dev" -W 3:00  -J ens00 -o  $out $job
#$job > $out &

echo "++++++ Submite the NCEP BC ENSPOST_06 job ++++++"
export CDATE=$CDATEm18
out=$PTMP/$LOGNAME/ens06bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC.sh
#sub -e CDATE -a GEN-MTN -t 3000 -w "+0005" -j ens06bc -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_12 job ++++++"
export CDATE=$CDATEm12
out=$PTMP/$LOGNAME/ens12bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC.sh
#sub -e CDATE -a GEN-MTN -t 3000 -w "+0025" -j ens12bc -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_18 job ++++++"
export CDATE=$CDATEm06
out=$PTMP/$LOGNAME/ens18bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC.sh
#sub -e CDATE -a GEN-MTN -t 3000 -w "+0045" -j ens18bc -o $out $job

echo "++++++ Submite the NCEP BC ENSPOST_00 job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/ens00bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_BC.sh
#sub -e CDATE -a GEN-MTN -t 4000 -w "+0065" -j ens00bc -o $out $job

echo "++++++ Submite the CMC ENSPOST_00+12 job ++++++"
export CDATE=$CDATEm24
out=$PTMP/$LOGNAME/cmc_ens.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12.sh
#sub -e CDATE -a GEN-MTN -t 8000 -w "+0030" -j cmc_ens -o $out  $job

echo "++++++ Submite the CMC ENSPOST_00+12 job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/cmc_ens.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12.sh
#sub -e CDATE -a GEN-MTN -t 8000 -w "+0300" -j cmc_ens -o $out  $job

echo "++++++ Submite the CMC ENSPOST_00+12_BC job ++++++"
export CDATE=$CDATEm12
out=$PTMP/$LOGNAME/cmc_ens_bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12_BC.sh
#sub -e CDATE -a GEN-MTN -t 3000 -w "+0000" -j cmc_ens_bc -o $out  $job

echo "++++++ Submite the CMC ENSPOST_00+12_BC job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/cmc_ens_bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_CMC_00+12_BC.sh
#sub -e CDATE -a GEN-MTN -t 3000 -w "+0355" -j cmc_ens_bc -o $out  $job

### following four jobs need review for /p5com???#### (03/04/2009)
echo "++++++ Submite the ECM ENSPOST_12 job ++++++"
echo "++++++ additional parameteres (t2m,uv250,uv850 ...)++++++"
export CDATE=$CDATEm12
out=$PTMP/$LOGNAME/ecm_ens12.aout
job=$SHOME/$LOGNAME/ecmwf/jobs/JWSR_ECMWFENSH.sms.prod
#sub -e CDATE -a GEN-MTN -t 9000 -w "+0050" -j ecm_ens -o $out  $job

echo "++++++ Submite the ECM ENSPOST_00 job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/ecm_ens00.out
#job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_ECM_00.sh
job=$SHOME/$LOGNAME/ecmwf/jobs/JWSR_ECMWFENSH.sms.prod
#sub -e CDATE -a GEN-MTN -t 9000 -w "+0250" -j ecm_ens -o $out  $job

echo "++++++ Submite the FNMOC ENSPOST_00 job ++++++"
export CDATE=$CDATEm24
out=$PTMP/$LOGNAME/fno_ens00.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_FNMOC.sh
#sub -e CDATE -a GEN-MTN -w "+0000" -t 3000 -j fno_ens_00 -o $out  $job

echo "++++++ Submite the FNMOC ENSPOST_12 job ++++++"
export CDATE=$CDATEm36
out=$PTMP/$LOGNAME/fno_ens12.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_FNMOC.sh
#sub -e CDATE -a GEN-MTN -w "+0050" -t 3000 -j fno_ens_12 -o $out  $job

echo "++++++ Submite the FNMOC ENSPOST_bc_00 job ++++++"
export CDATE=$CDATEm24
out=$PTMP/$LOGNAME/fno_ens00_bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_FNMOC_bc.sh
#sub -e CDATE -a GEN-MTN -w "+0000" -t 3000 -j fno_ens_00_bc -o $out  $job

echo "++++++ Submite the FNMOC ENSPOST_bc_12 job ++++++"
export CDATE=$CDATEm36
out=$PTMP/$LOGNAME/fno_ens12_bc.out
job=$SHOME/$LOGNAME/earch/scripts/ENSPOST_FNMOC_bc.sh
#sub -e CDATE -a GEN-MTN -w "+0050" -t 3000 -j fno_ens_12_bc -o $out  $job

echo "++++++ Submite real time parallel job ++++++"
export CDATE=$CDATEp00
out=$PTMP/$LOGNAME/GENS_para.out
job=$SHOME/$LOGNAME/earch/scripts/GENSARCH_para.sh
##sub -e CDATE -a GEN-MTN -w "+0000" -j gen_par -o $out  $job

###
### Submit the schedual job itself
###

#echo "++++++ Submite the GENSARCH_main job ++++++"
out=$SHOME/$LOGNAME/earch/scripts/GENSARCH_main.out
job=$SHOME/$LOGNAME/earch/scripts/GENSARCH_main.sh
#sub -a GFS-MTN -q 1 -p 1/1 -w ${NEXT_JOB_TIME} -t 3:00:00 -j GENSARCH_main.sh_seperatedjobs -o $out $job
bsub < $job

exit

