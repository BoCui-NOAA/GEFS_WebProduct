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
      program CLIMATE
      parameter (ix=144,iy=73)
      dimension fanl(ix,iy,4960)
      dimension lmon(12),ldat(12)
      double precision ccc(4960),prob,fmon(3),opara(3)
      dimension aaa(4960),bbb(101)
      dimension kpds(200),kgds(200)
      character*80 cfilea(40)
      namelist /namin/ cfilea

      read (5,namin,end=1000)
      write(6,namin)

1000  continue
      lmon(1) = 738
      lmon(2) = 666
      lmon(3) = 738
      lmon(3) = 738
      lmon(4) = 714
      lmon(5) = 738
      lmon(6) = 714
      lmon(7) = 738
      lmon(8) = 738
      lmon(9) = 714
      lmon(10) = 738
      lmon(11) = 714
      lmon(12) = 738

      ldat(1) = 4960
      ldat(2) = 4520
      ldat(3) = 4960
      ldat(4) = 4800
      ldat(5) = 4960
      ldat(6) = 4800
      ldat(7) = 4960
      ldat(8) = 4960
      ldat(9) = 4800
      ldat(10) = 4960
      ldat(11) = 4800
      ldat(12) = 4960

      ifd=52
      ifd=33
      ifd=11
      ifd=7
      ilv=1000
      ilv=700 
      ilv=250 
      ilv=850 
      ilv=250 
      ilv=850 
      ilv=500 
      ilv=250 
      ilv=700 
      ilv=10  
      ilv=2  
      ilv=500 
c ----
c     convert initial time + forecast time to verified time
c ----
      kcnt=0
C     do imo = 1, 12
      do imo = 1, 1
      
       kcnt=kcnt+1
       icnt=0
       jcnt=0
       do iyr = 1959, 1998
        if (mod(iyr,4).eq.0) then
         lmon(2) = 690
        else
         lmon(2) = 666
        endif
        icnt = icnt+1
        idate=iyr*1000000 + imo*10000 + 100
        do nfhrs = 0, lmon(imo), 6
         jcnt=jcnt+1
         call iaddate(idate,nfhrs,jdate)
c        print *, 'JCNT=',jcnt,jdate,' FILE=',cfilea(icnt)(1:14)
         call getgrb(fanl(1,1,jcnt),ix,iy,cfilea(icnt),ifd,ilv,jdate,
     *               0,10+icnt,kpds,kgds)
        enddo
       enddo

       do jj = 1, iy
        do ii = 1, ix
         do len = 1, ldat(imo)
          aaa(len) = fanl(ii,jj,len)
         enddo
         call sort(aaa,ldat(imo))
         do len = 1, ldat(imo)
          ccc(len) = aaa(len)       
         enddo
         bbb(1) = aaa(1)
         bbb(101) = aaa(ldat(imo))

         if (ii.eq.50.and.jj.eq.25) then
          print *, 'int= 1 value=',bbb(1)
         endif

         do kk = 1, 99
          iint = 1+kk*ldat(imo)/100.0
          bbb(kk+1) = aaa(iint)

          if (ii.eq.50.and.jj.eq.25) then
           if (kk.gt.1.and.mod(kk-1,10).eq.0) then
           print *, 'int=',kk/10+1,' value=',bbb(kk+1)
           endif
          endif

         enddo

          if (ii.eq.50.and.jj.eq.25) then
           print *, 'int= 11 value=',bbb(101)
          endif

         write (60+kcnt) (bbb(kk),kk=1,101)
 
          if (ii.eq.50.and.jj.eq.25) then
         opara = 0.0D0
         call samlmr(ccc,ldat(imo),fmon,3,-0.35D0,0.0D0)
c        call samlmu(ccc,ldat(imo),fmon,5)
         call pelgev(fmon,opara)
c        do kk = 1, 11   
         do kk = 11, 1, -1
          prob = (kk-1)/10.0 - 0.0001
          if (kk.eq.11) prob=0.99999
          if (kk.eq.1)  prob=0.00001
          fvalue=quagev(1.0-prob,opara)
          if (ii.eq.50.and.jj.eq.25) then
           print *, 'lm ',12-kk,' value=',fvalue
          endif
         enddo
          endif

        enddo
       enddo

      enddo

      stop
      end
