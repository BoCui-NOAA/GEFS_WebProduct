      program test1                                       
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: READ CLIMATE PRESSURE FILE ON GRIB FORMAT               C
C            WITH GRID POINT VALUE                                   C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: unblocked GRIB FORMAT PRESSURE FILE                     C
C                                                                    C
C     OUTPUT:2.5*2.5 degree grid resolution cover global ( 144*73 )  C
C                                                                    C
C     Arguments:                                                     C
C               1. glb(144,73)                                       C
C               2. ifd ( field ID input )                            C
C               3. ilev ( level input )                              C
C               4. imon ( month input )                              C
C               5. ihr  ( hour of date input )                       C
C               6. ifh  ( forecast hours at ihr )                    C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c--------+----------+----------+----------+----------+----------+----------+--
      parameter(mdata=20000)
      dimension kpds(25),kgds(22),jpds(25),jgds(22)
      dimension glb(144,73),data(mdata)               
      dimension jlev(12)                 
      character*2  cim(12)
      character*80 cpgb,cpgi    
      logical*1   lb(mdata)
      data      jlev/1000, 850, 700, 500, 400, 300, 
     .                250, 200, 150, 100,  75,  50/
      data      cim /'01','02','03','04','05','06',
     .               '07','08','09','10','11','12'/
      data      cpgb/'/global/cdas/pgb.f00'/
      data      cpgi/'/global/cdas/pgb.f00'/
c
      ifd=7
      ilev=500
      ihr=00
      ifh=00
      glb=-9999.99
      open(unit=51,file='xxxx',form='UNFORMATTED')
      do imon = 1, 12
      do j = 1, 12
      if (jlev(j).eq.ilev) goto 100
      enddo
      goto 993
  100 continue
      cpgb(21:22)=cim(imon)
      cpgi(21:22)=cim(imon)
      itime=ihr+ifr
      if (mod(itime,24).eq.0) then
         cpgb(23:26)='.00Z'
         cpgi(23:32)='.00Z.index'
      else if (mod(itime,24).eq.12) then
         cpgb(23:26)='.12Z'
         cpgi(23:32)='.12Z.index'
      else
         goto 994
      endif
      print *, cpgb(1:26)   
      print *, cpgi(1:32)   
      call baopenr(11,cpgb(1:26),iretb)
      call baopenr(21,cpgi(1:32),ireti)
      print *, '=== Read 23 years CDAS/Reanl Climatology data ==='
c     print *, ' Month =',imon,' fld =',ifd,' level =',ilev,
c    .         ' itime =',itime    
      j       = -1
      jpds    = -1
      jgds    = -1
      jpds(5) = ifd
      jpds(6) = 100
      jpds(7) = ilev
      jpds(9) = imon
      call getgb(11,21,mdata,j,jpds,jgds,
     .           kf,k,kpds,kgds,lb,data,iret)
      if(iret.eq.0) then
        call baclose(11,iret)
        call baclose(21,iret)
        call grange(kf,lb,data,dmin,dmax)
        write(*,886)
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmin,dmax
        do i = 1, 144
         do j = 1, 73
          ij=(j-1)*144 + i
          glb(i,j)=data(ij)
         enddo
        enddo
        write (51) ((glb(j,i),j=1,144),i=73,1,-1)
      else
        goto 991
      endif
      enddo
      stop
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Maximun    Minimum')
  888 format (i4,2x,8i5,i8,2g12.4)
  991 print *, ' there is a problem to open pgb file !!! '
      call baclose(11,iret)
      call baclose(21,iret)
      stop  
  992 print *, ' month =',imon,' is not acceptable, please check!!!'
      stop   
  993 print *, ' level =',ilev,' is not acceptable, please check!!!'
      stop  
  994 print *, 'The ihr =',ihr,' ifh =',ifh,' for your request'        
      print *, 'You must specify ihr+ifr either match 00 or 12 !!!! '
      stop  
      end
