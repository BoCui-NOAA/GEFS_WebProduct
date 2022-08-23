       program TPRH2Q_GFS 
       use funcphys
       use physcons
c      parameter(isday=11,ismth=9,isyr=2004)
c      parameter(ieday=11,iemth=9,ieyr=2004)
c
       parameter(idbug=1)
       parameter(idim=144,jdim=73,kdim=8)
c      parameter(idim=360,jdim=181,kdim=5)
c
       character*80 grbfile,indfile,qfile
       character*14 indate
       character*4 laby
       character*2 labm(12)
       character*2 labd(31)
       character*2 labc(0:23)
       character*2 labf1(0:99)
       character*3 labf2(100:399)
c
       dimension gridt(idim,jdim)
       dimension gridrh(idim,jdim)
       dimension gridq(idim,jdim)
       dimension deg(jdim)
c
       integer ilev(kdim)
       integer KPDS(25),KGDS(22)
       integer JPDS(25),JGDS(22)
       logical*1 lbms(idim,jdim)
c
c      data ilev/925,850,700,500,300/
       data ilev/1000,925,850,700,600,500,400,300/
c
       DATA LABC/'00','01','02','03','04','05',
     &           '06','07','08','09','10','11',
     &           '12','13','14','15','16','17',
     &           '18','19','20','21','22','23'/
C
       DATA LABD/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12','13','14','15','16','17','18','19','20',
     *           '21','22','23','24','25','26','27','28','29','30',
     *           '31'/
C
       DATA LABM/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12'/
       NAMELIST /namin/ishr,isday,ismth,isyr,iehr,ieday,iemth,ieyr,ifhr 

      call gfuncphys
      read  (5,namin,end=1000)
      write (6,namin)
 1000 continue
      LABF1(0)="00"
      LABF1(12)="12"
      LABF1(24)="24"
      LABF1(36)="36"
      LABF1(48)="48"
      LABF1(72)="72"
      LABF1(84)="84"
      LABF1(96)="96"
      LABF2(120)="120"
      LABF2(144)="144"
      LABF2(168)="168"
      LABF2(192)="192"
      LABF2(216)="216"
      LABF2(240)="240"
      LABF2(264)="264"
      LABF2(288)="288"
      LABF2(312)="312"
      LABF2(336)="336"
      LABF2(360)="360"
      LABF2(384)="384"

C
       do j=1,jdim
       deg(j)=90.-float(j-1)*2.5
c      deg(j)=90.-float(j-1)
       enddo
c
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)
       ndays = ncne - ncns + 1
       print *,' ncns ',ncns,' ncne ',ncne,' ndays ',ndays
c
C      START THE TIME LOOP HERE...
C
       ntmx=0
       DO NCN=NCNS,NCNE
C
       CALL W3FS26(NCN,IYR,IMTH,IDAY,IDAYWK,IDAYYR)
       WRITE(LABY,'(I4)') IYR
       if (ifhr.lt.100) then
       indate(1:2)=LABF1(IFHR)
       indate(3:3)="."
       indate(4:7)=LABY
       indate(8:9)=LABM(IMTH)
       indate(10:11)=LABD(IDAY)
       indate(12:13)=LABC(ISHR)
       grbfile='pgbf' // indate(1:13)
       qfile='qhf' // indate(1:13)
       else
       indate(1:3)=LABF2(IFHR)
       indate(4:4)="."         
       indate(5:8)=LABY
       indate(9:10)=LABM(IMTH)
       indate(11:12)=LABD(IDAY)
       indate(13:14)=LABC(ISHR)
       grbfile='pgbf' // indate(1:14)
       qfile='qhf' // indate(1:14)
       endif
C
c      grbfile = 'pgbf00.' // indate
       write(*,*) "grbfile= ",grbfile
c
c      indfile = 'pgbf00.' // indate // '.index'
c      if(idbug.eq.1) write(*,*) "indfile= ",indfile
c
       write(*,*) "qfile= ",qfile
c
       call baopenr(11,grbfile,ierr)
         if(ierr.ne.0) then
         print *,'error opening file ',grbfile
             stop
       endif
c
       call baopenwt(51,qfile,ierr)
         if(ierr.ne.0) then
         print *,'error opening file ',qfile
             stop
       endif
c
       do nl=1,kdim
c
       kpds7=ilev(nl)
       P=float(kpds7)
c
c..   get temp first
       N=-1
       do k=1,25
       JPDS(k)=-1
       enddo
       JPDS(5)=11
       JPDS(6)=100
       JPDS(7)=kpds7
       JPDS(8) = mod(IYR-1,100) + 1
       JPDS(9)  = IMTH
       JPDS(10) = IDAY
       JPDS(11) = ISHR
       JPDS(21) = ((IYR-1)/100) + 1
       do k=1,22
       JGDS(k)=-1
       enddo
       CALL GETGB(11,0,idim*jdim,N,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,gridt,IRET)
       if(iret.ne.0) then
       print *,' temp error in GETGB for rc = ',iret,jpds
       call abort
       endif
c
c..   get rh next
       N=-1
       do k=1,25
       JPDS(k)=-1
       enddo
       JPDS(5)=52
       JPDS(6)=100
       JPDS(7)=kpds7
       JPDS(8) = mod(IYR-1,100) + 1
       JPDS(9)  = IMTH
       JPDS(10) = IDAY
       JPDS(11) = ISHR
       JPDS(21) = ((IYR-1)/100) + 1
       do k=1,22
       JGDS(k)=-1
       enddo
       CALL GETGB(11,0,idim*jdim,N,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,gridrh,IRET)
       if(iret.ne.0) then
       print *,'rh error in GETGB for rc = ',iret,jpds
       call abort
       endif
c
c..   compute q now..in g/Kg
       do j=1,jdim
       do i=1,idim
       gridq(i,j)=0.
       T=gridt(i,j)
c      RH=gridrh(i,j)/100.
       RH=gridrh(i,j)
       if(RH .gt. 0.) then
c      Q=TPRH2Q(T,P,RH)
       p=p*100.     ! convert to Pa, 1 kPa = 1000 Pa = 10 hPa
       es=fpvs(t)
       es=min(es,p)
       shs=con_eps*es/(p+con_epsm1*es)
       q=rh*shs*0.01  ! q:  kg/kg
c      call rhtp2q(1,rh,t,p,q,-1)
       p=p/100.     ! convert back to mb
ccc    changed by 03/28/2005 (kg/kg)
c      gridq(i,j)=Q*1000.  ! gridq: g/kg
       gridq(i,j)=Q        ! gridq: kg/kg
c      print *, 'rh=',rh,' t=',t,' p=',p,' q=',q*1000.
       endif
       enddo
       enddo
c
       if(idbug.eq.1) then
       CALL GRIDAV(gridt,IDIM,JDIM,DEG,GLOBt)
       CALL GRIDAV(gridrh,IDIM,JDIM,DEG,GLOBrh)
       CALL GRIDAV(gridq,IDIM,JDIM,DEG,GLOBq)
       print *,imth,' level ',kpds7,' ',globt,globrh,globq
       endif
c
c...  now write out gribbed q...
       KPDS(5)=51
       KPDS(22)=6
       CALL PUTGB(51,NDATA,KPDS,KGDS,LBMS,gridq,IRET)
       if(iret.ne.0) then
       print *,' error in PUTGB for iret ',iret,kpds
       call abort
       endif
c
c  end level-loop
       enddo
c
       call baclose(11,ierr)
       if(ierr.ne.0) then
         print *,'error closing file ',grbfile
             stop
       endif
       call baclose(12,ierr)
       if(ierr.ne.0) then
         print *,'error closing file ',indfile
             stop
       endif
       call baclose(51,ierr)
       if(ierr.ne.0) then
         print *,'error closing file ',qfile
             stop
       endif
c
c  end day-loop
       enddo
c
       stop
       end
      SUBROUTINE gridav(z,lon,lat,deg,gridv)
      dimension z(lon,lat),deg(lat)
c
c       grid averaging algorithm: spherical integration
c       not fancy but has a pole correction
c
c       algorithm:
c
c       dtheta = (deg(i+1)-deg(i)/2 + (deg(i) - deg(i-1))/2
c               = (deg(i+1) - deg(i-1))/2
c       integral = sum for all point: point_value * dtheta * cos(theta)
c               / sum for all points: dtheta * cos(theta)
c       however there is a problem with the poles,
c       point_value*dos(theta) goes to zero
c
c       one solution:
c       let dtheta = (90 degrees - (deg(1)+deg(2))/2)
c       and assume that f*cos(theta) is linear
c
c       and then integrate the over the interval
c       this yields an effective dtheta of
c
c       dth = 0.5 * (90.- (deg(1)+deg(2))/2)**2 / (90.- deg(1))
c       note:
c       grids must from north and work down
      gridv=0.
      PI=4.*ATAN(1.)
      X=0.
      W=0.
      DO 11 J=1,LAT
      COSL=COS(DEG(J)*PI/180.)
c       wne: pole problem fix
        if (j.eq.1) then
           dth = 0.5*(90.- (deg(1)+deg(2))/2.)**2 * PI/180.
        else if (j.eq.lat) then
           dth = 0.5*((deg(lat)+deg(lat-1))/2.+90.)**2 * PI/180.
        else
           dth = 0.5 * (deg(j-1) - deg(j+1)) * COSL
        endif
      DO 10 I=1,LON
      X=X+Z(I,J)*DTH
      W=W+DTH
10    CONTINUE
11    CONTINUE
      GRIDV=X/W
      RETURN
      END
c      subroutine GRIDAV(xx,ii,jj,lat,avg)
c      dimension xx(ii,jj),lat(jj)
c      avg = 0
c      awgt = 0
c      d2r = 3.1415926/180.
c      do j = 1, jj
c       wgt=cos(lat(j)*d2r)
c       do i = 1, ii
c        avg = avg + xx(i,j)*wgt
c        awgt= awgt+ wgt
c       enddo
c      enddo
c      avg = avg/awgt
c      return
c      end
