DSET ^grads_EXPID.dat
options sequential template
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
*
VARS 105
ac1   01   99   NH Z AC of MRF                     
ac2   01   99   NH Z AC of CTL                     
ac3   01   99   NH Z AC of 00Zpa                   
ac4   01   99   NH Z AC of AVN                     
ac5   01   99   NH Z AC of 12Zpa                   
ac6   01   99   NH Z AC of 23tsa                   
ac7   01   99   NH Z AC of 00Zap                   
ac8   01   99   NH Z AC of 12Zap                   
ac9   01   99   NH Z AC of 20ems                   
ac10  01   99   NH Z AC of 23tms                   
ac11  01   99   NH Z AC of 23Med                   
ac12  01   99   NH Z AC of 00Med                   
ac13  01   99   NH Z AC of 12Med                   
ac14  01   99   NH Z AC of highest score of T00Z 10 members
ac15  01   99   SH Z AC of MRF                     
ac16  01   99   SH Z AC of CTL                     
ac17  01   99   SH Z AC of 00Zpa                   
ac18  01   99   SH Z AC of AVN                     
ac19  01   99   SH Z AC of 12Zpa                   
ac20  01   99   SH Z AC of 23tsa                   
ac21  01   99   SH Z AC of 00Zap                   
ac22  01   99   SH Z AC of 12Zap                   
ac23  01   99   SH Z AC of 20ems                   
ac24  01   99   SH Z AC of 23tms                   
ac25  01   99   SH Z AC of 23Med                   
ac26  01   99   SH Z AC of 00Med                   
ac27  01   99   SH Z AC of 12Med                   
ac28  01   99   SH Z AC of highest score of T00Z 10 members
ac29  01   99   TR Z AC of MRF                     
ac30  01   99   TR Z AC of CTL                     
ac31  01   99   TR Z AC of 00Zpa                   
ac32  01   99   TR Z AC of AVN                     
ac33  01   99   TR Z AC of 12Zpa                   
ac34  01   99   TR Z AC of 23tsa                   
ac35  01   99   TR Z AC of 00Zap                   
ac36  01   99   TR Z AC of 12Zap                   
ac37  01   99   TR Z AC of 20ems                   
ac38  01   99   TR Z AC of 23tms                   
ac39  01   99   TR Z AC of 23Med                   
ac40  01   99   TR Z AC of 00Med                   
ac41  01   99   TR Z AC of 12Med                   
ac42  01   99   TR Z AC of highest score of T00Z 10 members
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
rm14  01   99   NH Z RMS of lowest error of T00Z 10 members
rm15  01   99   SH Z RMS of MRF                     
rm16  01   99   SH Z RMS of CTL                     
rm17  01   99   SH Z RMS of 00Zpa                   
rm18  01   99   SH Z RMS of AVN                     
rm19  01   99   SH Z RMS of 12Zpa                   
rm20  01   99   SH Z RMS of 23tsa                   
rm21  01   99   SH Z RMS of 00Zap                   
rm22  01   99   SH Z RMS of 12Zap                   
rm23  01   99   SH Z RMS of 20ems                   
rm24  01   99   SH Z RMS of 23tms                   
rm25  01   99   SH Z RMS of 23Med                   
rm26  01   99   SH Z RMS of 00Med                   
rm27  01   99   SH Z RMS of 12Med                   
rm28  01   99   SH Z RMS of lowest error of T00Z 10 members
rm29  01   99   TR Z RMS of MRF                     
rm20  01   99   TR Z RMS of CTL                     
rm21  01   99   TR Z RMS of 00Zpa                   
rm32  01   99   TR Z RMS of AVN                     
rm33  01   99   TR Z RMS of 12Zpa                   
rm34  01   99   TR Z RMS of 23tsa                   
rm35  01   99   TR Z RMS of 00Zap                   
rm36  01   99   TR Z RMS of 12Zap                   
rm37  01   99   TR Z RMS of 20ems                   
rm38  01   99   TR Z RMS of 23tms                   
rm39  01   99   TR Z RMS of 23Med                   
rm40  01   99   TR Z RMS of 00Med                   
rm41  01   99   TR Z RMS of 12Med                   
rm42  01   99   TR Z RMS of lowest error of T00Z 10 members
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

