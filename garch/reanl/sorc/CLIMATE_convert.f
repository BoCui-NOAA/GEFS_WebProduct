c
c  Main program    CLIMATE_convert
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2005-06-07
c
c  This is program to convert 101 climate data and 3-parameter to distribution
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
      program CLIMATE_convert
      parameter (ix=144,iy=73,mlen=1240)
      dimension f1(10512),f2(10512),f3(10512)
      double precision ccc(mlen),prob,fmon(3),opara(3),davg
      dimension aaa(mlen),bbb(101),ddd(40)
      dimension x1(20),y1(20),z1(20)
      dimension kpds(200),kgds(200)
      dimension jpds(200),jgds(200)
      logical*1 lb(10512)
      character*80 cfileom,cfileos,cfileok
      data cfileom/'/global/CDAS/500HGT.mean'/
      data cfileos/'/global/CDAS/500HGT.stdv'/
      data cfileok/'/global/CDAS/500HGT.skew'/

      call baopenr (21,cfileom(1:24),ires)
      print *, 'ires=',ires
      call baopenr (22,cfileos(1:24),ires)
      print *, 'ires=',ires
      call baopenr (23,cfileok(1:24),ires)
      print *, 'ires=',ires

      open(unit=99,file='grads_hgt.dat',form='UNFORMATTED')
      open(unit=41,file='/global/CDAS/500HGT.JAN',form='UNFORMATTED')

1000  continue

      ifd=7
      ilv=500 
      dst=5410.
      dint=20.

c     do imo = 1, 12
      do imo = 1, 1
       print *, 'imo=',imo
       jj=0
       jpds=-1
       jgds=-1
       jpds(5)=ifd
       jpds(6)=100
       jpds(7)=ilv
       jpds(8)=59
       jpds(9)=imo
       call getgb(21,0,10512,jj,jpds,jgds,kf,k,kpds,kgds,lb,f1,iret)
       if(iret.eq.0) then
        call grange(kf,lb,f1,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       endif
       call getgb(22,0,10512,jj,jpds,jgds,kf,k,kpds,kgds,lb,f2,iret)
       if(iret.eq.0) then
        call grange(kf,lb,f2/100.,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       endif
       call getgb(23,0,10512,jj,jpds,jgds,kf,k,kpds,kgds,lb,f3,iret)
       if(iret.eq.0) then
        call grange(kf,lb,f3/100000.,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       endif
       f2=f2/100.
       f3=f3/100000.
       lxy=0
       do jj = 1, iy
        do ii = 1, ix
         lxy = lxy + 1

ccc  for 3-parameter input and output
         if (ii.eq.50.and.jj.eq.25) then
          fmon(1)=f1(lxy)
          fmon(2)=f2(lxy)
          fmon(3)=f3(lxy)
          print *, 'fmon=',fmon
          call pelgev(fmon,opara)
          print *, 'opara=',opara
          do kk = 1001, 1, -1
           prob = (kk-1)/1000.0
           if (kk.eq.1001) prob=0.999999
           if (kk.eq.1)  prob=0.0
           aaa(1002-kk)=quagev(1.0-prob,opara)
          enddo
          do llen = 1, 20
           x1(llen) = dst + dint*(llen-1)
           anum = x1(llen) + dint/2.0
           do len = 1, 1001
            if (aaa(len).le.anum) then
             y1(llen) = len
            endif
            if (llen.ge.2) then
             z1(llen) = (y1(llen) - y1(llen-1))/1001.
            else
             z1(llen) = y1(llen)/1001.
            endif
           enddo
          enddo
          write (99) (z1(llen),llen=1,20)
          print *, 'data20=',z1
         endif

         read (40+imo) (bbb(kk),kk=1,101)

ccc   for 101 data input and output
         if (ii.eq.50.and.jj.eq.25) then
c         print *, 'bbb=',(bbb(kk),kk=1,101)            
          do llen = 1, 20
           x1(llen) = dst + dint*(llen-1)
           anum = x1(llen) + dint/2.0
           do len = 1, 101
            if (bbb(len).le.anum) then
             y1(llen) = len
            endif
            if (llen.ge.2) then
             z1(llen) = (y1(llen) - y1(llen-1))/101.              
            else
             z1(llen) = y1(llen)/101.
            endif
           enddo
          enddo
          write (99) (z1(llen),llen=1,20)
          print *, 'data20=',z1
         endif
        enddo
       enddo
      enddo

 888  format (i4,2x,8i5,i8,2f9.2)

      stop
      end
