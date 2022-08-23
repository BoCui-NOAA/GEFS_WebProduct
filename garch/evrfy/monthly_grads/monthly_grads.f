      PROGRAM MONTHLY
      parameter(icyc=200,iv=14)
      dimension dat(icyc,iv)                    
ccc 
      dat=-999.99

      open(unit=10,file='monthly_g.dat',form='FORMATTED',status='OLD')
c     read (10,200)
c     read (10,200)
      do ic = 1, icyc
      read (10,201,end=1000) (dat(ic,i),i=1,14)
c      print *, (dat(ic,i),i=1,14)
      if (dat(ic,1).lt.0.0 ) then
      do  i = 1, 14
      dat(ic,i)= -9.9900
      enddo
      endif
      write (*,201) (dat(ic,i),i=1,7)
      enddo
 1000 continue
 200  format(1x)                              
 201  format(6x,3(f7.4),4(f7.2),3(f7.4),4(f7.2))

CCC
CCC   write out to grads format
CCC
      open(unit=51,file='monthly_grads.dat',form='UNFORMATTED',err=1030)
       do ic = 1, icyc  
      do i = 1, 14     
        write (51) dat(ic,i)                                  
       enddo
      enddo

      STOP
 1030 print *, "There is a problem to open unit=51"

      STOP
      END
