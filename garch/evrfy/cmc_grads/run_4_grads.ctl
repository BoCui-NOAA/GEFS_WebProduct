DSET ^grads_EXPID.dat
options sequential template
undef -9.9999E+2
TITLE NONE
*
XDEF 16 LINEAR  1.0 1.0
*
YDEF 4 LINEAR  1.0 1.0
*
ZDEF 1 LEVELS 500 
*
TDEF 365 LINEAR CYMDH 1dy
*                         CMC
VARS 75
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
ac21  01   99   SH Z AC of CTL  
ac22  01   99   SH Z AC of 4pA 
ac23  01   99   SH Z AC of 4pB
ac24  01   99   SH Z AC of 5pr       
ac25  01   99   SH Z AC of 16pa     
ac26  01   99   SH Z AC of 17tsa     
ac27  01   99   SH Z AC of 8ems      
ac28  01   99   SH Z AC of 10ems     
ac29  01   99   SH Z AC of 16ems     
ac30  01   99   SH Z AC of 17tms    
ac31  01   99   SH Z AC of Meds     
ac41  01   99   TR Z AC of CTL  
ac42  01   99   TR Z AC of 4pA 
ac43  01   99   TR Z AC of 4pB
ac44  01   99   TR Z AC of 5pr       
ac45  01   99   TR Z AC of 16pa     
ac46  01   99   TR Z AC of 17tsa     
ac47  01   99   TR Z AC of 8ems      
ac48  01   99   TR Z AC of 10ems     
ac49  01   99   TR Z AC of 16ems     
ac50  01   99   TR Z AC of 17tms    
ac51  01   99   TR Z AC of Meds     
rm1   01   99   NH Z RMS of CTL  
rm2   01   99   NH Z RMS of 4pA 
rm3   01   99   NH Z RMS of 4pB
rm4   01   99   NH Z RMS of 5pr       
rm5   01   99   NH Z RMS of 16pa     
rm6   01   99   NH Z RMS of 17tsa     
rm7   01   99   NH Z RMS of 8ems      
rm8   01   99   NH Z RMS of 10ems     
rm9   01   99   NH Z RMS of 16ems     
rm10  01   99   NH Z RMS of 17tms    
rm11  01   99   NH Z RMS of Meds     
rm21  01   99   SH Z RMS of CTL  
rm22  01   99   SH Z RMS of 4pA 
rm23  01   99   SH Z RMS of 4pB
rm24  01   99   SH Z RMS of 5pr       
rm25  01   99   SH Z RMS of 16pa     
rm26  01   99   SH Z RMS of 17tsa     
rm27  01   99   SH Z RMS of 8ems      
rm28  01   99   SH Z RMS of 10ems     
rm29  01   99   SH Z RMS of 16ems     
rm30  01   99   SH Z RMS of 17tms    
rm31  01   99   SH Z RMS of Meds     
rm41  01   99   TR Z RMS of CTL  
rm42  01   99   TR Z RMS of 4pA 
rm43  01   99   TR Z RMS of 4pB
rm44  01   99   TR Z RMS of 5pr       
rm45  01   99   TR Z RMS of 16pa     
rm46  01   99   TR Z RMS of 17tsa     
rm47  01   99   TR Z RMS of 8ems      
rm48  01   99   TR Z RMS of 10ems     
rm49  01   99   TR Z RMS of 16ems     
rm50  01   99   TR Z RMS of 17tms    
rm51  01   99   TR Z RMS of Meds     
sp1   01   99   NH Z Spread of 23, 1st 10(T00Z), 2nd 10 and 20  members
sp2   01   99   SH Z Spread of 23, 1st 10(T00Z), 2nd 10 and 20  members
sp3   01   99   TR Z Spread of 23, 1st 10(T00Z), 2nd 10 and 20  members
tg1   01   99   NH Z Talagrand of T10m                                    
tg2   01   99   SH Z Talagrand of T10m 
tg3   01   99   TR Z Talagrand of T10m
tg4   01   99   NH Z Talagrand of T10m (T-1)                                    
tg5   01   99   SH Z Talagrand of T10m (T-1)
tg6   01   99   TR Z Talagrand of T10m (T-1)
ENDVARS

