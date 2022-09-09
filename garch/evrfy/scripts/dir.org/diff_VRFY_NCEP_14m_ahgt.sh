7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
34c34
< tmpdir=$GTMP/$LOGNAME/evrfy_14m_a
---
> tmpdir=$GTMP/yan.luo/evrfy_14m_a
48c48
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
241c241
< $SHOME/$LOGNAME/evrfy/exec/VRFY_14m_a20060530 <input0
---
> $SHOME/yan.luo/evrfy/exec/VRFY_14m_a20060530 <input0
247c247
< cat scores.z1000 scores.z500 >$NGLOBAL/$LOGNAME/evrfy/SCORESs.$stymd\00
---
> cat scores.z1000 scores.z500 >$NGLOBAL/yan.luo/evrfy/SCORESs.$stymd\00
261c261
< /gpfs/dell2/emc/verification/save/$LOGNAME/evrfy/opr_grads/RUN_4_GRADS_new.sh
---
> /gpfs/dell2/emc/verification/save/yan.luo/evrfy/opr_grads/RUN_4_GRADS_new.sh
