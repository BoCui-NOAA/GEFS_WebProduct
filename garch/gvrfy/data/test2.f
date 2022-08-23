      program test
      dimension a(144,73)
C--------+----------+---------+---------+---------+---------+---------+--
      open (unit=10,
     *      file='/nfsuser/g01/wx20yz/gvrfy/data/cac8y.v.format',
     *      status='old',form='formatted')
      open (unit=50,
     *      file='/nfsuser/g01/wx20yz/gvrfy/data/cac8y.v.ibmsp',
     *      status='new',form='unformatted')
      do il = 1, 12
      do k = 1, 12
       read (10,999) ((a(i,j),i=1,144),j=1,73)
       print *, '--',k,il,a(1,1)
       write(50) k,il,a
      enddo
      enddo
 999  format(5f10.4)
      stop
      end
