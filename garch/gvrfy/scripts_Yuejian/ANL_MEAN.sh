
if [ $# -lt 1 ]; then
   echo "Usage:$0 need input"
   echo "1). YYYYMMDDHH (initial time)"
   exit 8
fi

tmpdir=$PTMP/$LOGNAME/anl_mean
mkdir $tmpdir
cd    $tmpdir

#nhours=/nwprod/util/exec/ndate
#COPYGB=/nwprod/util/exec/copygb

fdir=$NGLOBAL/$LOGNAME/CDAS
CDATE=$1             
YMD=`echo $CDATE | cut -c1-8`
CYC=`echo $CDATE | cut -c9-10`

echo " ***************************************"
echo " JOB INPUT INITIAL  TIME IS: $CDATE "
echo " ***************************************"

cp /com/gfs/prod/gdas.$YMD/gdas1.t${CYC}z.pgrbanl  nmc_anl.dat
cp $GLOBAL/ecm/pgbanl.$CDATE                   ecm_anl.dat
$COPYGB -g3 -i1,1 -x /com/mrf/prod/ukmet.$YMD/ukmet.t${CYC}z.ukmet00 ukm_anl.dat

#$COPYGB -g2 -i1,1 -x /com/gfs/prod/gdas.$YMD/gdas1.t${CYC}z.pgrbanl  nmc_anl.dat
#$COPYGB -g2 -i1,1 -x /global/ecm/pgbanl.$CDATE                       ecm_anl.dat
#cp /com/mrf/prod/ukmet.$YMD/ukmet.t${CYC}z.ukm25f00                  ukm_anl.dat


ls -l *dat

 echo "&namin " >input
 echo "cnmc='nmc_anl.dat'," >>input
 echo "cecm='ecm_anl.dat'," >>input
 echo "cukm='ukm_anl.dat'," >>input
 echo "cmen='men_anl.dat'," >>input
 echo "/" >>input

 $SHOME/$LOGNAME/gvrfy/sorc/ANL_MEAN <input 

cp men_anl.dat $GLOBAL/canl/pgbanl.$CDATE
cat fort.60 >>$SHOME/$LOGNAME/doc/CANL_README.doc
cat fort.60 >>$GLOBAL/canl/README.doc

rm fort.60
rm $tmpdir/*.dat


