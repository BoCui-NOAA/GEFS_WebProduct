
dirsrc=/nfsuser/g01/wx20yz/wpqpf/sorc
dirdat=$HOME/global/prcp                     
#dirdat=/user/g01/wx20yz/cpqpf/data
dirtmp=/ptmp/wx20yz/eqpf

if [ ! -s /tmp/wd20yz/eqpf ]; then
  mkdir $dirtmp
fi

set -x
cd $dirtmp

export CDATE=$CDATE
if [ "$CDATE" -eq "" ]; then
  echo " need export CDATE "
  exit 08
fi

YMDH=$CDATE
YMDHM12=`ndate -12 $CDATE`

cat $dirdat/precip.$YMDH $dirdat/precip.$YMDHM12 >precip.dat

ls -l

cat <<paramEOF >input1
 &namin
 iask=3,                                                   
 /
paramEOF

/nwprod/util/exec/grbindex  precip.dat  $dirtmp/precip.ind

$dirsrc/eqpf   <input1

cp precip.out /global/rainarch/pqpf_cen.$YMDH
