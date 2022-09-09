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
      program CLIMATE_ac_sd
      parameter (ix=144,iy=73,ixy=10512,iys=40,idy=365,mlen=14600)
      parameter(imm = 12 )   !points chosen at the middle of each month
      parameter(ism = 30 )   !running mean of the sd
      dimension fanl(ixy,mlen),f1(ixy),f2(ixy),f3(ixy)
      dimension xanl(ix,iy),xanc(ixy,idy),xsd(ixy,idy),xanom(ixy)
      dimension yanc(idy),ysd(idy)
      dimension kpds(200),kgds(200)
      dimension jpds(200),jgds(200)
      dimension lmon(12)
      logical*1 lb(10512)
      character*80 cfilea(40)
      character*80 cfileom,cfileos,cfileok
c     namelist /namin/ ifd,itp,ilv,isthr,fc2,fc3,cfilea
      namelist /namin/ ifd,itp,ilv,ihr,ifhr,fc2,fc3,cfilea
      data cfileom/'pgrbmean'/
      data cfileos/'pgrbstdv'/
      data cfileok/'pgrbskew'/

      call baopen (81,cfileom(1:8),ires)
      call baopen (82,cfileos(1:8),ires)
      call baopen (83,cfileok(1:8),ires)

      read (5,namin,end=1000)
      write(6,namin)

c
c     t2m, tmax, tmin, u10m, v10m are valid at initial + 6hr
c
c     ifhr=24-isthr
c     if (ifhr.eq.24) then
c      ifhr=0
c     endif

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

c ----
c     convert initial time + forecast time to verified time
c ----
      jcnt=1
      icnt=0
      if (ifhr.eq.0) then
       isthr=0
      else
       if (ihr.eq.0) then
        isthr=18
       else
        isthr=-6 
       endif
      endif

      do iyr = 1959, 1998
       icnt = icnt + 1
       kcnt = 0
       do imo = 1, 12
        idate=iyr*1000000 + imo*10000 + 100 + ihr + isthr
        do nfhrs = 0, lmon(imo), 24
         kcnt=kcnt+1
         call iaddate(idate,nfhrs,jdate)
c        print *, 'JCNT=',jcnt,jdate,ifhr,ifd,itp,ilv,' F=',cfilea(icnt)(1:14)
         call getgrb(xanl,ix,iy,cfilea(icnt),ifd,itp,ilv,
     *               jdate,ifhr,10+icnt,kpds,kgds)
         if (jcnt.eq.1) then
          jpds=kpds
          jgds=kgds
         endif
         if (xanl(50,25).ne.-9999.99) then
          do i = 1, 144
           do j = 1, 73
            ij = (j-1)*144 + i
            fanl(ij,jcnt) = xanl(i,j)
           enddo
          enddo
          jcnt=jcnt+1
         else
          jcnt=jcnt
         endif
c        call fitr30(fanl(1,1,jcnt))
c        call fitr20(fanl(1,1,jcnt))
        enddo
       enddo

       print *, 'year=',iyr,' days=',kcnt,' right?'

      enddo

      print *, 'jcnt=', jcnt, ' mlen=',mlen,' same?'

      do i = 1, ixy       !loop for each gridpoint
       call avef(fanl,i,mlen,ixy,iys,idy,yanc)
       call stdm(fanl,i,mlen,ixy,iys,idy,yanc,ysd,imm,ism)
       dmin =  1.e40
       dmax = -1.e40
       smin =  1.e40
       smax = -1.e40
       do ij = 1, idy
        dmin=min(dmin,yanc(ij))
        dmax=max(dmax,yanc(ij))
        smin=min(smin,ysd(ij))
        smax=max(smax,ysd(ij))
        xanc(i,ij) = yanc(ij)
        xsd(i,ij)  = ysd(ij)
       enddo
       print*,'p=',i,' max=',dmax,'min=',dmin,' max=',smax,'min=',smin
      enddo
 
      icnt = 0
      iyr  = 1959
      do imo = 1, 12
       idate=iyr*1000000 + imo*10000 + 100 + ihr + isthr
       do nfhrs = 0, lmon(imo), 24
        call iaddate(idate,nfhrs,jdate)
        im = mod(jdate/10000,  100)
        id = mod(jdate/100,    100)
        ih = mod(jdate,        100)
        icnt = icnt + 1
        kpds=jpds
        kgds=jgds
        kpds(8)=59
        kpds(9)=imo
        kpds(10)=id
c       kpds(11)=0
c       kpds(12)=0
        kpds(13)=1
c       kpds(14)=1
c       kpds(15)=1
        kpds(16)=51 
        kpds(17)=40
        print *, 'icnt=',icnt
        do ij = 1, ixy
         f1(ij)=xanc(ij,icnt)
c        f2(ij)=xsd(ij,icnt)*fc2
         f2(ij)=xsd(ij,icnt)
        enddo
        call putgb(81,ixy,kpds,kgds,lb,f1,iret)
        kpds(16)=136
        call putgb(82,ixy,kpds,kgds,lb,f2,iret)
       enddo
      enddo
c
c     Computes anomalies w.r.t. annual cycle
c
c     k = 0
c     do it=1,id2
c       read(1,rec=it)(x0(i),i=1,igp)
c       k= k + 1
c       if(k.gt.idy)k=1
c       if(it.ne.lyd(1).and.it.ne.lyd(2).and.it.ne.lyd(3).
c    .                  and.it.ne.lyd(4).and.it.ne.lyd(5))then
c         do i=1,igp
c           xanom(i) = x0(i) - xanc(k,i)
c         enddo
c       else
c         do i=1,igp
c           xanom(i) = x0(i) - xanc(k-1,i)
c         enddo
c       endif
c       write(30,rec=it)(xanom(i),i=1,igp)
c     enddo

      stop
      end

      SUBROUTINE AVEF(x,j2,id,igp,iys,idy,yanc)
c     This subroutine will compute the annual cycle. For example
c     yanc(i,1) corresponds to January 1 of the annual cycle for gridpoint i.
c     yanc(i,30) corresponds to January 30 of the annual cycle for gridpoint i.
c
      dimension x(igp,id)
      dimension yanc(idy)    !annual cycle for gridpoint =j2
c
      xa0cum = 0.
      xa1cum = 0.
      xa2cum = 0.
      xa3cum = 0.
      xa4cum = 0.
      xb1cum = 0.
      xb2cum = 0.
      xb3cum = 0.
      xb4cum = 0.
      x2pi = 2*3.1415926536
      do 10 k=1,id
        xa0cum = xa0cum + x(j2,k)
        xa1cum = xa1cum + x(j2,k)*cos(1*x2pi*k/float(idy))
        xa2cum = xa2cum + x(j2,k)*cos(2*x2pi*k/float(idy))
        xa3cum = xa3cum + x(j2,k)*cos(3*x2pi*k/float(idy))
        xa4cum = xa4cum + x(j2,k)*cos(4*x2pi*k/float(idy))
        xb1cum = xb1cum + x(j2,k)*sin(1*x2pi*k/float(idy))
        xb2cum = xb2cum + x(j2,k)*sin(2*x2pi*k/float(idy))
        xb2cum = xb3cum + x(j2,k)*sin(3*x2pi*k/float(idy))
        xb2cum = xb4cum + x(j2,k)*sin(4*x2pi*k/float(idy))
10    continue
      xa0 = xa0cum/float(id)
      xa1 = 2*xa1cum/float(id)
      xa2 = 2*xa2cum/float(id)
      xa3 = 2*xa3cum/float(id)
      xa4 = 2*xa4cum/float(id)
      xb1 = 2*xb1cum/float(id)
      xb2 = 2*xb2cum/float(id)
      xb3 = 2*xb3cum/float(id)
      xb4 = 2*xb4cum/float(id)
c
      do 20 k=1,idy
       yanc(k) = xa0 
     . + xa1*cos(1*x2pi*k/float(idy)) + xb1*sin(1*x2pi*k/float(idy))
     . + xa2*cos(2*x2pi*k/float(idy)) + xb2*sin(2*x2pi*k/float(idy))
c    . + xa3*cos(3*x2pi*k/float(idy)) + xb3*sin(3*x2pi*k/float(idy))
c    . + xa4*cos(4*x2pi*k/float(idy)) + xb4*sin(4*x2pi*k/float(idy))
20    continue
      return
      end

      SUBROUTINE STDM(x,j2,id,igp,iys,idy,yanc,ystd,imm,ism)
c     This subroutine computes the standard deviation from annual cycle
c     Notice that this routine is repeated for each of the
c     gridpoint (igp=192) values given by x(j2).
c     yanc(k=1) is the average of iys years of 1 January.
c
      real x(igp,id)
      real yanc(idy)       !annual cycle for gridpoint =j2
      real xsd(idy)        !annual average of standard deviation
      real xstm(imm)       !Standard deviation for j2
      real ystd(idy)       !final standard deviation
      integer mm(12)       !Days in the middle of each month
c     data mm/16,45,75,105,136,166,197,228,258,289,319,350/
      data mm/16,45,75,105,135,165,195,225,255,285,315,345/
c
c Parameters imm =12, ism =30
c First get the standard deviation for the idy days in the year cycle:
c
      do 20 k=1,idy              !recall idy = 365
        xvar = 0.
        do 10 k2 = 1,iys !(19 years)
          it = k + idy*(k2-1)
          xvar = xvar + (x(j2,it)-yanc(k))**2
c       if (j2.eq.3138) then
c        print *, 'year=',k2,' t=',x(j2,it),' anc=',yanc(k)
c       endif
10      continue
        xsd(k) = sqrt(xvar/float(iys))
            ystd(k) =xsd(k)
c      if (j2.eq.3138) then
c       print *, 'std=', xsd(k)
c      endif
20     continue
c
c  Get the average of ism steps around the mm(i) time periods
c
      do 40  i =1, imm
        xsta = 0.
        do 30 j = mm(i)-ism,mm(i)+ism
         jn = j
         if(jn.le.0)jn = idy + j
         if(jn.gt.idy)jn = j - idy
         xsta =xsta + xsd(jn)
30     continue
         xstm(i) = xsta/float(1 + 2*ism)   !average
40     continue
c
c  Get a rect line linking these imm poins
c
      do 60 i = 1,imm
        if(i.ne.imm) then
          slope = (xstm(i+1)-xstm(i))/float(ism)
          do 50 k=1,ism
            ystd(mm(i)+k) = slope*k + xstm(i)
50        continue
        endif
        if(i.eq.imm) then      !Edge
          slope = (xstm(1)-xstm(i))/float(ism)
          do 55 k=1,20  !the remaining from 346 to 365
            ystd(mm(i)+k) = slope*k + xstm(i)
55        continue
          do 58 k=1,16  !the initial 15 points
            ystd(k) = slope*(k-mm(1)) + xstm(1)
58        continue
        endif
60    continue
c
      return
      end

