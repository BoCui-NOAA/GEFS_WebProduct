SHELL=	/bin/sh
LIBS=	/nwprod/w3lib
LIB1=	/usr/local/lib/libimsl.a
LIB2=	/usr/local/lib/libimslblas.a
SORC=   /wd2/wd20/wd20yz/ens/jif9703
ensppf:	$(SORC)/ensppf_pe3.f $(LIBS) $(LIB1) $(LIB2)
	cf77 $(SORC)/ensppf_pe3.f -l $(LIBS) $(LIB1) $(LIB2) -o /dm/wd20yz/bin/ensppf_pe3.x    
