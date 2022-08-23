SHELL=	/bin/sh
LIBS=	/nwprod/w3lib
SORC=   /wd2/wd20/wd20yz/ens/jif9703
getfld:	$(SORC)/getfld.f $(LIBS)
	cf77 $(SORC)/getfld.f -l $(LIBS) -o /dm/wd20yz/bin/getfld_tmp.x    
