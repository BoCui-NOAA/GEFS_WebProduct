
if [ $# -lt 4 ]; then
 echo "Usage: $0 need yyyymmdd, pr, [00/12] [24/06/12/18]"
 echo "       e.g.: vrfyex_16.sh.new 20000101 s 00 24"
 echo "       e.g.: vrfyex_16.sh.new 20000101 e 12 24"
 exit 8      
else
 stymd=$1
 edymd=$1
 pr=$2
fi

#set -x

idate=`echo $stymd | cut -c3-8`
idate=$idate\00                      

date;pwd

###
### 1. Set up the temperally directory
###

tmpdir=$PTMP/$LOGNAME/vfcons$pr   

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

dat=$SHOME/$LOGNAME/gvrfy/data
#windex=/nwprod/util/exec/grbindex           
#nhours=/nwprod/util/exec/ndate
#COPYGB=/nwprod/util/exec/copygb

### 
### 3. Set up the analysis and forecasting file location
###

fdir=$GLOBAL/pr$pr       
ddir=$GLOBAL/pr$pr       

if [ $stymd -ge 20020401 -a "$pr" = "s" ]; then
echo " Using avn forecast instead of "
fdir=$GLOBAL/pra
fi

if [ "$pr" = "e" ]; then
fdir=$GLOBAL/ecm
ddir=$GLOBAL/ecm
fi

if [ "$pr" = "m" ]; then
fdir=$GLOBAL/cmc
ddir=$GLOBAL/cmc
fi

if [ "$pr" = "n" ]; then
fdir=$GLOBAL/fno
ddir=$GLOBAL/fno
fi

###
### 4. Set up verifying time table
###

nh=384
ih=24
nhp1=`expr $nh + $ih`
istep=`expr $nhp1 / $ih `
### ictl=0  ( against one analysis ) or ictl=1 ( against one initial )
ictl=1
### iclim=0 ( CAC Climatology ) and iclim=1 ( CDAS/ReAnl Climatology)
### for daily operational, Peter asked to use CAC Climatology for ex-tropic.
iclime=0
iclimt=1
### ivrf=0 ( against itself ) ivrf=1 ( against operational )
### ivrf=2 ( against itself, but using operational if missing analysis )
#ivrf=0
ivrf=2   ### changed since 07/10/2002 by parellel x move to operational

while [ $stymd -le $edymd ]; do

cat <<paramEOF >input1
 &namin
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=1000,iclim=$iclime,ic=1
 /
 &namin
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=500,iclim=$iclime,ic=1
 /
 &namin
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=1000,iclim=$iclime,ic=1
 /
 &namin
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=500,iclim=$iclime,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=33,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=34,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=101,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=102,ilv=850,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=33,ilv=200,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=34,ilv=200,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=101,ilv=200,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=102,ilv=200,iclim=$iclimt,ic=1
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

#if [ "$pr" = "a" ]; then

if [ "$3" = "" ]; then
 HOUR=00
else
 HOUR=$3
fi

YEAR=`echo $stymd | cut -c1-4`

pymdh=$stymd$HOUR
fymdh=$stymd$HOUR
fn=pgbf
error=0
kcnt=1
anl=00
fct=00
fctp1=00
fymdhm1=$fymdh
while [ $kcnt -le $istep ]; do

 for file in GDAS FCST ; do
  case $file in
   GDAS) DIRandFile=$fdir/$fn$fctp1.$fymdhm1;Sfile=$fn$fctp1.$fymdhm1;FF=cfilea;; 
   FCST) DIRandFile=$fdir/$fn$fct.$fymdh;Sfile=$fn$fct.$fymdh;FF=cfilef;; 
  esac

  if [ -s $DIRandFile ]; then
   if [ "$file" = "GDAS" -a $fctp1 -eq 00 -a "$pr" = "e" ]; then
    cp $GLOBAL/pra/pgbf00.$fymdhm1 kgbf00.$fymdhm1
    $windex kgbf00.$fymdhm1 kgbf00.$fymdhm1.index
    var=" $FF(1,$kcnt)='kgbf00.$fymdhm1',$FF(2,$kcnt)='kgbf00.$fymdhm1.index',"
    echo " Using $GLOBAL/pra/pgbf00.$fymdhm1 "
    echo " instead of $DIRandFile"
    echo "$var" 
    echo "$var" >>input2
   elif [ "$file" = "GDAS" -a $fctp1 -eq 00 -a "$pr" = "m" ]; then
    cp $GLOBAL/pra/pgbf00.$fymdhm1 kgbf00.$fymdhm1
    $windex kgbf00.$fymdhm1 kgbf00.$fymdhm1.index
    var=" $FF(1,$kcnt)='kgbf00.$fymdhm1',$FF(2,$kcnt)='kgbf00.$fymdhm1.index',"
    echo " Using $GLOBAL/pra/pgbf00.$fymdhm1 "
    echo " instead of $DIRandFile"
    echo "$var" 
    echo "$var" >>input2
   elif [ "$file" = "GDAS" -a $fctp1 -eq 00 -a "$pr" = "n" ]; then
    cp $GLOBAL/pra/pgbf00.$fymdhm1 kgbf00.$fymdhm1
    $windex kgbf00.$fymdhm1 kgbf00.$fymdhm1.index
    var=" $FF(1,$kcnt)='kgbf00.$fymdhm1',$FF(2,$kcnt)='kgbf00.$fymdhm1.index',"
    echo " Using $GLOBAL/pra/pgbf00.$fymdhm1 "
    echo " instead of $DIRandFile"
    echo "$var" 
    echo "$var" >>input2
   elif [ "$file" = "GDAS" -a $fctp1 -eq 00 -a "$pr" = "s" -a $3 -eq 00 ]; then
    cp $GLOBAL/prk/ukmet.$fymdhm1 kgbf00.$fymdhm1
    $windex kgbf00.$fymdhm1 kgbf00.$fymdhm1.index
    var=" $FF(1,$kcnt)='kgbf00.$fymdhm1',$FF(2,$kcnt)='kgbf00.$fymdhm1.index',"
    echo " Using $GLOBAL/prk/ukmet.$fymdhm1 "
    echo " instead of $DIRandFile"
    echo "$var" 
    echo "$var" >>input2
   else
    PGBLEN=`wgrib -V -ncep_opn $DIRandFile | grep nxny | sed -n '10 p' | awk '{print $9}'`
    echo " $DIRandFile has length of $PGBLEN "
    if [ $PGBLEN -eq 10512 ]; then
     cp $DIRandFile $Sfile
    elif [ $PGBLEN -eq 65160 ]; then
    #echo " Reduceing resolution from 1*1 to 2.5*2.5 "
    #echo ""
     $COPYGB -g2 -i1 -x $DIRandFile $Sfile
    # ls -l $Sfile
    elif [ "$PGBLEN" = "" ]; then
     echo " Missing file pgbf00.$CDATE "
    fi
    #cp $DIRandFile $Sfile
    $windex $Sfile $Sfile.index
    var=" $FF(1,$kcnt)='$Sfile',$FF(2,$kcnt)='$Sfile.index',"
    echo "$var"
    echo "$var" >>input2
   fi
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
  fymdhm1=`$nhours +$ih $fymdh`
  fct=`expr $fct + $ih`
  fctp1=`expr $fct + $ih`
  if [ $fctp1 -eq 0 ]; then
   fctp1=00
  fi
 else
  if [ $kcnt -eq 1 ]; then
   echo " There are $istep analysis and one initial fcsts needed "
  fi
  #fymdh=`$nhours $ih $fymdh `
  fymdhm1=`$nhours -$4 $fymdh `
  fct=`expr $fct + $ih`
  fctp1=`expr $fct + $4`
  if [ $fctp1 -le 9 ]; then
   fctp1=`expr $fctp1 + 0`
   fctp1=0$fctp1
  fi
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

FILENV=.assignv$$ 
export FILENV

ls -l pgbf*

#if [ "$pr" = "e" ]; then
#/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0006  <input0  2>/dev/null
#else
$SHOME/$LOGNAME/gvrfy/exec/vrfy_0301  <input0  2>/dev/null
#fi
       
cat scores.out 
cp scores.out $GLOBAL/vrfy_cons/SCORES$2$4.$stymd$3

stymd=`expr $stymd + 1`

cd $tmpdir

done

