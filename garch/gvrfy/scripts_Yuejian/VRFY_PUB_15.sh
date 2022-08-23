
if [ $# -lt 1 ]; then
 echo "Usage: $0 need [yyyymmdd] input "
 exit 8      
else
 stymd=$1
 edymd=$1
 pr=$2
fi

idate=`echo $stymd | cut -c3-8`
idate=$idate\00                      

date;pwd

###
### 1. Set up the temperally directory
###

uname=` who am i | awk '{print $1}' `
tmpdir=/gpfstmp/$uname/vf$pr   

if [ -s $tmpdir ]; then
  rm $tmpdir/*
  cd $tmpdir
else
  mkdir -p $tmpdir
  cd $tmpdir
fi

###
### 2. Set up the climate data entry, grib utility entry.
###

dat=/nfsuser/g01/wx20yz/gvrfy/data
windex=/nwprod/util/exec/grbindex           
nhours=/nwprod/util/exec/ndate

### 
### 3. Set up the analysis and forecasting file location
###

### default file names: 
###              drmrf.t00z.pgrbf00
###              drmrf.t00z.pgrbf24
###              .................

fdir=/com/mrf/prod       
ddir=/com/mrf/prod       
fn=pgbf

###
### 4. Set up verifying time table
###

nh=360
ih=24
nhp1=`expr $nh + $ih`
istep=`expr $nhp1 / $ih `
### ictl=0  ( against one analysis ) or ictl=1 ( against one initial )
ictl=0
### iclim=1 ( CAC Climatology ) and iclim=1 ( CDAS/ReAnl Climatology)
iclim=1
### ivrf=0 ( against itself ) ivrf=1 ( against operational )
ivrf=0

while [ $stymd -le $edymd ]; do

cat <<paramEOF >input1
 &namin  
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,
 ifd=7,ilv=1000,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,
 ifd=7,ilv=500,iclim=$iclim,ic=1
 /     
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=33,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=34,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=101,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=102,ilv=850,iclim=1,ic=1
 /    
paramEOF

###
### Notes:
###      la1,la2,lo1,lo2 for ACGRID and RMSAWT calculation
###      NH: 77.5N-20.0N (la1=6,la2=29)
###      SH: 20.0S-77.5S (la1=45,la2=68)
###
###      l1,l2 for anomaly correlation calculation
###      NH: 80.0N-20.0N (l1=5,l2=28) weight in mid. of the grid
###      SH: 20.0S-80.0S (l1=45,l2=68)

echo " &files "  >input2

###
### Get analysis and forecast data
###

if [ "$pr" = "a" ]; then
HOUR=12
stymd=`$nhours -24 $stymd\00 | cut -c1-8`
edymd=`$nhours -24 $edymd\00 | cut -c1-8`
else
HOUR=00
fi

YEAR=`echo $stymd | cut -c1-4`

pymdh=$stymd$HOUR
fymdh=$stymd$HOUR
pymd=$stymd
fymd=$stymd
error=0
kcnt=1
anl=00
fct=00
while [ $kcnt -le $istep ]; do

 for file in GDAS FCST ; do
  case $file in
   GDAS) DIRandFile=$ddir/mrf.$pymd/drmrf.t00z.pgbf00;Sfile=$fn$anl.$pymdh;FF=cfilea;; 
   FCST) DIRandFile=$fdir/mrf.$fymd/drmrf.t00z.pgbf$fct;Sfile=$fn$fct.$fymdh;FF=cfilef;; 
  esac

 if [ -s $DIRandFile ]; then
  cp $DIRandFile $Sfile
  $windex $Sfile $Sfile.index                 
  var=" $FF(1,$kcnt)='$Sfile',$FF(2,$kcnt)='$Sfile.index',"
  echo "$var" 
  echo "$var" >>input2
 else
  echo " $DIRandFile is not there, count one problem "
  var=" $FF(1,$kcnt)='$Sfile',$FF(2,$kcnt)='$Sfile.index',"
  echo "$var" 
  echo "$var" >>input2
  error=`expr $error + 1`
 fi

 done   #for file in GDAS FCST ; do

  if [ $ictl -eq 0 ]; then
    if [ $kcnt -eq 1 ]; then
    echo " There is only one analysis and $istep forecasts needed "
    fi
    fymdh=`$nhours -$ih $fymdh`
    fymdh=`echo $fymdh | cut -c1-8`
    fct=`expr $fct + $ih`
  else
    if [ $kcnt -eq 1 ]; then
    echo " There are $istep analysis and one initial fcsts needed "
    fi
    pymdh=`$nhours $ih $pymdh `
    pymd=`echo $pymdh | cut -c1-8`
    fct=`expr $fct + $ih`
  fi
 kcnt=`expr $kcnt + 1`

done   #while [ $kcnt -le $istep ]; do

echo " ndate=$pymdh" >>input2
echo " &end" >>input2

cat input2 input1 >input0

echo "####################################################"
echo "###  Report error = $error ( missing files )     ###"
echo "###  Job will continue, but back to ckeck!!!!    ###"
echo "####################################################"

########################################################################
#   1.  input1 ------> verification parameters setting
#       input2 ------> verification file name
#   2.  input unit assign
#         unit 11 - 30 -------> analysis files
#         unit 31 - 50 -------> forecast files
#         unit 51 - 54 -------> climatology files
#         unit 81 - 90 -------> output files
#   3.  main progran   -------> $HOME/verify/source/vfmain.f
########################################################################

ls -l pgbf*

/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0004  <input0  2>/dev/null
       
cat scores.out 
stymd=`expr $stymd + 1`

done

