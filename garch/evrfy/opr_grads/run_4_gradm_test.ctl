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
TDEF 366 LINEAR CYMDH 1dy
*                          RNCEP    CMC    ECMWF
VARS 70
ac1   01   99   NH Z AC of MRF      CTL     CTL
ac2   01   99   NH Z AC of CTL      4pA    12Zpa   
ac3   01   99   NH Z AC of 00Zpa    4pB    11tsa   
ac4   01   99   NH Z AC of AVN      5pr    10tms   
ac5   01   99   NH Z AC of 12Zpa    16pa   11tms   
ac6   01   99   NH Z AC of 23tsa    17tsa  10Med   
ac7   01   99   NH Z AC of 00Zap    8ems   11Med   
ac8   01   99   NH Z AC of 12Zap    10ems   none   
ac9   01   99   NH Z AC of 20ems    16ems   none  
ac10  01   99   NH Z AC of 23tms    17tms   none  
ac11  01   99   NH Z AC of 23Med    Meds    none   
ac12  01   99   NH Z AC of 00Med    None    none   
ac13  01   99   NH Z AC of 12Med    None    none   
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
ac24  01   99   NH Z AC of pn1
ac25  01   99   NH Z AC of pp1
ac26  01   99   NH Z AC of pn2
ac27  01   99   NH Z AC of pp2
ac28  01   99   NH Z AC of pn3
ac29  01   99   NH Z AC of pp3
ac30  01   99   NH Z AC of pn4
ac31  01   99   NH Z AC of pp4
ac32  01   99   NH Z AC of pn5
ac33  01   99   NH Z AC of pp5
ac34  01   99   NH Z AC of T00Z 10 members maximum
ac35  01   99   NH Z AC of T00Z 10 members minimum
ac36  01   99   NH Z AC of MRF better than members 
ac37  01   99   NH Z AC of CTL better than members
rm1   01   99   NH Z RMS of MRF      CTL     CTL
rm2   01   99   NH Z RMS of CTL      4pA    12Zpa   
rm3   01   99   NH Z RMS of 00Zpa    4pB    11tsa   
rm4   01   99   NH Z RMS of AVN      5pr    10tms   
rm5   01   99   NH Z RMS of 12Zpa    16pa   11tms   
rm6   01   99   NH Z RMS of 23tsa    17tsa  10Med   
rm7   01   99   NH Z RMS of 00Zap    8ems   11Med   
rm8   01   99   NH Z RMS of 12Zap    10ems   none   
rm9   01   99   NH Z RMS of 20ems    16ems   none  
rm10  01   99   NH Z RMS of 23tms    17tms   none  
rm11  01   99   NH Z RMS of 23Med    Meds    none   
rm12  01   99   NH Z RMS of 00Med    None    none   
rm13  01   99   NH Z RMS of 12Med    None    none   
rm14  01   99   NH Z RMS of pn1
rm15  01   99   NH Z RMS of pp1
rm16  01   99   NH Z RMS of pn2
rm17  01   99   NH Z RMS of pp2
rm18  01   99   NH Z RMS of pn3
rm19  01   99   NH Z RMS of pp3
rm20  01   99   NH Z RMS of pn4
rm21  01   99   NH Z RMS of pp4
rm22  01   99   NH Z RMS of pn5
rm23  01   99   NH Z RMS of pp5
rm24  01   99   NH Z RMS of pn1
rm25  01   99   NH Z RMS of pp1
rm26  01   99   NH Z RMS of pn2
rm27  01   99   NH Z RMS of pp2
rm28  01   99   NH Z RMS of pn3
rm29  01   99   NH Z RMS of pp3
rm30  01   99   NH Z RMS of pn4
rm31  01   99   NH Z RMS of pp4
rm32  01   99   NH Z RMS of pn5
rm33  01   99   NH Z RMS of pp5
ENDVARS

