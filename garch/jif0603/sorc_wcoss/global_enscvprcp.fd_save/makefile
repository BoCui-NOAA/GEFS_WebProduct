SHELL=  /bin/bash
CMD=	global_enscvprcp  
#FC=     ncepxlf
FC=     ifort
#FOPTS=  -qsmp=noauto
#FOPTS=  -traceback -g -DUNDERSCORE
FFLAGS=  -traceback -list 
FFLAGS=  -traceback -list -g -convert big_endian -assume byterecl
LDFLAGS=  -openmp
INCS=
SRCS=	CVPRCP.f
OBJS=   $(SRCS:.f=.o)

#LIBS    = -l essl -L/nwprod/lib -lbacio_4 -lw3_4 -lip_4 -lsp_4 
#LIBS    = -L/nwprod/lib -lbacio_4 -lw3_4 -lip_4 -lsp_4 
#LIBS    = -L/nwprod/lib -lw3_4 -lbacio_4 -lip_d -lsp_4  -lw3_4
#LIBS    = -L/nwprod/lib -lw3_4 -lbacio_4 -lip_d -lsp_4
#LIBS    = -L/nwprod/lib -lbacio_4 -lip_d -lsp_4  -lw3_4
LIBS    = -L/nwprod/lib -lip_4 -lsp_4 -lbacio_4 -lw3nco_4

#$(CMD): $(SRCS)
#	$(FC) $(FOPTS) ${LOPTS} $(SRCS) $(LIBS) -o $(CMD)
#global_enspvrfy: $(SRCS)
#	$(FC) $(FOPTS) ${LOPTS} $(SRCS) $(LIBS) -o pvrfy

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
