
if [ $# -lt 2 ]; then
 echo "Usage: $0 need yyyymmdd, pr, [00/12] "
 echo "       e.g.: vrfyex_16.sh.new 20000101 s 12"
 exit 8      
else
 stymd=$1
 edymd=$1
 pr=$2
fi

set -x

idate=`echo $stymd | cut -c3-8`
idate=$idate\00                      

date;pwd

###
### 1. Set up the temperally directory
###

tmpdir=$PTMP/Yan.Luo/vf$pr   

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

dat=$SHOME/Yan.Luo/gvrfy/data
#windex=/nwprod/util/exec/grbindex           
#nhours=/nwprod/util/exec/ndate

### 
### 3. Set up the analysis and forecasting file location
###

fdir=$GLOBAL/pr$pr       
ddir=$GLOBAL/pr$pr       
fn=pgbf

if [ $stymd -ge 20020401 -a "$pr" = "s" ]; then
echo " Using avn forecast instead of "
#fdir=$GLOBAL/pra
fdir=/global/noscrub/emc.glopara/global/gfs
fi

if [ "$pr" = "cfs" ]; then
echo " Using new directory of prc "
fdir=/global/noscrub/emc.glopara/global/cfsr
ddir=/global/noscrub/emc.glopara/global/cfsr
fi

if [ "$pr" = "a" ]; then
echo " Using new directory of pra "
fdir=/global/noscrub/emc.glopara/global/gfs
ddir=/global/noscrub/emc.glopara/global/gfs
fi

###
###  short period for pry (started 10/08/2001)
###

#if [ "$pr" = "y" ]; then
# cd /global/pry
# $SHOME/Yan.Luo/gvrfy/scripts/pry.truncate.linkpgb.sh $stymd\00
# cd $tmpdir
#fi

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
ivrf=2   ### changed since 07/10/2002 when parellel x move to operational

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
error=0
kcnt=1
anl=00
fct=00
while [ $kcnt -le $istep ]; do

 for file in GDAS FCST ; do

  if [ "$pr" = "cfs" ]; then
   case $file in 
    GDAS) DIRandFile=$ddir/$fn$anl.cfsr.$pymdh;Sfile=pgbanl.$pymdh;FF=cfilea;;
    FCST) DIRandFile=$fdir/$fn$fct.cfsr.$fymdh;Sfile=$fn$fct.$fymdh;FF=cfilef;;
   esac
  fi

  if [ "$pr" = "a" ]; then
   case $file in
    GDAS) DIRandFile=$ddir/$fn$anl.gfs.$pymdh;Sfile=pgbanl.$pymdh;FF=cfilea;; 
    FCST) DIRandFile=$fdir/$fn$fct.gfs.$fymdh;Sfile=$fn$fct.$fymdh;FF=cfilef;; 
   esac
  fi    

  if [ "$pr" = "s" ]; then
   case $file in
    GDAS) DIRandFile=$ddir/$fn$anl.$pymdh;Sfile=pgbanl.$pymdh;FF=cfilea;;
    FCST) DIRandFile=$fdir/$fn$fct.gfs.$fymdh;Sfile=$fn$fct.$fymdh;FF=cfilef;;
   esac
  fi

  if [ "$file" = "GDAS" -a $ivrf -eq 1 ]; then
   if [ ! -s fnl.$pymdh -o ! -s fnl.$pymdh.index ]; then
    $SHOME/Yan.Luo/bin/getgrib ncep_fnl.$YEAR z1000.$pymdh $pymdh 00 7 1000
    $SHOME/Yan.Luo/bin/getgrib ncep_fnl.$YEAR z500.$pymdh $pymdh 00 7 500
    cat $tmpdir/z1000.$pymdh $tmpdir/z500.$pymdh >fnl.$pymdh
    $windex fnl.$pymdh fnl.$pymdh.index
   fi
   var=" $FF(1,$kcnt)='fnl.$pymdh',$FF(2,$kcnt)='fnl.$pymdh.index',"
   echo "$var" 
   echo "$var" >>input2
  else
   if [ -s $DIRandFile ]; then
    if [ "$pr" = "a" -o "$pr" = "s" ]; then
     if [ "$pr" = "s" -a "$file" = "GDAS" ]; then
     cp $DIRandFile $Sfile
     $windex $Sfile $Sfile.index   
     else
     $COPYGB -g2 -x -i0 $DIRandFile $Sfile   
     $windex $Sfile $Sfile.index
     fi
    else
    cp $DIRandFile $Sfile
    $windex $Sfile $Sfile.index        
    fi         
    var=" $FF(1,$kcnt)='$Sfile',$FF(2,$kcnt)='$Sfile.index',"
    echo "$var" 
    echo "$var" >>input2
   else
#### modified since 09/20/00 ############
   #if [ "$file" = "GDAS" -a -s $GLOBAL/prs/pgbf00.$pymdh ]; then
    if [ "$file" = "GDAS" -a $ivrf -eq 2 -a -s $GLOBAL/prs/pgbf00.$pymdh ]; then
     echo " Using $GLOBAL/prs/pgbf00.$pymdh instead of exp. $pr "
     cp $GLOBAL/prs/pgbf00.$pymdh $Sfile
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
   fi

  fi

 done   #for file in GDAS FCST ; do

 if [ $ictl -eq 0 ]; then
  if [ $kcnt -eq 1 ]; then
   echo " There is only one analysis and $istep forecasts needed "
  fi
  fymdh=`$nhours -$ih $fymdh`
  fct=`expr $fct + $ih`
 else
  if [ $kcnt -eq 1 ]; then
   echo " There are $istep analysis and one initial fcsts needed "
  fi
  pymdh=`$nhours $ih $pymdh `
  fct=`expr $fct + $ih`
 fi
 kcnt=`expr $kcnt + 1`

done   #while [ $kcnt -le $istep ]; do

#echo " ndate=$pymdh" >>input2
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

#/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0006  <input0  2>/dev/null
#/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0203  <input0  2>/dev/null
$SHOME/Yan.Luo/gvrfy/exec/vrfy_0301  <input0  2>/dev/null
       
cat scores.out 
cp scores.out /ensemble/noscrub/Yan.Luo/vrfy/SCORES$pr.$stymd$3

stymd=`expr $stymd + 1`

cd $tmpdir

done

