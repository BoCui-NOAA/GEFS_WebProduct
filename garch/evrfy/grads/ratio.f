      program tmp
      dimension aa(2,14,14),bb(2,14)
      open (unit=5,file='ratio.dat',status='old')

      do i = 1, 14
      read(5,999) (aa(1,i,j),j=1,14)
      write(6,999) (aa(1,i,j),j=1,14)
      enddo
      do i = 1, 14
      read(5,999) (aa(2,i,j),j=1,14)
      write(6,999) (aa(2,i,j),j=1,14)
      enddo

      bb = 0.0
      do j = 1, 14
       do i = 1, 14
       bb(1,j) = bb(1,j) + aa(1,i,j)/14.0
       bb(2,j) = bb(2,j) + aa(2,i,j)/14.0
       enddo
      enddo

      do j = 1, 14
       rday=float(j)/2.0
       write(*,998) rday,bb(1,j)*100.0,rday,bb(2,j)*100.0
      enddo
      
 998  format(f4.1,f8.1,f4.1,f8.1)
 999  format(f6.3,13(1x,f6.3))
      stop
      end
  
