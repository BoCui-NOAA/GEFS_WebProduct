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
      program CLIMATE_map
      parameter (ix=144,iy=73,mlen=1240)
      dimension f1(10512),f2(10512),f3(10512)
      dimension fp1(10512),fp2(10512),fp3(10512),fp4(10512)
      dimension fp5(10512),fp6(10512)
      dimension fgrid(10512,10)
      double precision b1,b5,b9,b10,prob,fmon(3),opara(3),davg
      dimension aaa(mlen),bbb(10),ddd(40)
      dimension x1(20),y1(20),z1(20)
      dimension ipds(200),igds(200)
      dimension jpds(200),jgds(200)
      dimension kpds(200),kgds(200)
      logical*1 lb(10512)
      character*80 cfileom,cfileos,cfileok,cfileot,cpgbf
c     data cfileom/'/ptmp/wx20yz/CDAS/500HGT.mean'/
c     data cfileos/'/ptmp/wx20yz/CDAS/500HGT.stdv'/
c     data cfileok/'/ptmp/wx20yz/CDAS/500HGT.skew'/
      data cfileom/'/ptmp/wx20yz/CDAS/2MTMP.mean'/
      data cfileos/'/ptmp/wx20yz/CDAS/2MTMP.stdv'/
      data cfileok/'/ptmp/wx20yz/CDAS/2MTMP.skew'/
      data cfileot/'/ptmp/wx20yz/reanl_map/pgbf00'/
c     data cpgbf/'/global/ENS/z500.2005060900'/
      data cpgbf/'/global/ENS/t2m.2005060900'/

c     call baopenr (21,cfileom(1:29),ires)
      call baopenr (21,cfileom(1:28),ires)
      print *, 'ires=',ires
c     call baopenr (22,cfileos(1:29),ires)
      call baopenr (22,cfileos(1:28),ires)
      print *, 'ires=',ires
c     call baopenr (23,cfileok(1:29),ires)
      call baopenr (23,cfileok(1:28),ires)
      print *, 'ires=',ires
      call baopen  (81,cfileot(1:29),ires)
      print *, 'ires=',ires

      open(unit=99,file='grads_hgt.dat',form='UNFORMATTED')

1000  continue

c     ifd=7
      ifd=11
c     itp=100
      itp=105
c     ilv=500 
      ilv=2   
      idate=2005060900
      ifhr=120
c     fc2=100.0
      fc2=10.0
c     fc3=1000.0
      fc3=100.0
  
      call getgrbe(fgrid,cpgbf,ifd,itp,ilv,idate,ifhr,11)

c     do imo = 1, 12
      do imo = 6, 6
       print *, 'imo=',imo
       jj=0
       jpds=-1
       jgds=-1
       jpds(5)=ifd
       jpds(6)=itp
       jpds(7)=ilv
       jpds(8)=59
       jpds(9)=imo
       call getgb(21,0,10512,jj,jpds,jgds,kf,k,kpds,kgds,lb,f1,iret)
       if(iret.eq.0) then
        ipds=kpds
        igds=kgds
        call grange(kf,lb,f1,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       endif
       call getgb(22,0,10512,jj,jpds,jgds,kf,k,kpds,kgds,lb,f2,iret)
       if(iret.eq.0) then
        call grange(kf,lb,f2/fc2,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       endif
       call getgb(23,0,10512,jj,jpds,jgds,kf,k,kpds,kgds,lb,f3,iret)
       if(iret.eq.0) then
        call grange(kf,lb,f3/fc3,dmin,dmax)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
       endif
       f2=f2/fc2 
       f3=f3/fc3  
       lxy=0
       do jj = 1, iy
        do ii = 1, ix
         lxy = lxy + 1
         do kk= 1, 10
          bbb(kk)=fgrid(lxy,kk)
         enddo
         call sort(bbb,10)
ccc  for 3-parameter input and output
         fmon(1)=f1(lxy)
         fmon(2)=f2(lxy)
         fmon(3)=f3(lxy)
         print 991, (fmon(kk),kk=1,3),bbb(1),bbb(10)
         b1=bbb(1)
         b5=(bbb(5)+bbb(6))/2.0
         b9=bbb(10)
         call pelgev(fmon,opara)
         fp1(lxy)=bbb(1)
         fp2(lxy)=cdfgev(b1,opara)
         fp3(lxy)=(bbb(5)+bbb(6))/2.0
         fp4(lxy)=cdfgev(b5,opara)
         fp5(lxy)=bbb(10)
         fp6(lxy)=cdfgev(b9,opara)
         print 992, (opara(kk),kk=1,3),fp1(lxy),fp5(lxy)
c        do kk = 1001, 1, -1
c         prob = (kk-1)/1000.0
c         if (kk.eq.1001) prob=0.999999
c         if (kk.eq.1)  prob=0.0
c         aaa(1002-kk)=quagev(1.0-prob,opara)
c        enddo
        enddo
       enddo
      enddo

 888  format (i4,2x,8i5,i8,2f9.2)

c     ipds(5)=ifd
c     ipds(6)=100
c     ipds(7)=ilv
c     ipds(8)=59
c     ipds(9)=imo
c     ipds(10)=13
c     ipds(11)=0
c     ipds(12)=0

      print *, (ipds(kk),kk=1,25)

      ipds(14)=0
      call putgb(81,10512,ipds,igds,lb,fp1,iret)
      ipds(14)=6
      call putgb(81,10512,ipds,igds,lb,fp2*1000.,iret)
      ipds(14)=12
      call putgb(81,10512,ipds,igds,lb,fp3,iret)
      ipds(14)=18
      call putgb(81,10512,ipds,igds,lb,fp4*1000.,iret)
      ipds(14)=24
      call putgb(81,10512,ipds,igds,lb,fp5,iret)
      ipds(14)=30
      call putgb(81,10512,ipds,igds,lb,fp6*1000.,iret)

 991  format(' fmon=',5f10.4)
 992  format('opara=',5f10.4)
      stop
      end
