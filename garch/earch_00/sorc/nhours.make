SHELL=	/bin/sh
LIBS=	/nwprod/w3lib
SORC=   /wd2/wd20/wd20yz/ens/jif9703
updhrs:	$(SORC)/updhrs.f $(LIBS)
	cf77 $(SORC)/updhrs.f -l $(LIBS) -o /dm/wd20yz/bin/updhrs.x    
