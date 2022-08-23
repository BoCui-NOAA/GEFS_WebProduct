SHELL=	/bin/sh
LIBS=	/nwprod/w3lib
SORC=   /wd2/wd20/wd20yz/ens/jif9703
prcpcv:	$(SORC)/prcpcv_new.f $(LIBS)
	cf77 $(SORC)/prcpcv_new.f -l $(LIBS) -o /dm/wd20yz/bin/prcpcv_new.x    
