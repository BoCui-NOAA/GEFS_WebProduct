#!/bin/sh
if [ $# -lt 1 ]; then
   echo "Usage: $0 need input table"
   echo "       example: VRFY_PUB_sh /nfsuser/g01/wx20yz/scripts/vrfy_table"
   echo "       please cut and modify following table"
   cat /nfsuser/g01/wx20yz/scripts/vrfy_table
   exit 8
fi

###
### This script will RUN experiment verification
###      output format will be the same as operational
###      operational scores are stored in /global/vrfy/SCORESs.[yyyymmdd]
###
###      By Yuejian Zhu (08/03/00)
###
### Note: Input PGB file should be in 2.5*2.5 degree resolution
###       Adding option for high ( 1*1 degree) resolution input.
###        program will reduce resolution to 2.5*2.5 degree
###       --- Yuejian Zhu (04/17/2001)

dat=/nfsuser/g01/wx20yz/gvrfy/data
windex=/nwprod/util/exec/grbindex           
nhours=/nwprod/util/exec/ndate
COPYGB=/nwprod/util/exec/copygb

###
### 1. Set up the temperally directory and set up CDATE  
###

uname=` who am i | awk '{print $1}' `
vrfy_table=$1

TDIR=/gpfstmp/$uname/vrfy
mkdir -p $TDIR
cp $vrfy_table $TDIR/vrfy_table.sh
chmod 755 $TDIR/vrfy_table.sh
. $TDIR/vrfy_table.sh

VFSDAY=$VFSDAY
VFEDAY=$VFEDAY
echo "DIR_ANL=$DIR_ANL"
echo "DIR_FST=$DIR_FST"
echo "EXP_ID=$EXP_ID"
echo "IVRFY=$IVRFY"
echo "VFSDAY=$VFSDAY"
echo "VFEDAY=$VFEDAY"
echo "VFSDAY=$STYMDH"
echo "VFEDAY=$EDYMDH"
echo "FHOURS=$FHOURS"

VDIR=/gpfstmp/$uname/vrfy${EXP_ID}
mkdir -p $VDIR;cd $VDIR;pwd

###
### 2. Set up the verified data entry..
###

fdir=$DIR_ANL                               
ddir=$DIR_FST                               

###
### 3. Set up the input file names and control parameters
###

###  Notes:
###        1. ihem  = (1=NH 2=SH 3=TP)       
###        2. lat   = (1=north pole 73=south pole )
###        3. iclim = (0=cpc climatology 1=reanlysis climatology)
###        4. ic    = (1=wave group 0=grid)
###        5. ifd   = (7=Z,33=u,34=v,101=wind speed,102=wind vector)

###
###  Example for operational verification setup.
###

iclime=1       #### ex-tropical
iclimt=1       #### tropical
ic=1

nh=$FHOURS
### Assume you don't have index files
ndays=`expr $nh / 24`
nstep=`expr $ndays + 1`

STYMDH=$VFSDAY
EDYMDH=$VFEDAY

while [ $STYMDH -le $EDYMDH ]; do

echo ""
echo "###########   Verification time  $STYMDH   ###################"
echo ""

istep=0
CDATE=$STYMDH
YMD=`echo $CDATE | cut -c1-8`
STYMDH=`$nhours +24 $STYMDH`

echo " &files "                                   >input1

if [ $IVRFY -eq 1 ]; then

 echo ""
 echo "########### Verification against one analysis ###################"
 echo ""

 if [ ! -s $ddir/pgbanl.$CDATE ]; then
  echo "file $ddir/pgbanl.$CDATE does not exist, quit!!!"
  exit 16
 fi
 PGBLEN=`wgrib -V -ncep_opn $ddir/pgbanl.$CDATE | grep nxny | sed -n '1 p' | awk '{print $9}'`
 echo " $ddir/pgbanl.$CDATE has length of $PGBLEN "
 if [ $PGBLEN -eq 10512 ]; then
  cp $ddir/pgbanl.$CDATE .
  $windex pgbanl.$CDATE pgbanl.$CDATE.index
 elif [ $PGBLEN -eq 65160 ]; then
  echo " Reduceing resolution from 1*1 to 2.5*2.5 "
  echo ""
  $COPYGB -g2 $ddir/pgbanl.$CDATE pgbanl.$CDATE.index pgbanl.$CDATE
  $windex pgbanl.$CDATE pgbanl.$CDATE.index
  ls -l pgbanl.$CDATE 
 elif [ "$PGBLEN" = "" ]; then
  echo " Missing file pgbanl.$CDATE "
  echo ""
 else
  echo " The program does not support this resolution ($PGBLEN) yet "
  exit 8
 fi

fi

while [ $istep -lt $nstep ]; do

 if [ $IVRFY -eq 1 ]; then
 
 ih=`expr $istep \* 24`
 if [ $ih -le 9 ]; then
  ih=0$ih
 fi
 YMDH=`$nhours -$ih $CDATE`

 if [ ! -s $ddir/pgbf$ih.$YMDH ]; then
  echo "file $ddir/pgbf$ih.$YMDH does not exist, caution!!!"
  echo ""
 else
 PGBLEN=`wgrib -V -ncep_opn $fdir/pgbf$ih.$YMDH | grep nxny | sed -n '1 p' | awk '{print $9}'`
 echo " $fdir/pgbf$ih.$YMDH has length of $PGBLEN "
 echo ""
 cp $fdir/pgbf$ih.$YMDH .
 $windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index
 if [ $PGBLEN -eq 10512 ]; then
  cp $fdir/pgbf$ih.$YMDH .
  $windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index
 elif [ $PGBLEN -eq 65160 ]; then
  echo " Reduceing resolution from 1*1 to 2.5*2.5 "
  echo "" 
  $COPYGB -g2 $fdir/pgbf$ih.$YMDH pgbf$ih.$YMDH.index pgbf$ih.$YMDH
  $windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index
  ls -l pgbf$ih.$YMDH
 elif [ "$PGBLEN" = "" ]; then
  echo " Missing file pgbf$ih.$YMDH "
  echo ""
 else
  echo " The program does not support this resolution ($PGBLEN) yet "
# exit 8
 fi
 fi

 (( istep += 1 ))

 echo " cfilea(1,$istep)='pgbanl.$CDATE', "      >>input1
 echo " cfilea(2,$istep)='pgbanl.$CDATE.index'," >>input1
 echo " cfilef(1,$istep)='pgbf$ih.$YMDH',  "     >>input1
 echo " cfilef(2,$istep)='pgbf$ih.$YMDH.index'," >>input1

 else

 echo ""
 echo "########### Verification against one initial forecast ##############"
 echo ""

 ih=`expr $istep \* 24`
 if [ $ih -eq 0 ]; then
  ih=00
 fi
 YMDH=`$nhours +$ih $CDATE`

 if [ ! -s $ddir/pgbanl.$YMDH ]; then
  echo "file $ddir/pgbanl.$YMDH does not exist, caution!!!"
 else
 PGBLEN=`wgrib -V -ncep_opn $fdir/pgbanl.$YMDH | grep nxny | sed -n '1 p' | awk '{print $9}'`
 echo " $fdir/pgbanl.$YMDH has length of $PGBLEN "
 cp $fdir/pgbanl.$YMDH .
 $windex pgbanl.$YMDH pgbanl.$YMDH.index
 if [ $PGBLEN -eq 10512 ]; then
  cp $fdir/pgbanl.$YMDH .
  $windex pgbanl.$YMDH pgbanl.$YMDH.index
 elif [ $PGBLEN -eq 65160 ]; then
  echo " Reduceing resolution from 1*1 to 2.5*2.5 "
  echo ""
  $COPYGB -g2 $fdir/pgbanl.$YMDH pgbanl.$YMDH.index pgbanl.$YMDH
  $windex pgbf$ih.$YMDH pgbf$ih.$YMDH.index
  ls -l pgbanl.$YMDH
 elif [ "$PGBLEN" = "" ]; then
  echo " Missing file pgbanl.$YMDH "
  echo ""
 else
  echo " The program does not support this resolution ($PGBLEN) yet "
  exit 8
 fi
 fi

 if [ ! -s $ddir/pgbf$ih.$CDATE ]; then
  echo "file $ddir/pgbf$ih.$CDATE does not exist, caution!!!"
 else
 PGBLEN=`wgrib -V -ncep_opn $fdir/pgbf$ih.$CDATE | grep nxny | sed -n '1 p' | awk '{print $9}'`
 echo " $fdir/pgbf$ih.$CDATE has length of $PGBLEN "
 echo ""
 cp $fdir/pgbf$ih.$CDATE .
 $windex pgbf$ih.$CDATE pgbf$ih.$CDATE.index
 if [ $PGBLEN -eq 10512 ]; then
  cp $fdir/pgbf$ih.$CDATE .
  $windex pgbf$ih.$CDATE pgbf$ih.$CDATE.index
 elif [ $PGBLEN -eq 65160 ]; then
  echo " Reduceing resolution from 1*1 to 2.5*2.5 "
  echo ""
  $COPYGB -g2 $fdir/pgbf$ih.$CDATE pgbf$ih.$CDATE.index pgbf$ih.$CDATE
  $windex pgbf$ih.$CDATE pgbf$ih.$CDATE.index
  ls -l pgbf$ih.$CDATE
 elif [ "$PGBLEN" = "" ]; then
  echo " Missing file pgbf$ih.$CDATE "
  echo " "
 else
  echo " The program does not support this resolution ($PGBLEN) yet "
  echo " "
  exit 8
 fi
 fi

 (( istep += 1 ))

 echo " cfilea(1,$istep)='pgbanl.$YMDH', "        >>input1
 echo " cfilea(2,$istep)='pgbanl.$YMDH.index',"   >>input1
 echo " cfilef(1,$istep)='pgbf$ih.$CDATE',  "     >>input1
 echo " cfilef(2,$istep)='pgbf$ih.$CDATE.index'," >>input1

 fi

done

echo " / "                                      >>input1

cat <<paramEOF >input2
 &namin
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=100,iclim=$iclime,ic=$ic
 /
 &namin
 ihem=1,la1=6,la2=29,lo1=1,lo2=144,l1=5,l2=28,nhrs=$nh,
 ifd=7,ilv=50,iclim=$iclime,ic=$ic
 /
 &namin
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,
 ifd=7,ilv=100,iclim=$iclime,ic=$ic
 /
 &namin
 ihem=2,la1=45,la2=68,lo1=1,lo2=144,l1=45,l2=68,nhrs=$nh,
 ifd=7,ilv=50,iclim=$iclime,ic=$ic
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=33,ilv=100,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=34,ilv=100,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=101,ilv=100,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=102,ilv=100,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=33,ilv=50,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=34,ilv=50,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=101,ilv=50,iclim=$iclimt,ic=1
 /
 &namin
 ihem=3,la1=29,la2=45,lo1=1,lo2=144,l1=29,l2=44,nhrs=$nh,
 ifd=102,ilv=50,iclim=$iclimt,ic=1
 /
paramEOF

cat input1 input2 >INPUT
cat INPUT
#ls -l pgbf*
/nfsuser/g01/wx20yz/gvrfy/exec/vrfy_0203  <INPUT  2>/dev/null
cat scores.out >SCORES$EXP_ID.$YMD\00 
cat SCORES$EXP_ID.$YMD\00
cp SCORES$EXP_ID.$YMD\00 /nbns/global/wx20yz/vrfy

echo " The verify scores is named `pwd`/SCORES$EXP_ID.$YMD\00 "

done
