
STYMDH=2001020100
EDYMDH=2001022800

dirsrc=/nfsuser/g01/wx20yz/wpqpf/sorc
dirdat=$HOME/global/prcp                     
#dirdat=/user/g01/wx20yz/cpqpf/data
dirtmp=/ptmp/wx20yz/eqpf

if [ ! -s /ptmp/wx20yz/eqpf ]; then
  mkdir $dirtmp
fi

set -x
cd $dirtmp

while [ $STYMDH -le $EDYMDH ]; do

rm precip.dat precip.ind precip.out

CDATE=$STYMDH
YMDH=$CDATE
YMDHM12=`ndate -12 $CDATE`
YYMM=`echo $CDATE | cut -c3-6`
MM=`echo $CDATE | cut -c5-6`

cat $dirdat/precip.$YMDH $dirdat/precip.$YMDHM12 >precip.dat

ls -l

cat <<paramEOF >input1
 &namin
 iask=3,                                                   
 /
paramEOF

/nwprod/util/exec/grbindex  precip.dat  $dirtmp/precip.ind

#cp $HOME/rvrfy/data/opt_20$YYMM.dat opt_file
cp $HOME/rvrfy/data/opt_2000$MM.dat opt_file

$dirsrc/eqpf_23m   <input1

cp precip.out /global/rainarch/pqpf_cen.$YMDH

STYMDH=` ndate +24 $STYMDH `

done
