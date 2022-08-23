###  Richard Grumm's temperal request ####
RZDMDIR=/home/people/emc/ftp/gc_wmb/yzhu

YMD=20060626
xxx=/ptmp/wx20yz

for CYC in 12
do

#ddir=/com/gens/prod/gefs.${YMD}/${CYC}
ddir=/ptmp/wx20yz/${YMD}

ftprzdm rzdm mkdir $RZDMDIR $xxx gefs.${YMD}
ftprzdm rzdm mkdir $RZDMDIR/gefs.${YMD} $xxx ${CYC}
ftprzdm rzdm mkdir $RZDMDIR/gefs.${YMD}/${CYC} $xxx pgrba_bc
ftprzdm rzdm mkdir $RZDMDIR/gefs.${YMD}/${CYC} $xxx pgrba_an

for mem in c00 p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 p11 p12 p13 p14
do

for FH in 06 12 18 24 30 36 42 48 54 60 66 72 78 84 90 96 102 108 114 120
do

ftprzdm rzdm put   $RZDMDIR/gefs.${YMD}/${CYC}/pgrba_an $ddir/pgrba_an ge${mem}.t${CYC}z.pgrba_anf${FH}
ftprzdm rzdm put   $RZDMDIR/gefs.${YMD}/${CYC}/pgrba_bc $ddir/pgrba_bc ge${mem}.t${CYC}z.pgrba_bcf${FH}

#ftprzdm rzdm delete $RZDMDIR/gefs.${ymdm3}/${CYC}/pgrba_an $ddir/pgrba_an ge${mem}.t${CYC}z.pgrba_anf${FH}
#ftprzdm rzdm delete $RZDMDIR/gefs.${ymdm3}/${CYC}/pgrba_bc $ddir/pgrba_bc ge${mem}.t${CYC}z.pgrba_bcf${FH}

done

done

#ftprzdm rzdm rmdir $RZDMDIR/gefs.${ymdm3}/${CYC} $xxx  pgrba_an
#ftprzdm rzdm rmdir $RZDMDIR/gefs.${ymdm3}/${CYC} $xxx pgrba_bc
#ftprzdm rzdm rmdir $RZDMDIR/gefs.${ymdm3} $xxx ${CYC}
#ftprzdm rzdm rmdir $RZDMDIR $xxx gefs.${ymdm3}

done

