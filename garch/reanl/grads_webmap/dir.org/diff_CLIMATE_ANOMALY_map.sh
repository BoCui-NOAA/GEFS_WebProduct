12c12
< tmpdir=$PTMP/$LOGNAME/canomaly
---
> tmpdir=$PTMP/yan.luo/canomaly
16c16
< cp $SHOME/$LOGNAME/grads/rgbset.gs .
---
> cp $SHOME/yan.luo/grads/rgbset.gs .
21c21
< fdir=$NGLOBAL/$LOGNAME/CDAS
---
> fdir=$NGLOBAL/yan.luo/CDAS
30c30
< CMM=`grep $MM $SHOME/$LOGNAME/bin/mon2mon | cut -c4-6`
---
> CMM=`grep $MM $SHOME/yan.luo/bin/mon2mon | cut -c4-6`
83c83
<  $SHOME/$LOGNAME/reanl/sorc_webmap/climate_anomaly_map.exe <input 
---
>  $SHOME/yan.luo/reanl/sorc_webmap/climate_anomaly_map.exe <input 
87c87
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >favg.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP.CTL >favg.ctl
91c91
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >fp10.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP.CTL >fp10.ctl
95c95
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >fp90.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP.CTL >fp90.ctl
99c99
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >aavg.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP.CTL >aavg.ctl
103c103
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >ap10.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP.CTL >ap10.ctl
107c107
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP.CTL >ap90.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP.CTL >ap90.ctl
120c120
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_NA.GS >amap_na.gs 
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP_NA.GS >amap_na.gs 
128c128
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_GB.GS >amap_gb.gs 
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP_GB.GS >amap_gb.gs 
136,137c136,137
< ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$PTMP/$LOGNAME/canomaly amap_na${CDATE}_$FHR.png
< ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$PTMP/$LOGNAME/canomaly amap_gb${CDATE}_$FHR.png
---
> ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$PTMP/yan.luo/canomaly amap_na${CDATE}_$FHR.png
> ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$PTMP/yan.luo/canomaly amap_gb${CDATE}_$FHR.png
175c175
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_NA.HTML >amap_na.html
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP_NA.HTML >amap_na.html
193c193
<     $SHOME/$LOGNAME/reanl/grads_webmap/AMAP_GB.HTML >amap_gb.html
---
>     $SHOME/yan.luo/reanl/grads_webmap/AMAP_GB.HTML >amap_gb.html
195,196c195,196
< ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/$LOGNAME/canomaly amap_na.html
< ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/$LOGNAME/canomaly amap_gb.html
---
> ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/yan.luo/canomaly amap_na.html
> ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/yan.luo/canomaly amap_gb.html
