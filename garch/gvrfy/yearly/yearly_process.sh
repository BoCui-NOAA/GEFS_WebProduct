
set +x

>yearly.dat
>NH500Z_pac.dat
>SH500Z_pac.dat
>NH500Z_rms.dat
>SH500Z_rms.dat

>TR850U_rms.dat
>TR850V_rms.dat
>TR850S_rms.dat
>TR850R_rms.dat

>TR200U_rms.dat
>TR200V_rms.dat
>TR200S_rms.dat
>TR200R_rms.dat

for yyyy in 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006
do
 echo " We are processing year of $yyyy"
 export STYMD=$yyyy\0101
 export EDYMD=$yyyy\1231   

 echo $yyyy$mm `RUN_4_GRADS.sh | grep "Result value" | awk '{print $4}'` >>yearly.dat

done

awk -f awk_pac_NH500Z.c yearly.dat >>NH500Z_pac.dat
awk -f awk_pac_SH500Z.c yearly.dat >>SH500Z_pac.dat
awk -f awk_rms_NH500Z.c yearly.dat >>NH500Z_rms.dat
awk -f awk_rms_SH500Z.c yearly.dat >>SH500Z_rms.dat
 
awk -f awk_rms_TR850U.c yearly.dat >>TR850U_rms.dat
awk -f awk_rms_TR850V.c yearly.dat >>TR850V_rms.dat
awk -f awk_rms_TR850S.c yearly.dat >>TR850S_rms.dat
awk -f awk_rms_TR850R.c yearly.dat >>TR850R_rms.dat

awk -f awk_rms_TR200U.c yearly.dat >>TR200U_rms.dat
awk -f awk_rms_TR200V.c yearly.dat >>TR200V_rms.dat
awk -f awk_rms_TR200S.c yearly.dat >>TR200S_rms.dat
awk -f awk_rms_TR200R.c yearly.dat >>TR200R_rms.dat

#rm yearly_grads.dat
#
#yearly_grads_3-5-7
