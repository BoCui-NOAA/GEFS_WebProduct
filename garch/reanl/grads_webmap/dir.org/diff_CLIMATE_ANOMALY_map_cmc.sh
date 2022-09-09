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
88c88
<  $SHOME/$LOGNAME/reanl/sorc_webmap/climate_anomaly_map_cmc.exe <input 
---
>  $SHOME/yan.luo/reanl/sorc_webmap/climate_anomaly_map_cmc.exe <input 
92c92
<     $SHOME/$LOGNAME//reanl/grads_webmap/CAMAP.CTL >favg.ctl
---
>     $SHOME/yan.luo//reanl/grads_webmap/CAMAP.CTL >favg.ctl
96c96
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP.CTL >fp10.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP.CTL >fp10.ctl
100c100
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP.CTL >fp90.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP.CTL >fp90.ctl
104c104
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP.CTL >aavg.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP.CTL >aavg.ctl
108c108
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP.CTL >ap10.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP.CTL >ap10.ctl
112c112
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP.CTL >ap90.ctl
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP.CTL >ap90.ctl
125c125
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP_NA.GS >camap_na.gs 
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP_NA.GS >camap_na.gs 
133c133
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP_GB.GS >camap_gb.gs 
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP_GB.GS >camap_gb.gs 
141,142c141,142
< ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/$LOGNAME/canomaly camap_na${CDATE}_$FHR.png
< ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/$LOGNAME/canomaly camap_gb${CDATE}_$FHR.png
---
> ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/yan.luo/canomaly camap_na${CDATE}_$FHR.png
> ftpemcrzdm emcrzdm put $RZDMDIR/$CDATE /$ptmp/yan.luo/canomaly camap_gb${CDATE}_$FHR.png
180c180
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP_NA.HTML >camap_na.html
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP_NA.HTML >camap_na.html
198c198
<     $SHOME/$LOGNAME/reanl/grads_webmap/CAMAP_GB.HTML >camap_gb.html
---
>     $SHOME/yan.luo/reanl/grads_webmap/CAMAP_GB.HTML >camap_gb.html
200,201c200,201
< ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/$LOGNAME/canomaly camap_na.html
< ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/$LOGNAME/canomaly camap_gb.html
---
> ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/yan.luo/canomaly camap_na.html
> ftpemcrzdm emcrzdm put $RZDMDIR /$PTMP/yan.luo/canomaly camap_gb.html
