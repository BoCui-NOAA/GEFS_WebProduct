SHELL=  /bin/sh
CMD=	ensppf
FC=     xlf_r
FOPTS=  -qsmp=noauto
LOPTS=
INCS=
SRCS=	ENSPPF.f 
LIBS=	/nwprod/w3lib90/bacio_4_604 \
	/nwprod/w3lib90/w3lib_4_604 \
	/mp/nfsuser/g01/wx20mi/w3lib90/iplib_4_604 \
	/mp/nfsuser/g01/wx20mi/w3lib90/splib_4_604 \
	-l essl
$(CMD): $(SRCS)
	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o $(CMD)
ensppf:	$(SRCS)
	$(FC) $(FOPTS) $(SRCS) /nwprod/w3lib90/iplib_4_604 $(LIBS) -o ensppf
