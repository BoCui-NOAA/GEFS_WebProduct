############################################################################
###  shell script: valid_date.sh                                         ###
###        Y2K applied                                                   ###
###        First: Bob Kistler --- Cray UNICOS                            ###
###        Modified: Yuejian Zhu from both Cray UNICOS & IBM             ###
###        Date: 03/19/1999                                              ###
###                                                                      ###
###        Return: 0  Pass verified                                      ###
###                1  Fail pass for year ( 1900 - 2100 )                 ###
###                2  Fail pass for month ( 1 - 12 )                     ###
###                3  Fail pass for day   ( 1 - 28/29/30/31 )            ###
###                4  Fail pass for hour  ( 1 - 24 )                     ###
###                8  Fail pass the number test                          ###
###                                                                      ###
###                                                                      ###
############################################################################
yyyymmddhh=$1
if [ "`expr $yyyymmddhh : '[0-9]*'`" != "10" ] ; then
   echo "BAD date format $yyyymmddhh, err=8"
   exit 8
fi
year=`echo $yyyymmddhh | cut -c1-4`
if [ $year -gt 2100 -o $year -lt 1900 ] ; then
   echo "Invalid year=$year from $yyyymmddhh use YYYYMMDDHH between 1900-2100, err=1"
   exit 1
fi
month=`echo $yyyymmddhh | cut -c5-6`
if [ $month -gt 12 -o $month -le 0 ] ; then
   echo "Invalid month=$month from $yyyymmddhh use YYYYMMDDHH, err=2"
   exit 2
fi
day=`echo $yyyymmddhh | cut -c7-8`
if [ "`expr $month : '0[1,3,5,7,8]'`" = "2" -o\
   "`expr $month : '1[0,2]'`" = "2" ] ; then
   if [ $day -le 0 -o $day -gt 31 ] ; then
      echo "Invalid day=$day for month=$month use YYYYMMDDHH, err=3"
      exit 3
   fi
elif [ "`expr $month : '0[4,6,9]'`" = "2" -o $month -eq 11 ] ; then
     if [ $day -le 0 -o $day -gt 30 ] ; then
        echo "Invalid day=$day for month=$month use YYYYMMDDHH, err=3"
        exit 3
     fi
else
     if [ `expr $year % 4` -eq 0 ] ; then
        if [ $day -lt 0 -o $day -gt 29 ] ; then
           echo "Invalid day=$day for month=$month use YYYYMMDDHH, err=3"
           exit 3
        fi
     else
        if [ $day -lt 0 -o $day -gt 28 ] ; then
           echo "Invalid day=$day for month=$month use YYYYMMDDHH, err=3"
           exit 3
        fi
     fi
fi
hour=`echo $yyyymmddhh | cut -c9-10`
if [ $hour -gt 24 -o $hour -lt 0 ] ; then
   echo "Invalid hour=$hour from $yyyymmddhh use YYYYMMDDHH, err=4"
   exit 4
fi

