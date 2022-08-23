      program tmp
      dimension aa(14,12)
      open (unit=5,file='tmp.dat',status='old')

      do i = 1, 14
      read(5,999) (aa(i,j),j=1,8)
      aa(i,9) = aa(i,5) - aa(i,1)
      aa(i,10)= aa(i,6) - aa(i,2)
      aa(i,11)= aa(i,7) - aa(i,3)
      aa(i,12)= aa(i,8) - aa(i,4)
      enddo

      do i = 1, 14
      write(*,998) (aa(i,j),j=1,12)
      enddo
      
 998  format(6x,12f6.1)
 999  format(6x,8f7.2)
      stop
      end
  
