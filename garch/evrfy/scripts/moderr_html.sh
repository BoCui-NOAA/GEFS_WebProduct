
if [ $# -lt 1 ]; then
  echo "Usage:$0 need [YYYYMMDDHH] input"
  exit 8
fi

HOME=/lfs/h2/emc/vpppg/save/yan.luo
ndatex=/apps/ops/prod/nco/core/prod_util.v2.0.5/exec/ndate
CDATE=$1

MM8=`$ndatex -192 $CDATE | cut -c5-6 `
MM7=`$ndatex -168 $CDATE | cut -c5-6 `
MM6=`$ndatex -144 $CDATE | cut -c5-6 `
MM5=`$ndatex -120 $CDATE | cut -c5-6 `
MM4=`$ndatex -96  $CDATE | cut -c5-6 `
MM3=`$ndatex -72  $CDATE | cut -c5-6 `
MM2=`$ndatex -48  $CDATE | cut -c5-6 `
MM1=`$ndatex -24  $CDATE | cut -c5-6 `
M00=`$ndatex -00  $CDATE | cut -c5-6 `
MP1=`$ndatex +24  $CDATE | cut -c5-6 `
MP2=`$ndatex +48  $CDATE | cut -c5-6 `
MP3=`$ndatex +72  $CDATE | cut -c5-6 `
MP4=`$ndatex +96  $CDATE | cut -c5-6 `
MP5=`$ndatex +120 $CDATE | cut -c5-6 `
MP6=`$ndatex +144 $CDATE | cut -c5-6 `
MP7=`$ndatex +168 $CDATE | cut -c5-6 `
MP8=`$ndatex +192 $CDATE | cut -c5-6 `
MP9=`$ndatex +216 $CDATE | cut -c5-6 `
DM8=`$ndatex -192 $CDATE | cut -c7-8 `
DM7=`$ndatex -168 $CDATE | cut -c7-8 `
DM6=`$ndatex -144 $CDATE | cut -c7-8 `
DM5=`$ndatex -120 $CDATE | cut -c7-8 `
DM4=`$ndatex -96  $CDATE | cut -c7-8 `
DM3=`$ndatex -72  $CDATE | cut -c7-8 `
DM2=`$ndatex -48  $CDATE | cut -c7-8 `
DM1=`$ndatex -24  $CDATE | cut -c7-8 `
D00=`$ndatex -00  $CDATE | cut -c7-8 `
DP1=`$ndatex +24  $CDATE | cut -c7-8 `
DP2=`$ndatex +48  $CDATE | cut -c7-8 `
DP3=`$ndatex +72  $CDATE | cut -c7-8 `
DP4=`$ndatex +96  $CDATE | cut -c7-8 `
DP5=`$ndatex +120 $CDATE | cut -c7-8 `
DP6=`$ndatex +144 $CDATE | cut -c7-8 `
DP7=`$ndatex +168 $CDATE | cut -c7-8 `
DP8=`$ndatex +192 $CDATE | cut -c7-8 `
DP9=`$ndatex +216 $CDATE | cut -c7-8 `
KYMDP8=`$ndatex +192 $CDATE`
KYMDP7=`$ndatex +168 $CDATE`
KYMDP6=`$ndatex +144 $CDATE`
KYMDP5=`$ndatex +120 $CDATE`
KYMDP4=`$ndatex +96  $CDATE`
KYMDP3=`$ndatex +72  $CDATE`
KYMDP2=`$ndatex +48  $CDATE`
KYMDP1=`$ndatex +24  $CDATE`
KYMD00=`$ndatex +00  $CDATE`
KYMD01=`$ndatex -24  $CDATE`
KYMD02=`$ndatex -48  $CDATE`
KYMD03=`$ndatex -72  $CDATE`
KYMD04=`$ndatex -96  $CDATE`
KYMD05=`$ndatex -120 $CDATE`
KYMD06=`$ndatex -144 $CDATE`
KYMD07=`$ndatex -168 $CDATE`
KYMD08=`$ndatex -192 $CDATE`
KYMD09=`$ndatex -216 $CDATE`

sed -e "s/YYYYMMDDP8/$KYMDP8/g" \
    -e "s/YYYYMMDDP7/$KYMDP7/g" \
    -e "s/YYYYMMDDP6/$KYMDP6/g" \
    -e "s/YYYYMMDDP5/$KYMDP5/g" \
    -e "s/YYYYMMDDP4/$KYMDP4/g" \
    -e "s/YYYYMMDDP3/$KYMDP3/g" \
    -e "s/YYYYMMDDP2/$KYMDP2/g" \
    -e "s/YYYYMMDDP1/$KYMDP1/g" \
    -e "s/YYYYMMDD00/$KYMD00/g" \
    -e "s/YYYYMMDDM1/$KYMD01/g" \
    -e "s/YYYYMMDDM2/$KYMD02/g" \
    -e "s/YYYYMMDDM3/$KYMD03/g" \
    -e "s/YYYYMMDDM4/$KYMD04/g" \
    -e "s/YYYYMMDDM5/$KYMD05/g" \
    -e "s/YYYYMMDDM6/$KYMD06/g" \
    -e "s/YYYYMMDDM7/$KYMD07/g" \
    -e "s/YYYYMMDDM8/$KYMD08/g" \
    -e "s/YYYYMMDDM9/$KYMD09/g" \
    -e "s/MM8/$MM8/g" \
    -e "s/MM7/$MM7/g" \
    -e "s/MM6/$MM6/g" \
    -e "s/MM5/$MM5/g" \
    -e "s/MM4/$MM4/g" \
    -e "s/MM3/$MM3/g" \
    -e "s/MM2/$MM2/g" \
    -e "s/MM1/$MM1/g" \
    -e "s/M00/$M00/g" \
    -e "s/MP1/$MP1/g" \
    -e "s/MP2/$MP2/g" \
    -e "s/MP3/$MP3/g" \
    -e "s/MP4/$MP4/g" \
    -e "s/MP5/$MP5/g" \
    -e "s/MP6/$MP6/g" \
    -e "s/MP7/$MP7/g" \
    -e "s/MP8/$MP8/g" \
    -e "s/MP9/$MP9/g" \
    -e "s/DM8/$DM8/g" \
    -e "s/DM7/$DM7/g" \
    -e "s/DM6/$DM6/g" \
    -e "s/DM5/$DM5/g" \
    -e "s/DM4/$DM4/g" \
    -e "s/DM3/$DM3/g" \
    -e "s/DM2/$DM2/g" \
    -e "s/DM1/$DM1/g" \
    -e "s/D00/$D00/g" \
    -e "s/DP1/$DP1/g" \
    -e "s/DP2/$DP2/g" \
    -e "s/DP3/$DP3/g" \
    -e "s/DP4/$DP4/g" \
    -e "s/DP5/$DP5/g" \
    -e "s/DP6/$DP6/g" \
    -e "s/DP7/$DP7/g" \
    -e "s/DP8/$DP8/g" \
    -e "s/DP9/$DP9/g" \
    $HOME/evrfy/scripts/mode.html >moderr.html

