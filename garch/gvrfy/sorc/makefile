SHELL=  /bin/sh
CMD=	vrfy 
FC=     ifort
FOPTS=  -r8  -convert big_endian     
LOPTS=
INCS=
SRCS=   VFMAIN.f GETANL.f GET23Y.f GRANGE.f ACGRID.f GRD2WV.f LATWMN.f \
	SUMWAV.f RMSAWT.f GETCAC.f
LIBS=   /nwprod/lib/libbacio_4.a \
        /nwprod/lib/libw3nco_d.a \
        /nwprod/lib/libip_d.a \
        /nwprod/lib/libsp_d.a 
$(CMD): $(SRCS)
	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o $(CMD)
vrfy0:	$(SRCS)
	$(FC) $(FOPTS) $(SRCS) /nwprod/w3lib90/iplib_4_604 $(LIBS) -o vrfy0
