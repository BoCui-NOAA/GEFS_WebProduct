SHELL=  /bin/sh
CMD=    wpqpf
FC=     ifort
#FOPTS=  -qsmp=noauto
LOPTS=
INCS=
SRCS=   pgrads.f 
LIBS    = -L/nwprod/lib -lip_4 -lsp_4 -lbacio_4 -lw3nco_4
#LIBS=   /nwprod/w3lib90/bacio_4_604 \
#	/nwprod/w3lib90/w3lib_4_604 \
#	/nfsuser/g01/wx20mi/w3lib90/iplib_4_604 \
#	/nfsuser/g01/wx20mi/w3lib90/splib_4_604 \
#	-l essl
$(CMD): $(SRCS)
	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o $(CMD)
#wpqpf:	$(SRCS)
#	$(FC) $(FOPTS) $(SRCS) /nwprod/w3lib90/iplib_4_604 $(LIBS) -o wpqpf

