DSET ^grads_EXPID.dat
options sequential template
*options big_endian
undef -9.9999E+2
TITLE NONE
*
XDEF 31 LINEAR  1.0 1.0
*
YDEF 4 LINEAR  1.0 1.0
*
ZDEF 1 LEVELS 500 
*
TDEF 365 LINEAR CYMDH 1dy
*                          RNCEP    CMC    ECMWF
VARS 99
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
ac14  01   99   SH Z AC of MRF                     
ac15  01   99   SH Z AC of CTL                     
ac16  01   99   SH Z AC of 00Zpa                   
ac17  01   99   SH Z AC of AVN                     
ac18  01   99   SH Z AC of 12Zpa                   
ac19  01   99   SH Z AC of 23tsa                   
ac20  01   99   SH Z AC of 00Zap                   
ac21  01   99   SH Z AC of 12Zap                   
ac22  01   99   SH Z AC of 20ems                   
ac23  01   99   SH Z AC of 23tms                   
ac24  01   99   SH Z AC of 23Med                   
ac25  01   99   SH Z AC of 00Med                   
ac26  01   99   SH Z AC of 12Med                   
ac27  01   99   TR Z AC of MRF                     
ac28  01   99   TR Z AC of CTL                     
ac29  01   99   TR Z AC of 00Zpa                   
ac30  01   99   TR Z AC of AVN                     
ac31  01   99   TR Z AC of 12Zpa                   
ac32  01   99   TR Z AC of 23tsa                   
ac33  01   99   TR Z AC of 00Zap                   
ac34  01   99   TR Z AC of 12Zap                   
ac35  01   99   TR Z AC of 20ems                   
ac36  01   99   TR Z AC of 23tms                   
ac37  01   99   TR Z AC of 23Med                   
ac38  01   99   TR Z AC of 00Med                   
ac39  01   99   TR Z AC of 12Med                   
rm1   01   99   NH Z RMS of MRF                     
rm2   01   99   NH Z RMS of CTL                     
rm3   01   99   NH Z RMS of 00Zpa                   
rm4   01   99   NH Z RMS of AVN                     
rm5   01   99   NH Z RMS of 12Zpa                   
rm6   01   99   NH Z RMS of 23tsa                   
rm7   01   99   NH Z RMS of 00Zap                   
rm8   01   99   NH Z RMS of 12Zap                   
rm9   01   99   NH Z RMS of 20ems                   
rm10  01   99   NH Z RMS of 23tms                   
rm11  01   99   NH Z RMS of 23Med                   
rm12  01   99   NH Z RMS of 00Med                   
rm13  01   99   NH Z RMS of 12Med                   
rm14  01   99   SH Z RMS of MRF                     
rm15  01   99   SH Z RMS of CTL                     
rm16  01   99   SH Z RMS of 00Zpa                   
rm17  01   99   SH Z RMS of AVN                     
rm18  01   99   SH Z RMS of 12Zpa                   
rm19  01   99   SH Z RMS of 23tsa                   
rm20  01   99   SH Z RMS of 00Zap                   
rm21  01   99   SH Z RMS of 12Zap                   
rm22  01   99   SH Z RMS of 20ems                   
rm23  01   99   SH Z RMS of 23tms                   
rm24  01   99   SH Z RMS of 23Med                   
rm25  01   99   SH Z RMS of 00Med                   
rm26  01   99   SH Z RMS of 12Med                   
rm27  01   99   TR Z RMS of MRF                     
rm28  01   99   TR Z RMS of CTL                     
rm29  01   99   TR Z RMS of 00Zpa                   
rm30  01   99   TR Z RMS of AVN                     
rm31  01   99   TR Z RMS of 12Zpa                   
rm32  01   99   TR Z RMS of 23tsa                   
rm33  01   99   TR Z RMS of 00Zap                   
rm34  01   99   TR Z RMS of 12Zap                   
rm35  01   99   TR Z RMS of 20ems                   
rm36  01   99   TR Z RMS of 23tms                   
rm37  01   99   TR Z RMS of 23Med                   
rm38  01   99   TR Z RMS of 00Med                   
rm39  01   99   TR Z RMS of 12Med                   
sp1   01   99   NH Z Spread of 23, 1st 10(T00Z), 2nd 10 and 20  members
sp2   01   99   SH Z Spread of 23, 1st 10(T00Z), 2nd 10 and 20  members
sp3   01   99   TR Z Spread of 23, 1st 10(T00Z), 2nd 10 and 20  members
tg1   01   99   NH Z Talagrand of T23m                                    
tg2   01   99   SH Z Talagrand of T23m 
tg3   01   99   TR Z Talagrand of T23m
tg4   01   99   NH Z Talagrand of T23m (T-1)                                    
tg5   01   99   SH Z Talagrand of T23m (T-1)
tg6   01   99   TR Z Talagrand of T23m (T-1)
tg7   01   99   NH Z Talagrand of T10m                                    
tg8   01   99   SH Z Talagrand of T10m 
tg9   01   99   TR Z Talagrand of T10m
tg10  01   99   NH Z Talagrand of T10m (T-1)                                    
tg11  01   99   SH Z Talagrand of T10m (T-1)
tg12  01   99   TR Z Talagrand of T10m (T-1)
tg13  01   99   NH Z Talagrand of T10m                                    
tg14  01   99   SH Z Talagrand of T10m 
tg15  01   99   TR Z Talagrand of T10m
tg16  01   99   NH Z Talagrand of T10m (T-1)                                    
tg17  01   99   SH Z Talagrand of T10m (T-1)
tg18  01   99   TR Z Talagrand of T10m (T-1)
ENDVARS

