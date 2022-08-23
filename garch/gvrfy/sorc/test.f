      program test                            
ccc
ccc   get climatology:
ccc       input: unit 41 --- nmc30y.ibmsp ( for north hemsphere )
ccc              unit 42 --- cac8ys.ibmsp ( for south hemsphere )
ccc              nmc30y From equator ---> pole
ccc              cac8ys From pole    ---> equator
ccc
      dimension cnh(145,37),csh(145,37),glb(144,73)
c
c--------+---------+---------+---------+---------+----------+---------+--
      open (unit=41,
     *      file='/nfsuser/g01/wx20yz/gvrfy/data/nmc30y.ibmsp',
     *      status='old',form='unformatted')
      open (unit=42,
     *      file='/nfsuser/g01/wx20yz/gvrfy/data/cac8ys.ibmsp',
     *      status='old',form='unformatted')
      open(unit=51,file='xxx',form='UNFORMATTED')

      ilev=500
      if (ilev.eq.1000) then
          jlev = 1
      elseif (ilev.eq.500) then
          jlev = 2
      endif
c
      do imon = 1, 12
      icnt = imon  + (jlev - 1)*12
      if (icnt.eq.1) goto 101
      do i = 1, icnt - 1
         read (41)              
         read (42)                
      enddo
 101  continue
      read (41) imn,iln,cnh
      read (42) ims,ils,csh
      print *, '=== nmc30y ( nh ) and cac8y ( sh ) ==='
      write (6,991) imon,ilev,imn,iln
 991  format ('*** ask month=',i2,' level=',i4,' read month=',i2,
     *        ' level=',i4,' ***')
      do i = 1, 37
       do j = 1, 144
          glb(j,74-i) = csh(j,i)
          glb(j,38-i) = cnh(j,i)
       enddo   
      enddo
      write (51) ((glb(j,i),j=1,144),i=73,1,-1)
      rewind(41)
      rewind(42)
      enddo
      close(41)    
      close(42)    
      close(51)
      stop   
      end

