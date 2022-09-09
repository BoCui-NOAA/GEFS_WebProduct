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
      double precision ccc(mlen),prob,fmon(3),opara(3),davg
      dimension aaa(mlen),bbb(101),ddd(40)
      dimension x1(20),y1(20),z1(20)
      dimension kpds(200),kgds(200)
      logical*1 lb(10512)
      character*80 cfilea(40)
      character*80 cfileom,cfileos,cfileok
      namelist /namin/ cfilea
      data cfileom/'pgrbmean'/
      data cfileos/'pgrbstd'/
      data cfileok/'pgrbskew'/

      call baopen (81,cfileom(1:8),ires)
      call baopen (82,cfileos(1:8),ires)
      call baopen (83,cfileok(1:8),ires)

      read (5,namin,end=1000)
      write(6,namin)

1000  continue
c     lmon(1) = 738
c     lmon(2) = 666
c     lmon(3) = 738
c     lmon(4) = 714
c     lmon(5) = 738
c     lmon(6) = 714
c     lmon(7) = 738
c     lmon(8) = 738
c     lmon(9) = 714
c     lmon(10) = 738
c     lmon(11) = 714
c     lmon(12) = 738

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

c     ldat(1) = 4960
c     ldat(2) = 4520
c     ldat(3) = 4960
c     ldat(4) = 4800
c     ldat(5) = 4960
c     ldat(6) = 4800
c     ldat(7) = 4960
c     ldat(8) = 4960
c     ldat(9) = 4800
c     ldat(10) = 4960
c     ldat(11) = 4800
c     ldat(12) = 4960

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

      ifd=7
      ilv=500 
c ----
c     convert initial time + forecast time to verified time
c ----
      kcnt=0
c     do imo = 1, 12
      do imo = 1, 1 
      
       dst = dmon(imo)
c      dint= 10.0
       dint= 20.0
       kcnt=kcnt+1
       icnt=0
       jcnt=0
       do iyr = 1959, 1959
        if (mod(iyr,4).eq.0) then
c        lmon(2) = 690
         lmon(2) = 672
        else
         lmon(2) = 648
        endif
        icnt = icnt+1
        idate=iyr*1000000 + imo*10000 + 100
c       do nfhrs = 0, lmon(imo), 6
c       do nfhrs = 0, lmon(imo), 24
c       do nfhrs = 0, 0, 24
         nfhrs=0
         jcnt=jcnt+1
         jcnt=1
         call iaddate(idate,nfhrs,jdate)
c        print *, 'JCNT=',jcnt,jdate,' FILE=',cfilea(icnt)(1:14)
         call getgrb(fanl(1,1,jcnt),ix,iy,cfilea(icnt),ifd,ilv,jdate,
     *               0,10+icnt,kpds,kgds)
         print *, 'JCNT=',jcnt,jdate,' D3000=',fanl(1,1,jcnt)    
c        call fitr30(fanl(1,1,jcnt))
         call fitr20(fanl(1,1,jcnt))
         print *, 'JCNT=',jcnt,jdate,' D3000=',fanl(1,1,jcnt)    
c       enddo
       enddo

cccc   write out GRIB data
c      kpds(8)=59
c      kpds(9)=imo
c      kpds(10)=1 
c      kpds(11)=0 
c      kpds(12)=0 
c      kpds(13)=3
c      kpds(14)=1           
c      kpds(15)=1        
c      kpds(16)=132      
c      kpds(16)=51       
c      kpds(17)=0       
c      kpds(18)=23      
c      kpds(19)=0       
c      kpds(20)=20      
c      kpds(21)=1      
c      kpds(22)=0      
c      kpds(23)=2      
       call putgb(81,10512,kpds,kgds,lb,fanl(1,1,1),iret)

      enddo

      stop
      end
