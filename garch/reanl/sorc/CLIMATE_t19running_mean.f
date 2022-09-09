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
c     fanl = -9999.99

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
         if (xanl(50,25).ge.-9990.00) then
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
        kpds(22)= 2
        call putgb(81,ixy,kpds,kgds,lb,f1,iret)
        kpds(16)=136
        kpds(22)= 2
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
      yanc = 0.0
c     if (x(j2,id).eq.-9999.99) then
c        print *, 'last point (id=',id,') =', x(j2,id)
c        print *, 'next point (id=',id-1,') =', x(j2,id-1)
c        x(j2,id) = x(j2,id-1)
c     endif
      do k = 1, idy
       do kk = 1, 40
         kkk = k + 365*(kk-1)
         km1 = kkk - 1
         km2 = kkk - 2
         km3 = kkk - 3
         km4 = kkk - 4
         km5 = kkk - 5
         km6 = kkk - 6
         km7 = kkk - 7
         km8 = kkk - 8
         km9 = kkk - 9
         kp1 = kkk + 1
         kp2 = kkk + 2
         kp3 = kkk + 3
         kp4 = kkk + 4
         kp5 = kkk + 5
         kp6 = kkk + 6
         kp7 = kkk + 7
         kp8 = kkk + 8
         kp9 = kkk + 9
         if (km1.le.0) then
          km1 = id + km1
         endif
         if (km2.le.0) then
          km2 = id + km2
         endif
         if (km3.le.0) then
          km3 = id + km3
         endif
         if (km4.le.0) then
          km4 = id + km4
         endif
         if (km5.le.0) then
          km5 = id + km5
         endif
         if (km6.le.0) then
          km6 = id + km6
         endif
         if (km7.le.0) then
          km7 = id + km7
         endif
         if (km8.le.0) then
          km8 = id + km8
         endif
         if (km9.le.0) then
          km9 = id + km9
         endif
         if (kp1.ge.id) then
          kp1 = kp1 - id
         endif
         if (kp2.ge.id) then
          kp2 = kp2 - id
         endif
         if (kp3.ge.id) then
          kp3 = kp3 - id
         endif
         if (kp4.ge.id) then
          kp4 = kp4 - id
         endif
         if (kp5.ge.id) then
          kp5 = kp5 - id
         endif
         if (kp6.ge.id) then
          kp6 = kp6 - id
         endif
         if (kp7.ge.id) then
          kp7 = kp7 - id
         endif
         if (kp8.ge.id) then
          kp8 = kp8 - id
         endif
         if (kp9.ge.id) then
          kp9 = kp9 - id
         endif
       
c        yanc(k) = yanc(k) + x(j2,kkk)/40.0
         yanc(k)=yanc(k)+(x(j2,km9)*0.01 + x(j2,km8)*0.02    
     *                  + x(j2,km7)*0.03 + x(j2,km6)*0.04    
     *                  + x(j2,km5)*0.05 + x(j2,km4)*0.06    
     *                  + x(j2,km3)*0.07 + x(j2,km2)*0.08    
     *                  + x(j2,km1)*0.09     
     *                  + x(j2,kkk)*0.1                        
     *                  + x(j2,kp1)*0.09        
     *                  + x(j2,kp2)*0.08 + x(j2,kp3)*0.07       
     *                  + x(j2,kp4)*0.06 + x(j2,kp5)*0.05       
     *                  + x(j2,kp6)*0.04 + x(j2,kp7)*0.03       
     *                  + x(j2,kp8)*0.02 + x(j2,kp9)*0.01)/40.0
       enddo
      enddo
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
10      continue
        xsd(k) = sqrt(xvar/float(iys))
            ystd(k) =xsd(k)
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

