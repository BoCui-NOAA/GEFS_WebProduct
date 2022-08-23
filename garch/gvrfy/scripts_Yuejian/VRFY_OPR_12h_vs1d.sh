
if [ $# -lt 1 ]; then
 echo "Usage: $0 need [yyyymmddhh] input "
 exit 8      
else
 stymdh=$1
 edymdh=$1
 pr=$2
fi

#set -x
date;pwd

###
### 1. Set up the temperally directory
###

uname=` who am i | awk '{print $1}' `
tmpdir=/ptmp/$uname/vftest   

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
COPYGB=/nwprod/util/exec/copygb

### 
### 3. Set up the analysis and forecasting file location
###

### default file names: 
###              drfmr.t00z.pgrbf00
###              drfmr.t00z.pgrbf24
###              .................
###       or
###              gblav.t00z.pgrbf00
###              gblav.t00z.pgrbf24
###              ..................

#fdir=/com/avn/prod/avn   
#ddir=/com/avn/prod/avn   
#fdir=/global/pra           
#ddir=/global/pra          
fdir=/ptmp/wx20mi/xmrh   
ddir=/ptmp/wx20yz/xmrf    
fn=pgbf

###
### 4. Set up verifying time table
###

nh=168
ih=12
nhp1=`expr $nh + $ih`
istep=`expr $nhp1 / $ih `
### ictl=0  ( against one analysis ) or ictl=1 ( against one initial )
ictl=1
### iclim=0 ( CAC Climatology ) and iclim=1 ( CDAS/ReAnl Climatology)
iclim=0
### ivrf=0 ( against itself ) ivrf=1 ( against operational )
ivrf=0

while [ $stymdh -le $edymdh ]; do

cat <<paramEOF >input1
 &namin  
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=1000,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=500,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=1000,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=500,iclim=$iclim,ic=1
 /     
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=33,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=34,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=101,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=102,ilv=850,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=33,ilv=200,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=34,ilv=200,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=101,ilv=200,iclim=1,ic=1
 /    
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,nvhrs=$ih,
 ifd=102,ilv=200,iclim=1,ic=1
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

YEAR=`echo $stymdh | cut -c1-4`

pymd=`echo $stymdh | cut -c1-8`
fymd=`echo $stymdh | cut -c1-8`
AHR=`echo $stymdh | cut -c9-10`
FHR=`echo $stymdh | cut -c9-10`
anl=00       
fct=00      
error=0
kcnt=1

while [ $kcnt -le $istep ]; do

 FN1=gblav.t${AHR}z.pgrbf
 FN2=gblav.t${FHR}z.pgrbf
 FNAME=pgbf                       

 for file in GDAS FCST 
 do 

  case $file in
   #GDAS) DIRandFile=$ddir.$pymd/${FN1}$anl;Sfile=$fn$anl.$pymd$AHR;FF=cfilea;; 
   #FCST) DIRandFile=$fdir.$fymd/${FN2}$fct;Sfile=$fn$fct.$fymd$FHR;FF=cfilef;; 
   GDAS) DIRandFile=$ddir/${FNAME}$anl.$pymd$AHR;Sfile=$fn$anl.$pymd$AHR;FF=cfilea;; 
   FCST) DIRandFile=$fdir/${FNAME}$fct.$fymd$FHR;Sfile=$fn$fct.$fymd$FHR;FF=cfilef;; 
  esac

  if [ -s $DIRandFile ]; then
   PGBLEN=`wgrib -V $DIRandFile | grep nxny | sed -n '1 p' | awk '{print $9}'`
   echo " $DIRandFile has length of $PGBLEN "

   if [ $PGBLEN -eq 10512 ]; then
    cp $DIRandFile $Sfile
    $windex $Sfile $Sfile.index                 
   elif [ $PGBLEN -eq 65160 ]; then
    echo " Reduceing resolution from 1*1 to 2.5*2.5 "
    $COPYGB -g2 -x $DIRandFile $Sfile           
    $windex $Sfile $Sfile.index                 
   else
    echo " The program is not support this resolution ($PGBLEN) yet "
    exit 8
   fi

   var=" $FF(1,$kcnt)='$Sfile',$FF(2,$kcnt)='$Sfile.index',"
   echo "$var" 
   echo "$var"  >>input2
  else
   echo " $DIRandFile is not there, count one problem "
   var=" $FF(1,$kcnt)='$Sfile',$FF(2,$kcnt)='$Sfile.index',"
   echo "$var" 
   echo "$var"  >>input2
   error=`expr $error + 1`
  fi

 done   #for file in GDAS FCST 

 if [ $ictl -eq 0 ]; then
  if [ $kcnt -eq 1 ]; then
   echo " There is only one analysis and $istep forecasts needed "
  fi
  fct=`expr $fct + $ih`
  fymd=`$nhours -$fct $pymd$AHR | cut -c1-8`
  FHR=`$nhours -$fct $pymd$AHR | cut -c9-10`
 else
  if [ $kcnt -eq 1 ]; then
   echo " There are $istep analysis and one initial fcsts needed "
  fi
  fct=`expr $fct + $ih`
  #pymd=`$nhours +$fct $fymd$AHR | cut -c1-8`
  pymd=`$nhours +24 $fymd$AHR | cut -c1-8`
  AHR=`expr $AHR + $ih`
  if [ $AHR -eq 24 ]; then
   AHR=00
  fi
  AHR=00
  if [ $fct -le 24 ]; then
   anl=00
  else
   anl=`expr $fct - 24 `
  fi
 fi

 kcnt=`expr $kcnt + 1`

done   #while [ $kcnt -le $istep ]; do

echo " ndate=$pymd$FHR" 
echo " ndate=$pymd$FHR" >>input2
echo " &end"             
echo " &end"             >>input2

cat input2 input1 >input

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

#/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0109  <input
/nfsuser/g01/wx20yz/gvrfy/sorc/vrfy_0109_vs1d <input
       
cat scores.out 
cp scores.out /global/help/wx20mi/SCOREShp.$fymd  
stymdh=`$nhours +24 $stymdh`

done

