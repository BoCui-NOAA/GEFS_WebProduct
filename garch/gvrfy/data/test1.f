      program test
      dimension a(145,37)
C--------+----------+---------+---------+---------+---------+---------+--
      open (unit=50,file='/nfsuser/g01/wx20yz/gvrfy/data/cac8ys.ibmsp',
     *      status='old',form='unformatted')
      il=1000
      do k = 1, 12
       read (50) ik,il,a
       print *, '--',ik,il,a(1,1)
      enddo
      il=500  
      do k = 1, 12
       read (50) ik,il,a
       print *, '--',ik,il,a(1,1)
      enddo
 999  format(5f10.4)
      stop
      end
