yyyymmddhh=$1
if [ "`expr $yyyymmddhh : '[0-9]*'`" != "10" ] ; then 
	echo "BAD date format $yyyymmddhh"
	exit 8
fi
year=`echo $yyyymmddhh | cut -c1-4`
month=`echo $yyyymmddhh | cut -c5-6`
if [ $month -gt 12 -o $month -le 0 ] ; then
	echo "invalid month=$month from $yyyymmddhh use YYYYMMDDHH"
	exit 8
fi
day=`echo $yyyymmddhh | cut -c7-8`
if [ "`expr $month : '0[1,3,5,7,8]'`" = "2" -o\
	 "`expr $month : '1[0,2]'`" = "2" ] ; then
	if [ $day -le 0 -o $day -gt 31 ] ; then
		echo "invalid day=$day for month=$month use YYYYMMDDHH"
		exit 8
	fi
elif [ "`expr $month : '0[4,6,9]'`" = "2" -o $month -eq 11 ] ; then
	if [ $day -le 0 -o $day -gt 30 ] ; then
		echo "invalid day=$day for month=$month use YYMMDDHH"
	exit 8
	fi
else 
	if [ `expr $year % 4` -eq 0 ] ; then
		if [ $day -lt 0 -o $day -gt 29 ] ; then
			echo "invalid day=$day for month=$month use YYYYMMDDHH"
			exit 8
		fi
	else
		if [ $day -lt 0 -o $day -gt 28 ] ; then
			echo "invalid day=$day for month=$month use YYYYMMDDHH"
			exit 8
		fi
	fi
fi
hour=`echo $yyyymmddhh | cut -c9-10`
if [ $hour -gt 24 -o $hour -lt 0 ] ; then
	echo "invalid hour=$hour from $yyyymmddhh use YYYYMMDDHH"
	exit 8
fi
