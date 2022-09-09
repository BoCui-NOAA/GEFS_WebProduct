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
c     parameter (ix=144,iy=73,mlen=4960)
      parameter (ix=144,iy=73,mlen=1240)
      dimension fanl(ix,iy,mlen),f1(10512),f2(10512),f3(10512)
      dimension lmon(12),ldat(12),dmon(12)
      dimension aaa(mlen),bbb(101),ddd(40)
      dimension x1(20),y1(20),z1(20)
      dimension kpds(200),kgds(200)
      logical*1 lb(10512)
      character*80 cfilea(40)
      character*80 cfileo
      namelist /namin/ ifd,ilv,cfilea
      data cfileo/'pgrbfile'/

      call baopen (81,cfileo(1:8),ires)

      read (5,namin,end=1000)
      write(6,namin)

1000  continue

      lmon(1) = 720
      lmon(2) = 648
      lmon(3) = 720
      lmon(4) = 696
      lmon(5) = 720
      lmon(6) = 696
      lmon(7) = 720
      lmon(8) = 720
      lmon(9) = 696
      lmon(10) = 720
      lmon(11) = 696
      lmon(12) = 720

      dmon(1) = 5410.
      dmon(2) = 5410.
      dmon(3) = 5410.
      dmon(4) = 5410.
      dmon(5) = 5410.
      dmon(6) = 5410.
      dmon(7) = 5750.
      dmon(8) = 5410.
      dmon(9) = 5410.
      dmon(10) = 5410.
      dmon(11) = 5410.
      dmon(12) = 5410.

      ldat(1) = 1240
      ldat(2) = 1130
      ldat(3) = 1240
      ldat(4) = 1200
      ldat(5) = 1240
      ldat(6) = 1200
      ldat(7) = 1240
      ldat(8) = 1240
      ldat(9) = 1200
      ldat(10) = 1240
      ldat(11) = 1200
      ldat(12) = 1240

c     ifd=7
c     ilv=500 
c ----
c     convert initial time + forecast time to verified time
c ----
      kcnt=0
      do imo = 1, 12
      
       aaa=-9999.99
       bbb=-9999.99
       kcnt=kcnt+1
       icnt=0
       jcnt=1
       do iyr = 1959, 1998
        if (mod(iyr,4).eq.0) then
         lmon(2) = 672
        else
         lmon(2) = 648
        endif
        icnt = icnt+1
        idate=iyr*1000000 + imo*10000 + 100
        do nfhrs = 0, lmon(imo), 24
         call iaddate(idate,nfhrs,jdate)
c        print *, 'JCNT=',jcnt,jdate,' FILE=',cfilea(icnt)(1:14)
         call getgrb(fanl(1,1,jcnt),ix,iy,cfilea(icnt),ifd,ilv,jdate,
     *               0,10+icnt,kpds,kgds)
         if (fanl(50,25,jcnt).ge.-9990.00) then
         jcnt=jcnt+1
         else
         jcnt=jcnt
         endif
c        call fitr30(fanl(1,1,jcnt))
         call fitr20(fanl(1,1,jcnt))
        enddo
       enddo
    
       print *, 'jcnt=',jcnt-1,' ldat=',ldat(imo),' same?'

       lxy=0
       do jj = 1, iy
        do ii = 1, ix
         lxy = lxy + 1
c        do len = 1, ldat(imo)
         do len = 1, jcnt-1      
          aaa(len) = fanl(ii,jj,len)
         enddo
c        if (ii.eq.50.and.jj.eq.25) then
c         print *, 'aaa=',(aaa(len),len=1,ldat(imo))
c        endif

c        call sort(aaa,ldat(imo))
         call sort(aaa,jcnt-1)
         
         bbb(1) = aaa(1)
         bbb(101) = aaa(jcnt-1)
c        bbb(101) = aaa(ldat(imo))

         if (ii.eq.50.and.jj.eq.25) then
c         print *, ' '                                  
c         print *, 'aaa=',(aaa(len),len=1,ldat(imo))
          print *, 'int= 1 value=',bbb(1)
         endif

         do kk = 1, 99
c         iint = 1+kk*ldat(imo)/100.0
          iint = 1+kk*(jcnt-1)/100.0
          bbb(kk+1) = aaa(iint)
          if (ii.eq.50.and.jj.eq.25) then
c          if (kk.gt.1.and.mod(kk-1,10).eq.0) then
c          print *, 'int=',kk/10+1,' value=',bbb(kk+1)
c          endif
           print *, 'int=',kk+1,' value=',bbb(kk+1)
          endif
         enddo

          if (ii.eq.50.and.jj.eq.25) then
           print *, 'int= 101 value=',bbb(101)
          endif

         write (60+kcnt) (bbb(kk),kk=1,101)
 
        enddo
       enddo
      enddo

      stop
      end
