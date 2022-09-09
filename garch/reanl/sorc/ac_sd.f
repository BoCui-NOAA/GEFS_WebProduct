c ac_sd.f   FOR DAILY DATA
c   created by M .Pena Jan 2002
c
c   Fits the first two Fourier annual modes to daily data
c   to obtain annual cycle.  Then computes a smooth sd from the annual cycle
c   and writes out anomalies w.r.t. annual cycle.
c   Note that both annual cycle and SD w.r.t. annual cycle is computed
c   assuming years of 365 days. Anomalies are reconstructed for
c   the leap days by persisting the annual cycle from previous day.
c
c     Parameter definition (for 19 years)
      parameter(iys = 19 )   !19 years of data
      parameter(id2= 6940)   !julian-type day
      parameter(ld  = 5  )   !# of 29ths of February in dataset= id/(365*4)
      parameter(id  =6935)   != id2-ld, years of 365 days
      parameter(igp =9936)   !number of grid points 144*69
      parameter(idy = 365)
      parameter(imm = 12 )   !points chosen at the middle of each month
      parameter(ism = 30 )   !running mean of the sd
c
c     Variable declaration
      real x0(igp)
      real x(id,igp)
      real xanc(idy,igp)         !annual cycle
      real xsd(idy,igp)          !Standard Deviation
      real xanom(igp)            !Anomaly wrt annual cycle
      dimension lyd(ld)
      data lyd/60,1521,2982,4443,5904/ !days corresponding to Feb. 29th
c
c     INPUT UNITS
      open(1,file='sktday.g.grd',status=
     & 'old',access='direct',form='unformatted',recl=igp)
c
c     OUTPUT UNITS
      open(10,file='ac.sktday.grd',
     & status='unknown',access='direct',form='unformatted',recl=igp)
      open(20,file='sd.sktday.grd',
     & status='unknown',access='direct',form='unformatted',recl=igp)
      open(30,file='skt.anom.grd',
     & status='unknown',access='direct',form='unformatted',recl=igp)
c
      n = 0             !new time counter that excludes leap days
      do it=1,id2       !total number of days (incl. leap days)
        read(1,rec=it)(x0(i),i=1,igp)
        if(it.ne.lyd(1).and.it.ne.lyd(2).and.it.ne.lyd(3).
     .                  and.it.ne.lyd(4).and.it.ne.lyd(5))then
           n = n + 1
           do i=1,igp
              x(n,i)=x0(i)
           enddo
        endif
      enddo
c
      do i=1,igp       !loop for each gridpoint
        CALL AVEF(x,i,id,igp,iys,idy,xanc)
        CALL STDM(x,i,id,igp,iys,idy,xanc,xsd,imm,ism)
      enddo
c
      do k=1,idy
        write(10,rec=k)(xanc(k,i),i=1,igp)
        write(20,rec=k)(xsd(k,i),i=1,igp)
      enddo
c
c     Computes anomalies w.r.t. annual cycle
      k = 0
      do it=1,id2
        read(1,rec=it)(x0(i),i=1,igp)
        k= k + 1
        if(k.gt.idy)k=1
        if(it.ne.lyd(1).and.it.ne.lyd(2).and.it.ne.lyd(3).
     .                  and.it.ne.lyd(4).and.it.ne.lyd(5))then
          do i=1,igp
            xanom(i) = x0(i) - xanc(k,i)
          enddo
        else
          do i=1,igp
            xanom(i) = x0(i) - xanc(k-1,i)
          enddo
        endif
        write(30,rec=it)(xanom(i),i=1,igp)
      enddo
c
      stop
      end
c
c
      SUBROUTINE AVEF(x,j2,id,igp,iys,idy,xanc)
c     This subroutine will compute the annual cycle. For example
c     xanc(1,i) corresponds to January 1 of the annual cycle for gridpoint i.
c     xanc(30,i) corresponds to January 30 of the annual cycle for gridpoint i.
c
      dimension x(id,igp)
      dimension xanc(idy,igp)    !annual cycle for gridpoint =j2
c
      xa0cum = 0.
      xa1cum = 0.
      xa2cum = 0.
      xb1cum = 0.
      xb2cum = 0.
      x2pi = 2*3.1415926536
      do 10 k=1,id
        xa0cum = xa0cum + x(k,j2)
        xa1cum = xa1cum + x(k,j2)*cos(x2pi*k/float(idy))
        xa2cum = xa2cum + x(k,j2)*cos(2*x2pi*k/float(idy))
        xb1cum = xb1cum + x(k,j2)*sin(x2pi*k/float(idy))
        xb2cum = xb2cum + x(k,j2)*sin(2*x2pi*k/float(idy))
10    continue
      xa0 = xa0cum/float(id)
      xa1 = 2*xa1cum/float(id)
      xa2 = 2*xa2cum/float(id)
      xb1 = 2*xb1cum/float(id)
      xb2 = 2*xb2cum/float(id)
c
      do 20 k=1,idy
       xanc(k,j2)=xa0 + xa1*cos(x2pi*k/float(idy)) +
     . xa2*cos(2*x2pi*k/float(idy)) + xb1*sin(x2pi*k/float(idy)) +
     . xb2*sin(2*x2pi*k/float(idy))
20    continue
      return
      end
c
c
      SUBROUTINE STDM(x,j2,id,igp,iys,idy,xanc,xstd,imm,ism)
c     This subroutine computes the standard deviation from annual cycle
c     Notice that this routine is repeated for each of the 
c     gridpoint (igp=192) values given by x(j2).
c     xanc(k=1) is the average of iys years of 1 January.
c
      real x(id,igp)
      real xanc(idy,igp)   !annual cycle for gridpoint =j2
      real xsd(idy)        !annual average of standard deviation
      real xstm(imm)       !Standard deviation for j2
      real xstd(idy,igp)   !final standard deviation
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
          xvar = xvar + (x(it,j2)-xanc(k,j2))**2
10      continue
        xsd(k) = sqrt(xvar/float(iys))
            xstd(k,j2) =xsd(k)
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
c  Get a rect line linking these imm points
c
      do 60 i = 1,imm
        if(i.ne.imm) then
          slope = (xstm(i+1)-xstm(i))/float(ism)
          do 50 k=1,ism
            xstd(mm(i)+k,j2) = slope*k + xstm(i)
50        continue
        endif
        if(i.eq.imm) then      !Edge
          slope = (xstm(1)-xstm(i))/float(ism)
          do 55 k=1,20  !the remaining from 346 to 365
            xstd(mm(i)+k,j2) = slope*k + xstm(i)
55        continue
          do 58 k=1,16  !the initial 15 points
            xstd(k,j2) = slope*(k-mm(1)) + xstm(1)
58        continue
        endif
60    continue
c
      return
      end
