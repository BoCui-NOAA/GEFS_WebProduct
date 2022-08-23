c
c     This is main program of numerical model forecast verification on Cray
c
c     main program    VRFYLN
c
c      subroutine     anomal ---> main routine to calculate anomal corr.
c                     rmsg   ---> to get mean error and RMS error
c                     latmn  ---> to get latitude mean values
c                     sum    ---> to sum the wave groups
c                     acgrid ---> to calaulate AC using grid values
c                     fanl   ---> transfor from grid to wave
c                     zsave  ---> rearranged the array
c                     getcac ---> read cac climate database
c                     getanl ---> read analysis file ( format dependent)
c
c     parameters      imax   ---> number of level to verification
c                     idmax  ---> maximum days to verification
c
c      Fortran 77 on Cray ====== coded by Yuejian Zhu 12/1/92
c
      program VRFYLN
      parameter (imax=4,idmax=25)
      dimension fhours(idmax),idates(4,idmax)
      dimension ac(5,4,idmax)
      dimension rmsf(5,idmax),rmsc(5,idmax),ermf(5,idmax),ermc(5,idmax)
      dimension cor(4,5,idmax),iprs(12),lvl(imax)
      character*5  chem(2)
      character*80 cfilea(2,100),cfilef(2,100),cfile1(2),cfile2(2)
      character*28 asunitg,asuniti
      namelist/files/ cfilea,cfilef
      namelist/namin/ ihem,la1,la2,lo1,lo2,l1,l2,nhours,ihours,ilv,
     &                iclim,icon
c***  data ihem,la1,la2,lo1,lo2,l1,l2/1,45,68,1,144,9,32/
c***  data ihem,la1,la2,lo1,lo2,l1,l2/2, 6,29,1,144,9,32/
c - note: above levels are standard; code will translate to cac
c - avlbl levels:1000,850,700,500,300,250,200,100,50(1-4,6-8,10,12)
c***  /labels for each forecast level    /
      data iprs /1000,850,700,500,400,300,250,200,150,100,75,50/
      data lvl  /1,4,7,10/,icoeff/1/
      data lupgb/11/, lupgi/21/
      data chem /'N Hem','S Hem'/
c
c     job will be controled by read card
c
      read  (5,files,end=1020)
      write (6,files)
 1010 read  (5,namin,end=1020)
      write (6,namin)
c
c -----  call stats routines for all levels and days.....-
c
      ndays = nhours/ihours + 1
      if(ndays .gt. idmax) ndays = idmax
      idays = ndays
      iut  = 1
c
      i    = ilv
      do 201 iday = 1, ndays
       cfile1(1) = cfilea(1,iut)
       cfile1(2) = cfilea(2,iut)
       cfile2(1) = cfilef(1,iut)
       cfile2(2) = cfilef(2,iut)
       ifh          = ihours*(iday - 1)
       fhours(iday) = float(ifh)
       call anomal(iday,lvl(i),cor(1,i,iday),rmsf(i,iday),rmsc(i,iday),
     1    ermf(i,iday),ermc(i,iday),la1,la2,lo1,lo2,l1,l2,ihem,icoeff,
     2    fhours(iday),idates(1,iday),cfile1,cfile2,ifh,iclim,icon)
       iut=iut+1
  201 continue
c--------------------------------------------------------------------
      ilv=lvl(i)
      write (81,410) chem(ihem)
  410 format (//, a5,' Anomaly Correlation by Waves -      1-3',
     &'     4-9    10-20    1-20 ',/)
c
      do 430 iday=1,ndays
      write(81,411) fhours(iday),(idates(l,iday),l=1,4),iprs(ilv),
     &(cor(l,i,iday),l=1,4)
  411 format (1x,f5.0,'hrs after =',i2,'Z ',3i3,i5,'mb',3x,4(f7.4,1x))
  430 continue
c
      write (81,412) chem(ihem)
  412 format (//, a5,' Differences                  -      (Fcst-Anl)',
     &'        (Fcst-Clim)    ',/
     &            5x,'                              -       RMS',
     &'     Mean    RMS     Mean '/)
c
      do 530 iday=1,ndays
      write(81,413) fhours(iday),(idates(l,iday),l=1,4),iprs(ilv),
     &rmsf(i,iday),ermf(i,iday), rmsc(i,iday),ermc(i,iday)
  413 format (1x,f5.0,'hrs after =',i2,'Z ',3i3,i5,'mb',3x,4(f7.2,1x))
  530 continue
c---- finished output
c     back to 1010 to read input data card
      goto 1010
c
c     after end of input card, end of program
c
 1020 continue
c -----------------------------
      stop
      end
c**********************************************************************
      subroutine anomal(iday,ilv,cor,rmsf,rmsc,ermf,ermc,la1,la2,
     & lo1,lo2,l1,l2,ihem,icoeff,fhour,idate,cfile1,cfile2,ifh,
     & iclim,icon)
c
      dimension g1(65,65),g2(4225),f(1977),g(1977),ne(4)
      dimension index(256),idtbl(1539),lve(12)
      dimension zunp(145,73)
      dimension label(8), idate(4), jdate(4)
      dimension ao(20,37),bo(21,37),af(20,37),bf(21,37),ac(20,37),
     1  bc(21,37),fnum(20,37),q1(4,37),denom1(20,37),denom2(20,37),
     2  q2(4,37),q3(4,37),qx1(4),qx2(4),qx3(4),cor(4),
     3  w1(37),w2(37),w3(37),qx4(5)
      dimension fsh(145,37),fnh(145,37),fsh1(145,37),fnh1(145,37),
     x                glob(144,73)
      dimension weight(73),fcst(145,73),anl(145,73),clim(145,73)
      dimension            fcstc(145,37),anlc(145,37),climc(145,37)
      character*80 cfile1(2),cfile2(2)
c
c     data l1,l2/9,32/
      data irep/0/
c
c     data ionce /0/
c
      ionce = 0
      if  (ionce .ne. 0)  go to 5
           ionce = 1
      do 72 jj= 37,73
        j  =jj-36
        xlat=(2.5*j - 2.5 )/57.296
        weight(j)  = sin(xlat)
        weight(jj) = sin(1.571-xlat)
 72   continue
    5 continue
c
c  get the forecast fields
c
      do 304 j = 1,4
  304   cor(j) = 0.0
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   We will setup a standard: ( 06/12/96 )
CCC      All the global fields ---> start from north pole
CCC      if hemispheric fields ---> start from equator
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
c  get the verifying forecasting field
c
      print *, ' Read forecasting field '
      call getanl (zunp,ndate,ilv,iday,idate,cfile2,ifh,icon)
      write (85) 0.0,idate
      write (85) zunp
      if(zunp(1,1).eq.999999.0.or.ndate.eq.0) go to 998
      write(84,2005)
 2005 format(' zunp(forecst) to follow...')
c     write(6,2001)((zunp(i,j),i=109,114),j=50,56)
      call zsave  (zunp,fcst,fcstc,ihem)
      if (ihem.eq.1) write(84,2001)((zunp(i,j),i=21,26),j=57,66)
      if (ihem.eq.2) write(84,2001)((zunp(i,j),i=21,26),j=16,7,-1)
      write(84,2006)
 2006 format(' fcstc to follow; compare to zunp...')
c     write(6,2001)((fcstc(i,j),i=112,117),j=14,20)
      write(84,2001)((fcstc(i,j),i=21,26),j=21,30)
c
c  get the verifying analysis field
c
      print *, ' Read analysis    field '
      call getanl (zunp,ndate,ilv,1,jdate,cfile1,ifh,icon)
      write (85) zunp
      if(zunp(1,1).eq.999999.0.or.ndate.eq.0) go to 998
      write(84,2007)
 2007 format(' zunp(analysis) to follow...')
      call zsave  (zunp,anl,anlc,ihem)
      if (ihem.eq.1) write(84,2001)((zunp(i,j),i=21,26),j=57,66)
      if (ihem.eq.2) write(84,2001)((zunp(i,j),i=21,26),j=16,7,-1)
      write(84,2008)
 2008 format(' analy to follow; compare to zunp...')
      write(84,2001)((anlc(i,j),i=21,26),j=21,30)
      irep=irep+1
      jyar = ndate/10000
      jjy  = jyar*10000
      jmth = (ndate-jjy)/100
      jjm  = jmth*100
      jday = ndate - jjy - jjm
c-----------    climo from cac data base ---------------
c     we need two important parameters
c      1). jmth --- which month
c      2). jday --- which day
c-------------------------------------------------------
      im1=jmth
      if (jday.le.15) im2=jmth - 1
      if (im2.lt.1)   im2=im2  + 12
      if (jday.gt.15) im2=jmth + 1
      if (im2.gt.12)  im2=im2  - 12
      temp=(float(jday)-15.)/30.
      percnt = 1.00-abs(temp)
c...
      if (iclim.eq.0) then
      if (ihem.eq.1)  iucac=53
      if (ihem.eq.2)  iucac=54
c - calc daily norm from norms of pres mon & preceding or nextmon
c       inum=ijk;  i=variable (1=u,2=v,3=t,4=h), j=1 , k=cac level
c       inum=ijk;  i=variable (1=u,2=v,3=t,4=h), j=1 , k=cac level
      call getcac(fnh,fsh,4,im1,ilv,iucac)
      write(84,2001)((fnh(i,j),i=21,26),j=21,30)
      call getcac(fnh1,fsh1,4,im2,ilv,iucac)
      write(84,2001)((fnh1(i,j),i=21,26),j=21,30)
      do i = 1,145
       do j = 1,37
        jn=38-j
        js=74-j
        zunp (i,js)= fsh(i,j)*percnt+(1.0-percnt)*fsh1(i,j)
        zunp (i,jn)= fnh(i,j)*percnt+(1.0-percnt)*fnh1(i,j)
       enddo
      enddo
      else
c...  Using CDAS/Reanl 17 years climatology ( grib file )
      call get17y(fnh,fsh,7,im1,ilv,ifh)
      write(84,2001)((fnh(i,j),i=21,26),j=21,30)
      call get17y(fnh1,fsh1,7,im2,ilv,ifh)
      write(84,2001)((fnh1(i,j),i=21,26),j=21,30)
      temp=(float(jday)-15.)/30.
      percnt = 1.00-abs(temp)
      do i = 1,145
       do j = 1,37
        jn=38-j
        js=36+j
        zunp (i,js)= fsh(i,j)*percnt+(1.0-percnt)*fsh1(i,j)
        zunp (i,jn)= fnh(i,j)*percnt+(1.0-percnt)*fnh1(i,j)
       enddo
      enddo
      endif
      write(84,2002)
 2002 format(' zunp(climate) to follow...')
c     write(6,2001)((zunp(i,j),i=109,114),j=50,56)
      if (ihem.eq.1) write(84,2001)((zunp(i,j),i=21,26),j=57,66)
      if (ihem.eq.2) write(84,2001)((zunp(i,j),i=21,26),j=16,7,-1)
 2001 format(6e12.4)
c--------end cac climate--------------------------
      call zsave(zunp,clim,climc,ihem)
      write(84,2009)
 2009 format(' cac-s to follow; compare to zunp...')
c     write(6,2001)((climc(i,j),i=112,117),j=14,20)
      write(84,2001)((climc(i,j),i=21,26),j=21,30)
c     do 22 lat=1,37
c       call fanl(ac(1,lat),bc(1,lat),climc(1,lat))
c  22 continue
c--------choose stats based on coefficients if icoeff=1.....
c      if coeffs are chosen, stats will be done with rearranged
c      fields, i.e., fcstc,anlc,climc--------------------
      if(icoeff.ne.1) go to 380
      do 20 lat=1,37
        call fanl(af(1,lat),bf(1,lat),fcstc(1,lat))
        call fanl(ao(1,lat),bo(1,lat),anlc(1,lat))
        call fanl(ac(1,lat),bc(1,lat),climc(1,lat))
   20 continue
      do 235 i=1,20
      do 235 l=1,37
        fnum(i,l)=(af(i,l)-ac(i,l))*(ao(i,l)-ac(i,l))+
     1         (bf(i,l)-bc(i,l))*(bo(i,l)-bc(i,l))
        denom1(i,l)=(af(i,l)-ac(i,l))**2+(bf(i,l)-bc(i,l))**2
        denom2(i,l)=(ao(i,l)-ac(i,l))**2+(bo(i,l)-bc(i,l))**2
  235 continue
      do 204 l=1,37
        call sum(fnum(1,l),q1(1,l))
        call sum(denom1(1,l),q2(1,l))
        call sum(denom2(1,l),q3(1,l))
  204 continue
c.....avg over lat band l1-l2, pole(n or s) at 37, eq at 1
      do 290 j=1,4
        do 291 l=1,37
          w1(l)=q1(j,l)
          w2(l)=q2(j,l)
          w3(l)=q3(j,l)
  291   continue
        call latmn(w1,l1,l2,qx1(j))
        call latmn(w2,l1,l2,qx2(j))
        call latmn(w3,l1,l2,qx3(j))
  290 continue
c.....combine terms to get anom corr for this day
      do 295 j=1,4
        qx4(j)=qx1(j)/(sqrt(qx2(j))*sqrt(qx3(j)))
  295 continue
      go to 370
c--------do stats on grid if icoeff = 0...
  380 call acgrid(anl,fcst,clim,weight,la1,la2,lo1,lo2,qx4)
  370 continue
      do  75 j=1,4
        cor(j) = qx4(j)
   75 continue
  350 continue
      call rmsg(rmsf,ermf,anl,fcst,weight,la1,la2,lo1,lo2)
      call rmsg(rmsc,ermc,clim,fcst,weight,la1,la2,lo1,lo2)
      go to 997
c
c missing analysis or forecast file
c
  998 continue
      do 975 j=1,4
        cor(j) = 9.999
  975 continue
      rmsf=99.99
      rmsc=99.99
      ermf=99.99
      ermc=99.99
  997 continue
c
  360 print 119, ilv, cor, cor
c
      return
  106 format('0,polate error,ier=',i4)
  109 format(1h0,'trouble in w3fm04, ier=',i4)
  110 format(1h0,'number of scans in w3fm05 more than 100'/t10,
     1 'ier=',i4)
  119 format (/ ' anomal ilv=', i2, '  cor=', 4f8.3, 4(1x, e14.7))
      end
c---------------------------------------------------------------
      subroutine rmsg(rmsx,ermx,y,x,weight,lamin,lamax,lomin,lomax)
c ---------------------------------------------------------------
c      calculate area-weighted rms and mean error between fields y and x
c       return single values of rms,erm
c             rms=rms error     erm=mean error
c ---------------------------------------------------------------
      dimension y(145,37),x(145,37),weight(37)
      flodif=lomax-lomin+1
      sumsq= 0.
      sumerr=0.
      sumwgt=0.
      do 37 lat=lamin,lamax
        tlatm =0.
        tlatms=0.
        do 73 lon=lomin,lomax
          error  = x(lon,lat) - y(lon,lat)
          tlatm  = tlatm  + error
          tlatms = tlatms + error*error
   73   continue
        sumsq = sumsq + tlatms*weight(lat)
        sumerr= sumerr+ tlatm *weight(lat)
        sumwgt= sumwgt + weight(lat)
   37 continue
      rmsx=sqrt((sumsq/sumwgt)/flodif)
      ermx=    (sumerr/sumwgt)/flodif
      return
      end
      subroutine zsave(z,field,fieldc,ihem)
c...  input z fields are global field                        
c...  arrage fron north pole ( like GRIB )
c...     some old notes still affect now.
c        field are still from south pole to north pole
c        arrays are offset to begin europe at i=1
c        and rearranged for coefficient calc, if necessary
      dimension  z(145,73),field(145,73),fieldc(145,37)
      do 10 j=1,73
        jj=74-j 
      do 10 i=1,145
        if(i.gt.141) field(i-141,j) = z(i,jj)
        if(i.le.141) field(i+3,j)   = z(i,jj)
  10  continue
      do j = 1, 73
        field(145,j) = field(1,j)
      enddo
c...  output hemispheric field
c...  from equator to pole, both hemisphere
      do 20 j=1,37
         js =38-j
         jn =36+j
         do 20 i=1,145
           if(ihem.eq.1)fieldc(i,j)=field(i,jn)
           if(ihem.eq.2)fieldc(i,j)=field(i,js)
   20 continue
      return
      end
      subroutine sum(w,y)
c
c..... sum sums over 4 wave no. groups
c.....   1=  k=1-3    2=  k=4-9  3=  k=10-20  4=  1-20
c
      dimension w(20),y(4)
      do 100 k=1,4
      y(k)=0.0
  100 continue
      do 200 k=1,3
      y(1)=y(1)+w(k)
  200 continue
      do 300 k=4,9
      y(2)=y(2)+w(k)
  300 continue
      do 400 k=10,20
      y(3)=y(3)+w(k)
  400 continue
      do 500 k=1,20
      y(4)=y(4)+w(k)
  500 continue
      return
      end
      subroutine latmn(w1,l1,l2,xmean)
c
c     latmn obtains mean of w1 over latitudinal belt l1-l2
c
      common/data3/ihem
      dimension w1(37)
      data pi/3.14159/
      rad = 180.0/pi
      xmean=0.0
      dl=0.0
      dlat=pi*2.5/180.
      do 100 l=l1,l2
      alat=(float(l)-.5)*2.5*pi/180.
      if(ihem.eq.2) alat=alat-(90.0/rad)
      xmean=xmean+cos(alat)*dlat*.5*(w1(l)+w1(l+1))
      dl=dl+cos(alat)*dlat
  100 continue
      xmean=xmean/dl
      return
      end
c ------- fanl for dey stat codes----------
      subroutine fanl(a,b,f)
      dimension f(145),a(20),b(21),w(200)
      complex w,c
      nn=145
      n2=20
      an = nn/2
      nn2 = nn-1
      pi = 3.14159265897932
      cnst = 1./an
      ang = cnst * pi
      ca = cos(ang)
      sa = sin(ang)
      c = cmplx(ca,sa)
      w(1) = (1.0,0.0)
      do 13 j = 2,nn
      w(j) = c*w(j-1)
   13 continue
      do 3 k = 1,n2
      a(k) = 0.0
      b(k) = 0.0
      do 4 j = 1,nn2
      i = mod(k*(j-1),nn2) + 1
      ca = real(w(i))
      sa = aimag(w(i))
      a(k) = f(j)*sa + a(k)
      b(k) = f(j)*ca + b(k)
    4 continue
      a(k) = a(k)/an
      b(k) = b(k)/an
    3 continue
  100 format(1h0/(7e15.4))
      xbar=0.0
      do 30 i=1,nn2
      xbar=xbar+f(i)/nn2
   30 continue
      b(n2+1)=xbar
      return
      end
      subroutine acgrid(y,x,c,weight,lamin,lamax,lomin,lomax,qx4)
c ---------------------------------------------------------------
c      calculate anomaly correlation on the 2.5-degree grid over a
c       limited area - y=anl,x=fcst,c=climatology
c       using ed epstein's formulas
c      special global version for basu (73 lats) - member acbasu
c ---------------------------------------------------------------
      dimension y(145,73),x(145,73),c(145,73),weight(73),qx4(5)
      sumwt = 0.
      sumcov= 0.
      sumvrx= 0.
      sumvry= 0.
      sumxb = 0.
      sumyb = 0.
      smxbyb= 0.
      sumxbs= 0.
      sumybs= 0.
      cntla=0.
      sumx=0.
      sumy=0.
      do 37 la=lamin, lamax
        cntla=0.
        sumx =0.
        sumy =0.
        sumxy=0.
        sumxx=0.
        sumyy=0.
        do 73 lo=lomin,lomax
          xa=x(lo,la)-c(lo,la)
          ya=y(lo,la)-c(lo,la)
          cntla=cntla + 1.
          sumx = sumx + xa
          sumy = sumy + ya
          sumxy= sumxy+ xa*ya
          sumxx= sumxx+ xa*xa
          sumyy= sumyy+ ya*ya
   73   continue
c
        xbar = sumx /cntla
        ybar = sumy /cntla
        xybar= sumxy/cntla
        xxbar= sumxx/cntla
        yybar= sumyy/cntla
c - - - - get averages over the current latitude belt
        covla = xybar - xbar*ybar
        varxla= xxbar - xbar*xbar
        varyla= yybar - ybar*ybar
c - - - - increment weighted sums over all latitudes
        w=weight(la)
        sumwt=sumwt + w
        sumcov = sumcov + w*covla
        sumvrx = sumvrx + w*varxla
        sumvry = sumvry + w*varyla
        sumxb  = sumxb  + w*xbar
        sumyb  = sumyb  + w*ybar
        smxbyb = smxbyb + w*xbar*ybar
        sumxbs = sumxbs + w*xbar*xbar
        sumybs = sumybs + w*ybar*ybar
   37 continue
      cov = (sumcov + smxbyb- sumxb*sumyb/sumwt)/sumwt
      varx =(sumvrx + sumxbs- sumxb*sumxb/sumwt)/sumwt
      vary =(sumvry + sumybs- sumyb*sumyb/sumwt)/sumwt
      if( (varx.gt.0.).or.(vary.gt.0.))go to 12
        write(6,101)
        correl=99.
        go to 13
   12 correl = cov/sqrt(varx*vary)
   13 do 10 j = 1,4
   10 qx4(j)=correl
  101 format ( '%%%% trouble in ancoree %%%%')
      return
      end
