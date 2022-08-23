
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

export CLICPC=/nfsuser/g01/wx20yz/gvrfy/data
export CLI23Y=/global/cdas                     
export windex=/nwprod/util/exec/grbindex           
export nhours=/nwprod/util/exec/ndate
export COPYGB=/nwprod/util/exec/copygb

### 
### 3. Set up the analysis and forecasting file location
###

### default file names: 
###              drfmr.t00z.pgrbf00
###              drfmr.t00z.pgrbf12
###              drfmr.t00z.pgrbf24
###              .................
###       or
###              gblav.t00z.pgrbf00
###              gblav.t00z.pgrbf12
###              gblav.t00z.pgrbf24
###              ..................

fdir=/global/pra              
ddir=/global/pra         
#fdir=/com/avn/prod/avn   
#ddir=/com/avn/prod/avn   

###
### 4. Set up verifying time table
###

nh=120      ### nh=120  ( verifying upto 120 hours forecasts )
ih=24       ### ih=12   ( forecast interval )
ictl=0      ### ictl=0  ( against one analysis ) or ictl=1 ( against one initial )
iclim=1     ### iclim=0 ( CAC Climatology ) and iclim=1 ( CDAS/ReAnl Climatology)
            ### iclim=1 for tropical region, no options. 
ivrfy=0     ### ivrf=0  ( against itself ) ivrf=1 ( against operational )
            
nhp1=`expr $nh + $ih`
istep=`expr $nhp1 / $ih `  ### istep = total step for verifications

###
### 5. Started a loop
###

while [ $stymdh -le $edymdh ]; do

cat <<paramEOF >input1
 &namin  
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,nvhrs=$ih,
 ifd=11,ilv=850,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,nvhrs=$ih,
 ifd=7,ilv=500,iclim=$iclim,ic=1
 /    
 &namin  
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,nvhrs=$ih,
 ifd=11,ilv=850,iclim=$iclim,ic=1
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

aymd=`echo $stymdh | cut -c1-8`
fymd=`echo $stymdh | cut -c1-8`
AHR=`echo $stymdh | cut -c9-10`
FHR=`echo $stymdh | cut -c9-10`
m1=`echo $stymdh | cut -c5-6`
m2=`expr $m1 + 1`
if [ $m2 -eq 13 ]; then m2=1    ; fi
if [ $m2 -le 9  ]; then m2=0$m2 ; fi
m3=`expr $m1 - 1`
if [ $m3 -eq 0  ]; then m3=12   ; fi
if [ $m3 -le 9  ]; then m3=0$m3 ; fi
fn=pgbf
anl=00       
fct=00      
error=0
kcnt=1

###
### Copy climatological data to tmp space
###

if [ $iclim -eq 0 ]; then
 cp $CLICPC/nmc30y.ibmsp              .
 cp $CLICPC/cac8ys.ibmsp              .
elif [ $iclim -eq 1 ]; then
 cp $CLI23Y/pgb.f00${m1}.00Z          .
 cp $CLI23Y/pgb.f00${m1}.00Z.index    .
 cp $CLI23Y/pgb.f00${m1}.12Z          .
 cp $CLI23Y/pgb.f00${m1}.12Z.index    .
 cp $CLI23Y/pgb.f00${m2}.00Z          .
 cp $CLI23Y/pgb.f00${m2}.00Z.index    .
 cp $CLI23Y/pgb.f00${m2}.12Z          .
 cp $CLI23Y/pgb.f00${m2}.12Z.index    .
 cp $CLI23Y/pgb.f00${m3}.00Z          .
 cp $CLI23Y/pgb.f00${m3}.00Z.index    .
 cp $CLI23Y/pgb.f00${m3}.12Z          .
 cp $CLI23Y/pgb.f00${m3}.12Z.index    .
fi

while [ $kcnt -le $istep ]; do

 FNA=gblav.t${AHR}z.pgrbf
 FNF=gblav.t${FHR}z.pgrbf

 for file in GDAS FCST 
 do 

  case $file in
   #GDAS) DIRandFile=$ddir.$aymd/${FNA}$anl;Sfile=$fn$anl.$aymd$AHR;FF=cfilea;; 
   #FCST) DIRandFile=$fdir.$fymd/${FNF}$fct;Sfile=$fn$fct.$fymd$FHR;FF=cfilef;; 
   GDAS) DIRandFile=$ddir/${fn}$anl.$aymd$AHR;Sfile=$fn$anl.$aymd$AHR;FF=cfilea;; 
   FCST) DIRandFile=$fdir/${fn}$fct.$fymd$FHR;Sfile=$fn$fct.$fymd$FHR;FF=cfilef;; 
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
  if [ $fct -le 9 ]; then fct=0$fct ; fi
  fymd=`$nhours -$fct $aymd$AHR | cut -c1-8`
  FHR=`$nhours -$fct $aymd$AHR | cut -c9-10`
 else
  if [ $kcnt -eq 1 ]; then
   echo " There are $istep analysis and one initial fcsts needed "
  fi
  fct=`expr $fct + $ih`
  if [ $fct -le 9 ]; then fct=0$fct ; fi
  aymd=`$nhours +$fct $fymd$AHR | cut -c1-8`
  AHR=`expr $AHR + $ih`
  if [ $AHR -le 9 ]; then AHR=0$AHR ; fi
  if [ $AHR -eq 24 ]; then
   AHR=00
  fi
 fi

 kcnt=`expr $kcnt + 1`

done   #while [ $kcnt -le $istep ]; do

#echo " ndate=$aymd$FHR" 
#echo " ndate=$aymd$FHR" >>input2
echo " /"             
echo " /"             >>input2

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

/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0109  <input
       
cat scores.out 
stymdh=`$nhours +24 $stymdh`

done

