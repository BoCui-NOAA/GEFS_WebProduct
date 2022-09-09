8,9c8,9
< #@ output = /tmp/$LOGNAME/fits.o$(jobid)
< #@ error = /tmp/$LOGNAME/fits.e$(jobid)
---
> #@ output = /tmp/yan.luo/fits.o$(jobid)
> #@ error = /tmp/yan.luo/fits.e$(jobid)
36c36
< tmpdir=$stmp/$LOGNAME/vfens 
---
> tmpdir=$stmp/yan.luo/vfens 
258c258
< cp outlier.z500 $NGLOBAL/$LOGNAME/evfscores/OUTLIEs.$stymd\00
---
> cp outlier.z500 $NGLOBAL/yan.luo/evfscores/OUTLIEs.$stymd\00
269c269
< rm /$stmp/$LOGNAME/vfens/*
---
> rm /$stmp/yan.luo/vfens/*
