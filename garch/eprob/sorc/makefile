SHELL=  /bin/bash
CMD=	prob   
#FC=     ncepxlf
FC=     ifort
#FOPTS=  -qsmp=noauto
#FFLAGS=  -list -traceback  -r8   -convert big_endian -assume byterecl
FFLAGS=   -convert big_endian  
#FOPTS=  -r8  -convert big_endian
LDFLAGS=
INCS=
SRCS=      TMPUSE.f GETANL.f GETGRB_10m.f ND2YMD.f GRANGE.f
OBJS=    $(SRCS:.f=.o)
#LIBS    = -l essl -L/nwprod/lib -lbacio_4 -lw3_4 -lip_4 -lsp_4 
LIBS    = -L/nwprod/lib -lbacio_4 -lw3nco_4
#$(CMD): $(SRCS)
#	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o $(CMD)
#global_pgrb_enscqpf: $(SRCS)
#	$(FC) $(FOPTS) $(SRCS) $(LIBS) -o cqpf

# Lines from here on down should not need to be changed.  They are the
# actual rules which make uses to build a.out.
#
all:    $(CMD)

$(CMD): $(OBJS)
	$(FC) $(LDFLAGS) $(FFLAGS) -o $(@) $(OBJS) $(LIBS)

$(OBJS):        $(SRCS)
	$(FC) $(FFLAGS) $(INCS) -c $(SRCS)

$(OBJS):        makefile

allclean:       clean all

clean:
	-rm -f $(OBJS)

clobber:        clean
	-rm -f $(CMD)
