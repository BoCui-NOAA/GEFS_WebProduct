
#set -xS
if [ $# -lt 4 ]; then
    echo " Usage: $0 need s-yyyymmdd, e-yyyymmdd, YYYYMM and ensm"
    echo " For example: PROB_NCEP_MEAN.sh 19960101 19960131 199601 10/14/20"
    exit 8
fi

echo
echo " ######################################################## "
echo " ###   Start to average the probability scores        ### "
echo " ###   Please wait! wait! wait!!!!!!!                 ### "
echo " ######################################################## "
echo

mkdir /ptmp/wx20yz/prob
cd /ptmp/wx20yz/prob

nhoursx=/nfsuser/g01/wx20yz/bin/ndate
stymd=$1
edymd=$2
yymm=$3
icnt=0
ensm=$4
NMEM=`expr $ensm + 1`
if [ $ensm -eq 10 ]; then
 NSTEP=32
else
 NSTEP=30
fi

rm input*

echo " &filec "  >>input1
echo " &filei "  >>input2

while [ $stymd -le $edymd ]; do

 if [ $stymd -eq 20020504 -o $stymd -eq 20020620 \
    -o $stymd -eq 20020713 -o $stymd -eq 20020721 \
    -o $stymd -eq 20020726 ]; then
   echo " do nothing "
 else
   SFILE=/nfsuser/g01/wx20yz/global/vfprob/PROB$ensm.$stymd\00
#  SFILE=/nfsuser/g01/wx20yz/global/vfprob/PROB10cal.$stymd\00
   if [ -s $SFILE ]; then
   (( icnt += 1 ))
      echo " cfile($icnt)='$SFILE' "
      echo " cfile($icnt)='$SFILE' " >>input1
      echo " ifile($icnt)=1 "
      echo " ifile($icnt)=1 " >>input2
   fi

  fi
  stymd=`$nhoursx +24 $stymd\00 | cut -c1-8`
done

echo " ofile='mean.output' " >>input1
echo " /" >>input1
echo " /" >>input2

echo " &namin " >>input3
echo " ilen=$icnt,istymd=$istymd,iedymd=$edymd " >>input3
echo " /" >>input3

cat input1 input2 input3 >input

cd /nfsuser/g01/wx20yz/eprob/sorc;pwd

sed -e "s/NMEM/$NMEM/" -e "s/NSTEP/$NSTEP/"  PROB_NCEP_MEAN_200107.f >TMPUSE_MEAN.f

cat EVALUE.f >>TMPUSE_MEAN.f

make -f makefile_mean

cd /ptmp/wx20yz/prob

rm mean.output
/nfsuser/g01/wx20yz/eprob/sorc/prob_mean <input

cp mean.output $HOME/global/vfprob/PROB${ensm}s_avg.$yymm
#cp mean.output $HOME/global/vfprob/PROB$ensm\scal_avg.$yymm
