c
c  Main program    CLIMATE
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2004-09-30
c
c This is main program to get climatological data from 40-year re-analysis
c
c   subroutine
c              IADDATE---> to add forecast hours to initial data
c              GETGRB ---> to get GRIB format data
c              GRANGE ---> to calculate max. and min value of array
c
c   parameters:
c      ix    -- x-dimensional
c      iy    -- y-dimensional
c
c   Fortran 77 on IBMSP
c
C--------+---------+---------+---------+---------+----------+---------+--
      program UNCERTAINTY
      double precision ccc(10),fmon(3),opara(3),prob,amt

      data ccc/11.0, 1.0, 5.0,13.0,17.0,10.0, 8.0,23.0,31.0,12.0/
ccc
ccc       Using L-moment ratios and GEV method
ccc
C--------+---------+---------+---------+---------+---------+---------+---------+
c         print *, 'Calculates the L-moment ratios, by prob. weighted'
c     ccc=15.0
c     ccc(1)=14.999
c     ccc(2)=14.999

      write (*,'(10f7.2)') (ccc(i), i=1,10)
      call sort(ccc,10)

      opara = 0.0D0
ccc for unbiased estimation, A=B=ZERO
      call samlmr(ccc,10,fmon,3,-0.0D0,0.0D0)
      print *, "fmon=",fmon
      call pelgev(fmon,opara)
      print *, "opara=",opara
      prob=0.1
      fvalue=quagev(prob,opara)
      print *, "10% value is ",fvalue
      prob=0.5
      fvalue=quagev(prob,opara)
      print *, "50% value is ",fvalue
      prob=0.9
      fvalue=quagev(prob,opara)
      print *, "90% value is ",fvalue

      amt=11.28
      aa=(1.0-cdfgev(amt,opara))*100.00
      print *, "percentage of amt 11.28 is ",aa

      amt=5.5  
      aa=(1.0-cdfgev(amt,opara))*100.00
      print *, "percentage of amt 5.5 is ",aa

      amt=21.0 
      aa=(1.0-cdfgev(amt,opara))*100.00
      print *, "percentage of amt 21.0 is ",aa

      stop
      end

