rm -f cac8ys.ibmsp
rm -f nmc30y.ibmsp
ifort  -r8 -convert big_endian test.f
a.out

