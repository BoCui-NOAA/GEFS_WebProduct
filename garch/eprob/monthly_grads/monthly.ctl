DSET ^monthly_grads.dat
options sequential template
undef -9.9999E+2
TITLE NONE
*
XDEF 1 LINEAR  1.0 1.0
*
YDEF 1 LINEAR  1.0 1.0
*
ZDEF 1 LEVELS 500 
*
TDEF 365 LINEAR 00Z01dec99 1mo
*                       
VARS 2 
nhrpss    01   99   NH Z AC of MRF 
nheval    01   99   NH Z AC of MRF 
ENDVARS

