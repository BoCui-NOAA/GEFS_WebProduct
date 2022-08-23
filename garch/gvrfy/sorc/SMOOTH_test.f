c
c  Main program    DEC_WAVE
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2005-10-10
c
c This is main program to generate climate anomaly forecasts.             
c
c   subroutine                                                    
c              IADDATE---> to add forecast hours to initial data    
c              GETGB  ---> to get GRIB format data                  
c              GRANGE ---> to calculate max. and min value of array
c
c   parameters:
c      ix    -- x-dimensional
c      iy    -- y-dimensional
c      ixy   -- ix*iy
c      iv    -- 19 variables
c
c   Fortran 77 on IBMSP 
c
C--------+---------+---------+---------+---------+----------+---------+--
      program SMOOTH_test  
C     parameter (ix=360,iy=181,ixy=ix*iy,iv=19)            
      parameter (ix=144,iy=73,ixy=ix*iy,iv=19)            
      parameter (maxwv=62,mx=(maxwv+1)*(maxwv+2)/2,jcap=maxwv)
      complex   wave((jcap+1)*(jcap+2)/2),wavef((jcap+1)*(jcap+2)/2)
c     dimension wave(2,mx),wavef(2,mx)
      dimension fcst(ix,iy),data(ixy),data1(ixy)
      dimension ipds(200),igds(200)
      dimension jpds(200),jgds(200)
      dimension kpds(200),kgds(200)
      dimension ifld(iv),ityp(iv),ilev(iv)
      logical*1 lb(ixy)
      character*80 cfcst,cfwv1
      namelist /namin/ cfcst,cfwv1
      data ifld/   7,   7,   7,   7,  11,  11,  11,  33,  34,  33,  34,
     &            33,  34,   2,  11,  15,  16,  33,  34/
      data ityp/ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
     &           100, 100, 102, 105, 105, 105, 105, 105/
      data ilev/1000, 700, 500, 250, 850, 500, 250, 850, 850, 500, 500,
     &           250, 250,   0,   2,   2,   2,  10,  10/

      read (5,namin,end=100)
      write(6,namin)

 100  continue

      lfcst = len_trim(cfcst)
      lfwv1 = len_trim(cfwv1)
      print *, 'Forecast        file is ',cfcst(1:lfcst)
      print *, 'Forecast smooth file is ',cfwv1(1:lfwv1)

      call baopen (81,cfwv1(1:lfwv1),irfwv1)
      
      icnt = 0
      do ii = 1, iv
       print *, "ii=", ii
       call baopenr(11,cfcst(1:lfcst),irfcst)
       if (irfcst.ne.0) goto 882
       if (irfwv1.ne.0) goto 882
c
c     get forecast
c
       jj      = 0
       jpds    = -1
       jgds    = -1
       jpds(5) = ifld(ii)
       jpds(6) = ityp(ii)
       jpds(7) = ilev(ii)
c--------+----------+----------+----------+----------+----------+----------+--
       call getgb(11,0,ixy,jj,jpds,jgds,kf,k,kpds,kgds,lb,data1,iret)
       if(iret.eq.0) then
        ipds = kpds
        igds = kgds
        call grange(kf,lb,data1,dmin,dmax)
        if (icnt.eq.0) then
         write(*,886)
         icnt=1
        endif
        write(*,888) k,(kpds(i),i=5,11),kpds(14),kf,dmax,dmin
c       print *,'pds14=',kpds(14),' pds15=',kpds(15),'pds16=',kpds(16)
       else if (iret.eq.99) then
        goto 881
       else
        goto 991
       endif

       iromb=0
       call sptez(iromb,maxwv,0,ix,iy,wave,data1,-1)
       print *, "call sptez"

       iord=1
       smx=0.15
       smx=0.05
       smx=0.10
       call smooth(wave,wavef,iord,smx,jcap)

       print *, "call sptez"
       call sptez(iromb,maxwv,0,ix,iy,wavef,data,1)

       call putgb(81,ixy,kpds,kgds,lb,data,iret)

       call baclose(11,iret)
      enddo

      call baclose(81,iret)
  881 continue
  991 continue
  886 format('  Irec  pds5 pds6 pds7 pds8 pds9 pd10 pd11 pd14',
     .       '  ndata  Maximun  Minimum')
  888 format (i4,2x,8i5,i8,2f9.2)

      stop   

  882 print *, 'Missing input file, please check! stop!!!'

      stop
      end
c
c
c
      subroutine grange(n,ld,d,dmin,dmax)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                    C
C     USAGE: DETERMINE THE MAXIMUM AND MINIMUM VALUES OF ARRAY       C
C     CODE : F77 on IBMSP --- Yuejian Zhu (05/10/99)                 C
C                                                                    C
C     INPUT: one dimension array d and ld                            C
C                                                                    C
C     OUTPUT:maximum and minimum values                              C
C                                                                    C
C     Arguments:                                                     C
C               1. n ( int number of dimension of d and ld )         C
C               2. ld ( logical array of dimension n )               C
C               3. d  ( real array of dimension n )                  C
C                                                                    C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      logical*1   ld
      dimension ld(n),d(n)
      dmin=  1.e40
      dmax= -1.e40
      do i=1,n
        if(ld(i)) then
          dmin=min(dmin,d(i))
          dmax=max(dmax,d(i))
        endif
      enddo
      return
      end
C-----------------------------------------------------------------------
      SUBROUTINE IADDATE(IDATE,IHOUR,JDATE)
      DIMENSION   MON(12)
      DATA MON/31,28,31,30,31,30,31,31,30,31,30,31/
C-----------------------------------------------------------------------
      IC = MOD(IDATE/100000000,100 )
      IY = MOD(IDATE/1000000,100 )
      IM = MOD(IDATE/10000  ,100 )
      ID = MOD(IDATE/100    ,100 )
      IHR= MOD(IDATE        ,100 ) + IHOUR
C
      IF(MOD(IY,4).EQ.0) MON(2) = 29
1     IF(IHR.LT.0) THEN
       IHR = IHR+24
       ID = ID-1
       IF(ID.EQ.0) THEN
        IM = IM-1
        IF(IM.EQ.0) THEN
         IM = 12
         IY = IY-1
         IF(IY.LT.0) IY = 99
        ENDIF
        ID = MON(IM)
       ENDIF
       GOTO 1
      ELSEIF(IHR.GE.24) THEN
       IHR = IHR-24
       ID = ID+1
       IF(ID.GT.MON(IM)) THEN
        ID = 1
        IM = IM+1
        IF(IM.GT.12) THEN
         IM = 1
         IY = MOD(IY+1,100)
        ENDIF
       ENDIF
       GOTO 1
      ENDIF
      JDATE = IC*100000000 + IY*1000000 + IM*10000 + ID*100 + IHR
      RETURN
      END

      subroutine smooth(cofi,cofo,iord,sizeofsm,jcap)
c    this subroutine performs jim purser's smoother
c  cofi  input spher. coeff., triang. trunc jcap
c  cofo  output spher. coeff., triang. trunc jcap
c  iord  order of smoothing; 1=normal-shape, 7=approx. box shape
c  sizeofsm size of area used to smooth in earth radius in radians
c          (1.57=90deg);
c       eg, .1 for +-9deg dropoff (st dev) in smoothing
      dimension xcof(7,7),xkappa(jcap+1),acof(7)
      complex   cofi((jcap+1)*(jcap+2)/2),cofo((jcap+1)*(jcap+2)/2)
      data xcof /1.,0.,0.,0.,0.,0.,0.,
     *            2.,-1.,0.,0.,0.,0.,0.,
     *            6.,-6.,1.,0.,0.,0.,0.,
     *            24.,-36.,12.,-1.,0.,0.,0.,
     *            120.,-240.,120,-20.,1.,0.,0.,
     *            720.,-1800.,1200.,-3000.,30.,-1.,0.,
     *            5040.,-15120.,12600.,-4200.,630.,-42.,1./
           data acof /1.,2.,6.,24.,120.,720.,5040./
           allocatable funct(:)
           allocate(funct(jcap+1))
           xsize=sizeofsm
c          print'('' xsize='',e12.6,i5)',xsize,iord
           do 300 i=1,jcap+1
           funct(i)=0.0
 300   continue
           do 100 ii=1,jcap+1
           i=ii-1
           xkappa(ii)=(xsize*xsize)*float(i)*float(i+1)
c      write(6,78) ii,xkappa(ii)
           do 110 j=1,iord
           if(j.eq.1) then
            funct(ii)=funct(ii)+xcof(j,iord)/acof(iord)
           else
            funct(ii)=funct(ii)+(xcof(j,iord)/
     *                 acof(iord))*(xkappa(ii)**(j-1))
           endif
 110   continue
           if(xkappa(ii).gt.100.) xkappa(ii)=20.
           funct(ii)=funct(ii)*exp(-xkappa(ii))
c          funct(ii)=funct(ii)*((2.72)**(-xkappa(ii)))
c      write(6,77) ii,funct(ii)
 77    format(1x,'ii,funct(ii)',i5,f12.2)
 78    format(1x,'ii,xkappa(ii)',i5,f12.2)
 100   continue
c          go to 555
c
          indo=0
          do 15 m=0,jcap
          do 14 n=m,jcap
          indo=indo+1
c         write(6,67) m,n,indo
 67   format(1x,'m,n,indo=',3i10)
c         cofo(indo)=funct(m+1)*cofi(indo)
          cofo(indo)=funct(n+1)*cofi(indo)
 14   continue
 15   continue
c         write(6,66)
 555  continue
 66   format(1x,'smoothing finished')
      deallocate(funct)
      return
      END

