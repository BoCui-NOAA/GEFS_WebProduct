      program dist
      parameter (id=30)
      dimension ehr(15),efa(15),dhh(14),dll(14)
      dimension xh0(id),xh1(id),xh2(id),xl0(id),xl1(id),xl2(id)
      dimension yh0(id),yh1(id),yh2(id),yl0(id),yl1(id),yl2(id)
      dimension dh(id),dl(id)
c
      dh = 0.0
      dl = 0.0
     
c     xh0(1) = 0.041
c     xh1(1) = 0.052
c     xh2(1) = 0.040
c     yh0(1) = 0.627
c     yh1(1) = 0.628
c     yh2(1) = 0.557
      
      do i = 1, id
       read (5,981)
       read (5,982) (ehr(j),j=1,15)
       read (5,982) (efa(j),j=1,15)
       read (5,981)
       read (5,983) yh0(i)
       read (5,983) xh0(i)
       read (5,981)
       read (5,983) yl0(i)
       read (5,983) xl0(i)
c      read (5,983) yh0(i)
c      read (5,983) xh0(i)
  
       jyhr = 0
       jxhr = 0
c
c for high resolution
c
       do j = 1, 12
        if (yh0(i).le.ehr(j).and.yh0(i).gt.ehr(j+1)) then
         jyhr = j
         goto 1001
        endif
 1001   continue
        if (xh0(i).le.efa(j).and.xh0(i).gt.efa(j+1)) then
         jxhr = j
         goto 1002
        endif
 1002   continue
         yh2(i) = ehr(j)
         yh1(i) = ehr(j+1)
         xh2(i) = efa(j)
         xh1(i) = efa(j+1)

c      write (*,'(i2,1x,6f6.3)') i,yh2(i),yh1(i),yh0(i)
c    *                             ,xh2(i),xh1(i),xh0(i)

       a=yh2(i)-yh1(i)
       b=xh1(i)-xh2(i)
       c=-a*xh1(i) - b*yh1(i)
c
       a2   = yh2(i) - yh0(i)
       b2   = xh2(i) - xh0(i)
       d2   = sqrt(a2*a2 + b2*b2)
       a1   = yh1(i) - yh0(i)
       b1   = xh1(i) - xh0(i)
       d1   = sqrt(a1*a1 + b1*b1)

       dhh(j)=-(a*xh0(i)+b*yh0(i)+c)/sqrt(a*a+b*b)

       if ( jyhr.ne.jxhr ) then
        if ( jyhr.eq.j.or.jxhr.eq.j) then
         write (*,'(3i4,1x,3f8.5)') j,jyhr,jxhr,d2,d1,dhh(j)
        endif
        if ( jyhr.eq.j ) then
         if ( dhh(j).ge.0.0 ) then
          dh(i) = d1
         else
          if ( abs(dhh(j)).le.abs(dhh(j-1)) ) then
           dh(i) = dhh(j)
          else
           dh(i) = dhh(j-1)
          endif
         endif
        endif
       endif

       if ( jyhr.eq.jxhr.and.jxhr.eq.j) then
        write (*,'(3i4,1x,3f8.5)') j,jyhr,jxhr,d2,d1,dhh(j)
        dh(i) = dhh(j)
       endif
       
       enddo

       write (*,'(i2,1x,12f6.3)') i,(dhh(j),j=1,12)
c
c for low resolution 
c
       do j = 1, 12
        if (yl0(i).le.ehr(j).and.yl0(i).gt.ehr(j+1)) then
         jyhr = j
         goto 1003
        endif
 1003   continue
        if (xl0(i).le.efa(j).and.xl0(i).gt.efa(j+1)) then
         jxhr = j
         goto 1004
        endif
 1004   continue
         yl2(i) = ehr(j)
         yl1(i) = ehr(j+1)
         xl2(i) = efa(j)
         xl1(i) = efa(j+1)

       a=yl2(i)-yl1(i)
       b=xl1(i)-xl2(i)
       c=-a*xl1(i) - b*yl1(i)
c
       a2   = yl2(i) - yl0(i)
       b2   = xl2(i) - xl0(i)
       d2   = sqrt(a2*a2 + b2*b2)
       a1   = yl1(i) - yl0(i)
       b1   = xl1(i) - xl0(i)
       d1   = sqrt(a1*a1 + b1*b1)

       dll(j)=-(a*xl0(i)+b*yl0(i)+c)/sqrt(a*a+b*b)

       if ( jyhr.ne.jxhr ) then
        if ( jyhr.eq.j.or.jxhr.eq.j) then
         write (*,'(3i4,1x,3f8.5)') j,jyhr,jxhr,d2,d1,dhh(j)
        endif
        if ( jyhr.eq.j ) then
         if ( dll(j).ge.0.0 ) then
          dl(i) = d1
         else
          if ( abs(dll(j)).le.abs(dll(j-1)) ) then
           dl(i) = dll(j)
          else
           dl(i) = dll(j-1)
          endif
         endif
        endif
       endif

       if ( jyhr.eq.jxhr.and.jxhr.eq.j) then
        write (*,'(3i4,1x,3f8.5)') j,jyhr,jxhr,d2,d1,dll(j)
        dl(i) = dll(j)
       endif

       enddo

       write (*,'(i2,1x,12f6.3)') i,(dll(j),j=1,12)
      enddo
c
      do i = 1, id
      write (20,992) i,(dh(i),dl(i))
      enddo
 981  format(a)
 982  format(11f6.3)
 983  format(60x,f6.3)
 992  format(i2,1x,2(f9.5))
      stop
      end

