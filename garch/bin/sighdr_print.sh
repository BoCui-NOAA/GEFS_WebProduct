
if [ $# -lt 1 ]; then
 echo "Usage: $0 need sigma file input"
 exit 8
fi

set +x

xxx=`/global/save/wx20yz/bin/global_sighdr $1`
icnt=1   
for dd in `echo $xxx`
do

echo "$icnt $dd"

icnt=`expr $icnt + 1 `

done
