      program ROC_ETC 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC   Ralative Operational Characteristic (ROC) Area
CCC   Based on Hitting rate and False alarms
CCC    line 1: from (0,0) to location of hit&false
CCC    line 2: from location of hit&false to (1,1)
CCC    line 3: from (0,0) to (1,1)
CCC
CCC   Reliability
CCC
CCC   Ranked Probability Skill Scores (RPSS)
CCC
CCC   Brier Skill Scores (BSS)
CCC
CCC    Last modified 07/23/2001 by Yuejian Zhu
CCC 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter (iday=30,ireg=6,imem=14)
      parameter (imp1=imem+1)
      dimension xeh(iday,ireg,imp1),xef(iday,ireg,imp1)
      dimension xh(iday,ireg,2),xf(iday,ireg,2)
      dimension xd(iday,ireg,2)
      dimension ss(iday,ireg,2),se(iday,ireg)
      dimension rpss(iday,ireg),bss(iday,ireg)
      character*80 cfin,cfout,ofile
      namelist/files/cfin,cfout,ofile
 
      read (5,files)
      write(6,files)

      open(unit=10,file=cfin,form='formatted',status='old',err=1000)
      open(unit=50,file=cfout,form='formatted',status='new',err=1000)

      do i = 1, iday
       read (10,990)
       do j = 1, ireg
        if (imem.eq.20) then
         do k = 1, 15
          read (10,990)
         enddo
         read (10,992) bss(i,j) 
         read (10,990)
         read (10,990)
         read (10,994) rpss(i,j)
        elseif (imem.eq.14) then
         do k = 1, 15
          read (10,990)
         enddo
         read (10,992) bss(i,j) 
         read (10,990)
         read (10,990)
         read (10,994) rpss(i,j)
        elseif ( imem.eq.10 ) then
         do k = 1, 15
          read (10,990)
         enddo
         read (10,992) bss(i,j) 
         read (10,990)
         read (10,990)
         read (10,994) rpss(i,j)
        endif

        read (10,993) rpss(i,j)
        read (10,991) (xeh(i,j,k),k=1,imp1)
c       write(6, 991) (xeh(i,j,k),k=1,imp1)
        read (10,991) (xef(i,j,k),k=1,imp1)
        read (10,990)
        read (10,992) xh(i,j,1)
c       write(6, 992) xh(i,j,1)
        read (10,992) xf(i,j,1)
        read (10,990)
        read (10,992) xh(i,j,2)
        read (10,992) xf(i,j,2)
       enddo
      enddo
c
      do i = 1, iday
       do j = 1, ireg
        sc = 0.0
        do k = 1, imp1+1
         x0 = 0.0
         y0 = 1.0
         if ( k.eq.1) then
          x1 = 1.0
          y1 = 1.0
         else
          x1 = xef(i,j,k-1)
          y1 = xeh(i,j,k-1)
         endif
         if ( k.eq.(imp1+1)) then
          x2 = 0.0
          y2 = 0.0
         else
          x2 = xef(i,j,k)
          y2 = xeh(i,j,k)
         endif

         xa = sqrt((x0-x1)*(x0-x1)+(y0-y1)*(y0-y1))
         xb = sqrt((x0-x2)*(x0-x2)+(y0-y2)*(y0-y2))
         xc = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
         xs = 0.5*(xa+xb+xc)
         sc = sc + sqrt(xs*(xs-xa)*(xs-xb)*(xs-xc))
        enddo
c
        do kk = 1, 2
         dmin = 999.99
         sign = 1.0
         x0 = xf(i,j,kk)
         y0 = xh(i,j,kk)
         xa = sqrt((x0-1.0)*(x0-1.0)+(y0-1.0)*(y0-1.0))
         xb = 1.414
         xc = sqrt(x0*x0+y0*y0)
         xs = 0.5*(xa+xb+xc)
         s  = sqrt(xs*(xs-xa)*(xs-xb)*(xs-xc))
c
         do k = 1, imem
          x0 = xf(i,j,kk)
          y0 = xh(i,j,kk)
          d  = 0.0
          d1 = 0.0
          d2 = 0.0
          x1 = xef(i,j,k)
          y1 = xeh(i,j,k)
          x2 = xef(i,j,k+1)
          y2 = xeh(i,j,k+1)
          a = y1 - y2
          b = x2 - x1
          c = -a*x1 - b*y1
          if (a.eq.0.0) goto 100
          if (b.eq.0.0) goto 100
          if (c.eq.0.0) goto 100
          ccc   = (b*x0/a-y0-c/b)
          x = (a*b/(a*a+b*b))*ccc
          y = -(a*a/(a*a+b*b))*ccc - c/b
          if (x.le.x1.and.x.ge.x2) then
           if (x0.lt.x.and.y0.gt.y) then
            sign = -1.0
           else
            sign = 1.0
           endif
           a0 = x - x0
           b0 = y - y0
           d = sqrt(a0*a0 + b0*b0)
           if (d.lt.dmin) then
            dmin = d
           endif
          else
           a1 = x1 - x0
           a2 = x2 - x0
           b1 = y1 - y0
           b2 = y2 - y0
c
           d1 = sqrt(a1*a1 + b1*b1)
           d2 = sqrt(a2*a2 + b2*b2)
           if (d1.lt.d2) then
            if (d1.lt.dmin) then
             dmin = d1
            endif
           else
            if (d2.lt.dmin) then
             dmin = d2
            endif
           endif
          endif
c         write (*,'(4i2,11f6.3)') i,j,kk,k,x0,y0,x1,y1,x2,y2,x,y,d,d1,d2
         enddo
 100     continue
         xd(i,j,kk) = sign*dmin
         ss(i,j,kk) = s
         se(i,j) = 0.5 - sc
        enddo
       enddo
      enddo
      do j = 1, ireg
      do i = 1, iday
       ih=i*12
      write(50,993) ih,ss(i,j,1),ih,ss(i,j,2),ih,se(i,j)
      enddo
      enddo
      open(unit=51,file=ofile,form='UNFORMATTED',err=1000)
      do i = 1, iday
       write (51) (ss(i,j,1),j=1,ireg)
       write (51) (ss(i,j,2),j=1,ireg)
       write (51) (se(i,j),j=1,ireg)
       write (51) (rpss(i,j),j=1,ireg)
       write (51) (bss(i,j),j=1,ireg)
      enddo
 990  format(10x)
 991  format(11f6.3)
 992  format(60x,f6.3)
 993  format(3(i4,f9.4))
 994  format(24x,e15.8)  

      stop
 1000 print *, " There is a problem to open a data file"
      stop
      end

