7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
34c34
< tmpdir=$GTMP/$LOGNAME/evrfy_cmc16m_a
---
> tmpdir=$GTMP/yan.luo/evrfy_cmc16m_a
48c48
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
239c239
< $SHOME/$LOGNAME/evrfy/exec/VRFY_cmc16m_a20060530  <input0
---
> $SHOME/yan.luo/evrfy/exec/VRFY_cmc16m_a20060530  <input0
245c245
< cp  scores.z500 $NGLOBAL/$LOGNAME/evrfy/SCORESm.$stymd\00
---
> cp  scores.z500 $NGLOBAL/yan.luo/evrfy/SCORESm.$stymd\00
