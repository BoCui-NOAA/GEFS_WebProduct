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
VARS 60
ac1   01   99   NH Z AC of MRF      MRF    CTL     CTL
ac2   01   99   NH Z AC of CTL      CTL    4pA    12Zpa
ac3   01   99   NH Z AC of 00Zpa    10mpa  4pB    11tsa
ac4   01   99   NH Z AC of AVN      14mpa  5pr    10tms
ac5   01   99   NH Z AC of 12Zpa    15mpa  16pa   11tms
ac6   01   99   NH Z AC of 23tsa    16mpa  17tsa  10Med
ac7   01   99   NH Z AC of 00Zap    10map  8ems   11Med
ac8   01   99   NH Z AC of 12Zap    14map  10ems   none
ac9   01   99   NH Z AC of 20ems    15map  16ems   none
ac10  01   99   NH Z AC of 23tms    16map  17tms   none
ac11  01   99   NH Z AC of 23Med    10med  Meds    none
ac12  01   99   NH Z AC of 00Med    14med  None    none
ac13  01   99   NH Z AC of 12Med    15med  None    none
ac14  01   99   NH Z AC of          16med  None    none
ac15  01   99   NH Z AC of pn1
ac16  01   99   NH Z AC of pp1
ac17  01   99   NH Z AC of pn2
ac18  01   99   NH Z AC of pp2
ac19  01   99   NH Z AC of pn3
ac20  01   99   NH Z AC of pp3
ac21  01   99   NH Z AC of pn4
ac22  01   99   NH Z AC of pp4
ac23  01   99   NH Z AC of pn5
ac24  01   99   NH Z AC of pp5
ac25  01   99   NH Z AC of pn6
ac26  01   99   NH Z AC of pp6
ac27  01   99   NH Z AC of pn7
ac28  01   99   NH Z AC of pp7
ac29  01   99   NH Z AC of T00Z 10 members maximum
ac30  01   99   NH Z AC of T00Z 10 members minimum
ac31  01   99   NH Z AC of MRF better than members 
ac32  01   99   NH Z AC of CTL better than members
rm1   01   99   NH Z RMS of MRF      MRF    CTL     CTL
rm2   01   99   NH Z RMS of CTL      CTL    4pA    12Zpa
rm3   01   99   NH Z RMS of 00Zpa    10mpa  4pB    11tsa
rm4   01   99   NH Z RMS of AVN      14mpa  5pr    10tms
5m5   01   99   NH Z RMS of 12Zpa    15mpa  16pa   11tms
rm6   01   99   NH Z RMS of 23tsa    16mpa  17tsa  10Med
rm7   01   99   NH Z RMS of 00Zap    10map  8ems   11Med
rm8   01   99   NH Z RMS of 12Zap    14map  10ems   none
rm9   01   99   NH Z RMS of 20ems    15map  16ems   none
rm10  01   99   NH Z RMS of 23tms    16map  17tms   none
rm11  01   99   NH Z RMS of 23Med    10med  Meds    none
rm12  01   99   NH Z RMS of 00Med    14med  None    none
rm13  01   99   NH Z RMS of 12Med    15med  None    none
rm14  01   99   NH Z RMS of          16med  None    none
rm15  01   99   NH Z RMS of pn1
rm16  01   99   NH Z RMS of pp1
rm17  01   99   NH Z RMS of pn2
rm18  01   99   NH Z RMS of pp2
rm19  01   99   NH Z RMS of pn3
rm20  01   99   NH Z RMS of pp3
rm21  01   99   NH Z RMS of pn4
rm22  01   99   NH Z RMS of pp4
rm23  01   99   NH Z RMS of pn5
rm24  01   99   NH Z RMS of pp5
rm25  01   99   NH Z RMS of pn6
rm26  01   99   NH Z RMS of pp6
rm27  01   99   NH Z RMS of pn7
rm28  01   99   NH Z RMS of pp7
ENDVARS

