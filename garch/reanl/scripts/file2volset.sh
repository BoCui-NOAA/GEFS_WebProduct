#volsetlist=/nfsuser/g01/wx23bk/cdas/parm/volset_tapes
#filelist=/nfsuser/g01/wx23bk/cdas/parm/volset_file
volsetlist=./volset_tapes
filelist=./volset_file
#. /nfsuser/g01/wx23bk/cdas/ush/EXP_ID.sh
. ./EXP_ID.sh
nl=`cat $filelist|wc -l`
n=0;volname=""
while [ $n -lt $nl ]      
do
	n=`expr $n + 1`
	line=`sed -n $n,${n}p $filelist` 
	testfile=`echo $line | awk '{print $2}'`
	if [ "$file" = "$testfile" ] ; then 
		volname=`echo $line | awk '{print $1}'`
		break 
	fi
done
#. $SCRIPTS/CRL_ID.sh
if [ -n "$volname" ] ; then
	volindex=`awk '$2~/'"$volname"'/{print $1}' $volsetlist`
	#volset=$CRL_ID/$EXP_ID.$volindex.$yyyy
	volset=$EXP_ID.$volindex.$yyyy
else
	if [ $file = pgb. -o $file = flux. ] ; then
	#volset=$CRL_ID/$EXP_ID.a26.$yyyy
	volset=$EXP_ID.a26.$yyyy
	fi
fi
