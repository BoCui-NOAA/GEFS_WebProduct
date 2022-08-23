DSET ^season_grads.dat
options sequential template
undef -9.9999E+2
TITLE NONE
*
XDEF 16 LINEAR  1.0 1.0
*
YDEF 1 LINEAR  1.0 1.0
*
ZDEF 1 LEVELS 500 
*
TDEF 365 LINEAR 00Z01JUL00 3mo
*                       
VARS 14
nhacmrf   01   99   NH Z AC of MRF 
nhacctl   01   99   NH Z AC of MRF 
nhacens   01   99   NH Z AC of MRF 
nhrmmrf   01   99   NH Z AC of MRF 
nhrmctl   01   99   NH Z AC of MRF 
nhrmens   01   99   NH Z AC of MRF 
nhrmsrd   01   99   NH Z AC of MRF 
shacmrf   01   99   NH Z AC of MRF 
shacctl   01   99   NH Z AC of MRF 
shacens   01   99   NH Z AC of MRF 
shrmmrf   01   99   NH Z AC of MRF 
shrmctl   01   99   NH Z AC of MRF 
shrmens   01   99   NH Z AC of MRF 
shrmsrd   01   99   NH Z AC of MRF 
ENDVARS

