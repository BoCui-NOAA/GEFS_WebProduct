	yy=`echo $yyyy|cut -c3-4`
	if [ $yyyy -le 1957 ] ; then EXP_ID=v57 ; fi
	if [ $yyyy -eq 1982 ] ; then EXP_ID=v42 ; fi
	if [ $yyyy -eq 1983 ] ; then EXP_ID=v42 ; fi
	if [ $yyyy -eq 1984 ] ; then EXP_ID=v50 ; fi
	#if [ $yyyy -ge 1985 ] ; then EXP_ID=v02 ; fi
	if [ $yyyy -ge 1985 ] ; then EXP_ID=v50 ; fi
	if [ $yyyy -ge 1986 ] ; then EXP_ID=v02 ; fi
	set +u
	if [ $yyyy -eq 1987 ] ; then
		if [ -z "$yymm" ] ; then     
			echo "yymm not f=defined for $yyyy" 
			echo "yymm not f=defined for $yyyy" | mail $LOGNAME
			exit 8
		else
			if [ $yymm -ge 8707 -a $yymm -le 8712 ] ; then 
				EXP_ID=v03 
			else
				EXP_ID=v02 
			fi
		fi
	fi
	set -u
	if [ $yyyy -eq 1988 ] ; then EXP_ID=v03 ; fi
	if [ $yyyy -eq 1989 ] ; then EXP_ID=v03 ; fi
	if [ $yyyy -eq 1990 ] ; then EXP_ID=v04 ; fi
	if [ $yyyy -eq 1991 ] ; then EXP_ID=v41 ; fi
	if [ $yyyy -eq 1992 ] ; then EXP_ID=v43 ; fi
	if [ $yyyy -eq 1993 ] ; then EXP_ID=v43 ; fi
	if [ $yyyy -eq 1994 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1995 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1996 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1997 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1998 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -ge 1999 ] ; then EXP_ID=v54 ; fi
	if [ $yyyy -eq 1979 ] ; then EXP_ID=v53 ; fi
	if [ $yyyy -eq 1980 ] ; then EXP_ID=v51 ; fi
	if [ $yyyy -eq 1981 ] ; then EXP_ID=v51 ; fi
	temp=$yy
	for yy in 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78
	do
		if [ $yyyy -eq 19$yy ] ; then EXP_ID=v51 ; fi
	done
	yy=$temp
