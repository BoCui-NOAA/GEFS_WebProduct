7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
33c33
< tmpdir=$GTMP/$LOGNAME/vfens_cmc16m_f 
---
> tmpdir=$GTMP/yan.luo/vfens_cmc16m_f 
47c47
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
244c244
< $SHOME/$LOGNAME/evrfy/exec/VRFY_cmc16m_f20060530 <input0
---
> $SHOME/yan.luo/evrfy/exec/VRFY_cmc16m_f20060530 <input0
250c250
< cat scores.z500 >$NGLOBAL/$LOGNAME/evfscores/SCORESm.$stymd\00
---
> cat scores.z500 >$NGLOBAL/yan.luo/evfscores/SCORESm.$stymd\00
