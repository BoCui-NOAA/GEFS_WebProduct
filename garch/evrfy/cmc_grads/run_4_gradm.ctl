DSET ^gradm_EXPID.dat
options sequential template
undef -9.9999E+2
TITLE NONE
*  24 hours cycles
XDEF 16 LINEAR  1.0 1.0
*  3 different regions
YDEF 3 LINEAR  1.0 1.0
*
ZDEF 1 LEVELS 500 
*
TDEF 365 LINEAR CYMDH 1dy
*                          RNCEP    CMC    ECMWF
VARS 30
ac1   01   99   NH Z AC of CTL
ac2   01   99   NH Z AC of 4pA
ac3   01   99   NH Z AC of 4pB
ac4   01   99   NH Z AC of 5pr
ac5   01   99   NH Z AC of 16pa
ac6   01   99   NH Z AC of 17tsa
ac7   01   99   NH Z AC of 8ems
ac8   01   99   NH Z AC of 10ems
ac9   01   99   NH Z AC of 16ems
ac10  01   99   NH Z AC of 17tms
ac11  01   99   NH Z AC of Meds
ac14  01   99   NH Z AC of pn1
ac15  01   99   NH Z AC of pp1
ac16  01   99   NH Z AC of pn2
ac17  01   99   NH Z AC of pp2
ac18  01   99   NH Z AC of pn3
ac19  01   99   NH Z AC of pp3
ac20  01   99   NH Z AC of pn4
ac21  01   99   NH Z AC of pp4
ac22  01   99   NH Z AC of pn5
ac23  01   99   NH Z AC of pp5
ac24  01   99   NH Z AC of pn6
ac25  01   99   NH Z AC of pp6
ac26  01   99   NH Z AC of pn7
ac27  01   99   NH Z AC of pp7
ac28  01   99   NH Z AC of pn8
ac29  01   99   NH Z AC of pp8
ac34  01   99   NH Z AC of T00Z 10 members maximum
ac35  01   99   NH Z AC of T00Z 10 members minimum
ac37  01   99   NH Z AC of CTL better than members
ENDVARS

