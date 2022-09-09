7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
34c34
< tmpdir=$GTMP/$LOGNAME/evrfy_14m_ab
---
> tmpdir=$GTMP/yan.luo/evrfy_14m_ab
48c48
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
239c239
< $SHOME/$LOGNAME/evrfy/exec/VRFY_14m_a20060530 <input0
---
> $SHOME/yan.luo/evrfy/exec/VRFY_14m_a20060530 <input0
245c245
< cat scores.z1000 scores.z500 >$NGLOBAL/$LOGNAME/evrfy/SCORESb.$stymd\00
---
> cat scores.z1000 scores.z500 >$NGLOBAL/yan.luo/evrfy/SCORESb.$stymd\00
