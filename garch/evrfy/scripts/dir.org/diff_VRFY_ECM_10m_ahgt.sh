7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
34c34
< tmpdir=$GTMP/$LOGNAME/evrfy_ecm_a
---
> tmpdir=$GTMP/yan.luo/evrfy_ecm_a
48c48
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
239c239
< $SHOME/$LOGNAME/evrfy/exec/vrfy_ecm_20030101  <input0
---
> $SHOME/yan.luo/evrfy/exec/vrfy_ecm_20030101  <input0
245c245
< cat scores.z1000 scores.z500 >$NGLOBAL/$LOGNAME/evrfy/SCORESe.$stymd\00
---
> cat scores.z1000 scores.z500 >$NGLOBAL/yan.luo/evrfy/SCORESe.$stymd\00
257c257
< #$SHOME/$LOGNAME/evrfy/ecm_grads/RUN_4_GRADS.sh
---
> #$SHOME/yan.luo/evrfy/ecm_grads/RUN_4_GRADS.sh
