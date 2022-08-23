      program DECAYING_AVG

c     to calulate the weight function for past 30-day
c     program -- by Yuejian Zhu
c     04/09/2001

      parameter (itr=1000)
      dimension a(itr,3)

      open (unit=50,file='grads.dat',form='unformatted',status='new')

      do i = 1, 15
       a(i,1) = 1.0/15.0
      enddo
      do i = 16, itr
       do j = 1, i-1
        a(j,1) = a(j,1)*14.0/15.0
       enddo
       a(i,1) = 1.0/15.0
      enddo

      do i = 1, 30
       a(i,2) = 1.0/30.0
      enddo
      do i = 31, itr
       do j = 1, i-1
        a(j,2) = a(j,2)*29.0/30.0
       enddo
       a(i,2) = 1.0/30.0
      enddo

      do i = 1, 60
       a(i,3) = 1.0/60.0
      enddo
      do i = 61, itr
       do j = 1, i-1
        a(j,3) = a(j,3)*59.0/60.0
       enddo
       a(i,3) = 1.0/60.0
      enddo

      do i = itr, itr-100, -1
       write (*,999) a(i,1)
      enddo
      
      do i = 801, 1000
       write (50) (a(i,j),j=1,3)
      enddo

 999  format (f10.4)
      stop
      end
