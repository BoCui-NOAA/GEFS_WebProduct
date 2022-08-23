SHELL=  /bin/sh
CMD=	../exec/cmc_10_grads_daily
FC=     ${FCMP}
#FOPTS=  -qsmp=noauto
LOPTS=
INCS=
SRCS=	10m_cmc_grads.f 
#LIBS    = -L/nwprod/lib -lip_4 -lsp_4 -lbacio_4 -lw3nco_4
#LIBS=	/nwprod/lib/libbacio_4.a \
#	/nwprod/lib/libw3_4.a \
#        /nwprod/lib/libip_4.a \
#        /nwprod/lib/libsp_4.a \
#	-l essl
$(CMD): $(SRCS)
	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o $(CMD)
vrfy0:	$(SRCS)
	$(FC) $(FOPTS) $(SRCS) /nwprod/w3lib90/iplib_4_604 $(LIBS) -o vrfy0
