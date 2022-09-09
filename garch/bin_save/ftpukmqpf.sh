
if [ $# -lt 1 ]; then
  echo "Usage: $0 need input [yyyymmddhh]"
  exit 8
fi

 cd /usr3/yzhu/ukmet

 ymdh=$1
 hh=`echo $ymdh | cut -c9-10`
 ymd6=`echo $ymdh | cut -c3-8`

 ftp -i -n <<EOF1

 open email.meto.gov.uk

 user anonymous yuejian.zhu@noaa.gov

 cd  pub/fr/gppn

 bin

 get GPPN$hh$ymd6.GZ

 quit

 EOF1

