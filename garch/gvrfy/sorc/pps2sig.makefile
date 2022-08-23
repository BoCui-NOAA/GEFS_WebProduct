INCS	=-I/nwprod/lib/incmod/sigio_4
LIBS	=-L/nwprod/lib -lbacio_4 -lw3_d -lip_d -lsp_d -lsigio_4 -lessl
pps2sig.x:	pps2sig.f funcphys.o physcons.o machine.o 
	xlf90 -qlist -qsource -bnoquiet -qsmp=noauto -qrealsize=8 pps2sig.f funcphys.o physcons.o machine.o $(INCS) $(LIBS) -o pps2sig.x
funcphys.o:	funcphys.f physcons.o machine.o
	xlf90 -O2 -c funcphys.f
physcons.o:	physcons.f machine.o
	xlf90 -O2 -c physcons.f
machine.o:	machine.f
	xlf90 -O2 -c machine.f
