if [ $# -ne 2 ] ; then
	echo "usage: $0 pp yymmddhh where pp is the hour change to date "
	exit 8
fi

export nhoursx

pp=$1
nchars=`expr $pp : '.*'`
#check for signed number
if [ `expr $pp : '[-,+,0-9][0-9]*'` -ne $nchars ] ; then
	echo " hour update = $pp not a signed integer "  
	exit 8
fi
wrk1=$TMPDIR/wrk1.$$
wrk2=$TMPDIR/wrk2.$$
yymmddhh=$2

if [ "`expr $yymmddhh : '[0-9]*'`" != "8" ] ; then 
	echo "BAD date format $yyddmmhh"
	exit 8
fi
year=`echo $yymmddhh | cut -c1-2`
month=`echo $yymmddhh | cut -c3-4`
if [ $month -gt 12 -o $month -le 0 ] ; then
	echo "invalid month=$month from $yymmddhh use YYMMDDHH"
	exit 8
fi
day=`echo $yymmddhh | cut -c5-6`
if [ "`expr $month : '0[1,3,5,7,8]'`" = "2" -o\
	 "`expr $month : '1[0,2]'`" = "2" ] ; then
	if [ $day -le 0 -o $day -gt 31 ] ; then
		echo "invalid day=$day for month=$month use YYMMDDHH"
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
			echo "invalid day=$day for month=$month use YYMMDDHH"
			exit 8
		fi
	else
		if [ $day -lt 0 -o $day -gt 28 ] ; then
			echo "invalid day=$day for month=$month use YYMMDDHH"
			exit 8
		fi
	fi
fi
hour=`echo $yymmddhh | cut -c7-8`
if [ $hour -gt 24 -o $hour -lt 0 ] ; then
	echo "invalid hour=$hour from $yymmddhh use YYMMDDHH"
	exit 8
fi

if [ $? -ne 0 ] ; then exit 8 ; fi

year=`echo $yymmddhh | cut -c1-2`
month=`echo $yymmddhh | cut -c3-4`
day=`echo $yymmddhh | cut -c5-6`
hour=`echo $yymmddhh | cut -c7-8`

echo " &NAMIN IYEAR=$year,IMONTH=$month,IDAY=$day,IHOUR=$hour,NHOURS=$1 &END">$wrk1
$nhoursx <$wrk1 >$wrk2 2>/dev/null
grep "DATE  C2" $wrk2 | cut -c9-16
rm $wrk1 $wrk2
