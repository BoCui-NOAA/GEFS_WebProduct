SHELL= 	/bin/bash
#INC=     /nwprod/lib/incmod/g2_4
#LIBS=    -L/nwprod/lib -lg2_4 -lw3nco_4 -lbacio_4 \
	 #-ljasper -lpng -lz
SRCSf90= CQPF_24HR_30M.f90 INIT_PARM.f90 PRINTINFR.f90 change_template4.f90
SRCSf=   EPDF.f SORTMM.f
SRCS=    $(SRCSf90) $(SRCSf)
OBJS=    $(SRCSf:.f=.o) $(SRCSf90:.f90=.o)
CMD=   	gefs_enscqpf_24hr_30m
#FC= 	ifort
#FFLAGS = -O3 -g -convert big_endian -I $(INC)
LDFLAGS=

# Lines from here on down should not need to be changed.  They are the
# actual rules which make uses to build a.out.
#
all:    $(CMD)

$(CMD):		$(OBJS)
	$(FC) $(LDFLAGS) -o $(@) $(OBJS) $(LIBS)
	rm -f $(OBJS)

$(OBJS):        $(SRCS)
	$(FC) $(FFLAGS) -c $(SRCS)

$(OBJS):        makefile

allclean:       clean all

clean:
	-rm -f $(OBJS)

install:
	mv $(CMD) ../../exec/$(CMD)


