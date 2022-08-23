SHELL=  /bin/sh
CMD=	ensadd.x
FC=     ifort
FOPTS=  -r8  -convert big_endian
#FOPTS=  -qsmp=noauto
LOPTS=
INCS=
SRCS=	ENSADD.f 
LIBS=   /nwprod/lib/libbacio_4.a \
        /nwprod/lib/libw3nco_d.a \
        /nwprod/lib/libip_d.a \
        /nwprod/lib/libsp_d.a
$(CMD): $(SRCS)
	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o $(CMD)
ensadd: $(SRCS)
	$(FC) $(FOPTS) $(SRCS) /nwprod/w3lib90/iplib_4_604 $(LIBS) -o ensadd
