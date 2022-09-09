7,8c7,8
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
34c34
< tmpdir=$GTMP/$LOGNAME/evrfy_14m_abtmp
---
> tmpdir=$GTMP/yan.luo/evrfy_14m_abtmp
48c48
< dat=$SHOME/$LOGNAME/gvrfy/data
---
> dat=$SHOME/yan.luo/gvrfy/data
249c249
< $SHOME/$LOGNAME/evrfy/exec/VRFY_14m_atmp <input0
---
> $SHOME/yan.luo/evrfy/exec/VRFY_14m_atmp <input0
255c255
< cat scores.t850 scores.t2m >$NGLOBAL/$LOGNAME/evrfy/SCOTMPb.$stymd\00
---
> cat scores.t850 scores.t2m >$NGLOBAL/yan.luo/evrfy/SCOTMPb.$stymd\00
