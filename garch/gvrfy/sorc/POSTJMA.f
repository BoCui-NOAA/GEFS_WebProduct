      program postjma                                        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: READ ANALYSIS OR FORECAST PRESSURE FILE ON GRIB FORMAT  C
C            WITH GRID POINT VALUE                                   C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: unblocked GRIB FORMAT PRESSURE FILE                     C
C                                                                    C
C     OUTPUT:2.5*2.5 degree grid resolution cover global ( 144*73 )  C
C                                                                    C
C     Arguments:                                                     C
C               1. glb(144,73)                                       C
C               2. cpgb ( pgb file input )                           C
C               3. cpgi ( pgb index file input )                     C
C               4. ifd ( field ID input )                            C
C               5. ilev ( level input )                              C
C               6. idate ( YYYYMMDDHH input with Y2K option )        C
C               7. ifh  ( forecast hours at idate )                  C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
c--------+----------+----------+----------+----------+----------+----------+--
      parameter(mdata=20000)
      dimension kpds(25),kgds(25),jpds(25),jgds(25)
      dimension glb(10512),data(mdata)               
      character*60 cpgbn,cpgbs,cpgbo    
      logical*1 lb(mdata)
      namelist /namin/ cpgbn,cpgbs,cpgbo
c
      read (5,namin)
      write(6,namin)
      lpgbn=len_trim(cpgbn)
      print *, cpgbn(1:lpgbn)   
      call baopenr(11,cpgbn(1:lpgbn),iretn)
      lpgbs=len_trim(cpgbs)
      print *, cpgbs(1:lpgbs)   
      call baopenr(12,cpgbs(1:lpgbs),irets)
      lpgbo=len_trim(cpgbo)
      print *, cpgbo(1:lpgbo)   
      call baopen(51,cpgbo(1:lpgbo),ireto)
      j       = -1
  100 continue
      jpds    = -1
      jgds    = -1
      j       = k
c--------+---------+---------+---------+---------+---------+---------+--
      call getgb(11,0,mdata,j,jpds,jgds,
     .           kf,k,kpds,kgds,lb,data,iret)
      if(iret.eq.0) then
        call grange(kf,lb,data,dmin,dmax)
        do i = 1, 5328
         glb(i) = data(i)
        enddo
        if (k.eq.1.and.icnt.eq.1) then
        write(*,886)
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmin,dmax
        j=-1
        jpds=-1
        jgds=-1
        jpds(5) = kpds(5)
        jpds(6) = kpds(6)
        jpds(7) = kpds(7)
        call getgb(12,0,mdata,j,jpds,jgds,
     .           kf,m,kpds,kgds,lb,data,iret)
        if(iret.eq.0) then
        do i = 5329, 10512
         glb(i) = data(i-5328+144)
        enddo
        call grange(kf,lb,data,dmin,dmax)
        write(*,888) m,(kpds(i),i=5,11),kpds(14),kf,dmin,dmax
        kgds(3)=73    
        kgds(4)=90000
        kgds(7)=-90000
        call putgb(51,10512,kpds,kgds,lb,glb,iret)
        endif
        goto 100
      endif
      call baclose(11,iret)
      call baclose(12,iret)
      call baclose(51,iret)
      stop  
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Minimun    Maximum')
  888 format (i4,2x,8i5,i8,2g12.4)
  889 format (i4,25i7)
  991 print *, ' there is a problem to open pgb file !!! iret=',iret
      stop  
      end
