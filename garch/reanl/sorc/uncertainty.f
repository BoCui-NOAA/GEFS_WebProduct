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

ccc
ccc       Using L-moment ratios and GEV method
ccc
C--------+---------+---------+---------+---------+---------+---------+---------+
c         print *, 'Calculates the L-moment ratios, by prob. weighted'

      ccc(1)  = 11.0
      ccc(2)  =  1.0
      ccc(3)  =  5.0
      ccc(4)  = 13.0
      ccc(5)  = 17.0
      ccc(6)  = 10.0
      ccc(7)  =  8.0
      ccc(8)  = 23.0
      ccc(9)  = 31.0
      ccc(10) = 12.0
c     ccc(1)  =  1.0
c     ccc(2)  =  5.0
c     ccc(3)  =  8.0
c     ccc(4)  = 10.0
c     ccc(5)  = 11.0
c     ccc(6)  = 12.0
c     ccc(7)  = 13.0
c     ccc(8)  = 17.0
c     ccc(9)  = 23.0
c     ccc(10) = 31.0
c     ccc(1)  =  1.0
c     ccc(2)  =  4.0
c     ccc(3)  =  6.0
c     ccc(4)  =  7.0
c     ccc(5)  =  7.5
c     ccc(6)  =  7.5
c     ccc(7)  =  8.0
c     ccc(8)  =  9.0
c     ccc(9)  = 11.0
c     ccc(10) = 14.0
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
      amt=1.28
c     amt=7.50
      aa=(1.0-cdfgev(amt,opara))*100.00
c     print *, "percentage of amt 7.5 is ",aa
      print *, "percentage of amt 11.28is ",aa

      stop
      end

