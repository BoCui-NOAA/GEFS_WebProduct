7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
33c33
< tmpdir=$GTMP/$LOGNAME/vfens_ecm_f
---
> tmpdir=$GTMP/yan.luo/vfens_ecm_f
47c47
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
236c236
< $SHOME/$LOGNAME/evrfy/exec/vrfy_ecm_10  <input0
---
> $SHOME/yan.luo/evrfy/exec/vrfy_ecm_10  <input0
242c242
< cat scores.z1000 scores.z500 >$NGLOBAL/$LOGNAME/evfscores/SCORESe.$stymd\00
---
> cat scores.z1000 scores.z500 >$NGLOBAL/yan.luo/evfscores/SCORESe.$stymd\00
