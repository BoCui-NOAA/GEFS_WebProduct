
if [ $# -lt 1 ]; then
   echo "Usage:$0 need input"
   echo "1). HH (cycle)"
   exit 8
fi

tmpdir=/ptmp/wx20yz/canomaly
mkdir $tmpdir
cd    $tmpdir
nhoursx=/nwprod/util/exec/ndate
HH=$1             

#fmean1=/nbns/global/wx20yz/CDAS_cyc/cmean_1d.19590228$HH
#fmean2=/nbns/global/wx20yz/CDAS_cyc/cmean_1d.19590301$HH
#fmean3=/nbns/global/wx20yz/CDAS_cyc/cmean_1d.19590229$HH
#fstdv1=/nbns/global/wx20yz/CDAS_cyc/cstdv_1d.19590228$HH
#fstdv2=/nbns/global/wx20yz/CDAS_cyc/cstdv_1d.19590301$HH
#fstdv3=/nbns/global/wx20yz/CDAS_cyc/cstdv_1d.19590229$HH

fmean1=/nbns/global/wx20yz/CDAS_cyc/cmean.19590228$HH
fmean2=/nbns/global/wx20yz/CDAS_cyc/cmean.19590301$HH
fmean3=/nbns/global/wx20yz/CDAS_cyc/cmean.19590229$HH
fstdv1=/nbns/global/wx20yz/CDAS_cyc/cstdv.19590228$HH
fstdv2=/nbns/global/wx20yz/CDAS_cyc/cstdv.19590301$HH
fstdv3=/nbns/global/wx20yz/CDAS_cyc/cstdv.19590229$HH

 echo "&namin " >input
 echo "cmean1='$fmean1'," >>input
 echo "cmean2='$fmean2'," >>input
 echo "cmean3='$fmean3'," >>input
 echo "cstdv1='$fstdv1'," >>input
 echo "cstdv2='$fstdv2'," >>input
 echo "cstdv3='$fstdv3'," >>input
 echo "/" >>input

rm $fmean3 $fstdv3

 $HOME/reanl/exec/get_feb29.exe <input

