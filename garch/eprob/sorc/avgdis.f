      program avgdis
C
C  to make the average of monthly distribution of relative measure
C
      parameter (idays=99)
      dimension anh(11,32,idays),bnh(11,32)
      dimension ash(11,32,idays),bsh(11,32)
      dimension atr(11,32,idays),btr(11,32)
      character*80 cfile(idays)
      character*80 ofile
      namelist/files/cfile,ofile,jdays

      read  (5,files)
      write (6,files)

      do ii = 1, jdays
       open(unit=11,file=cfile(ii),form='formatted',status='old')
       do jj = 1, 32
        read (11,999) (anh(kk,jj,ii),kk=1,11)
        read (11,999) (ash(kk,jj,ii),kk=1,11)
        read (11,999) (atr(kk,jj,ii),kk=1,11)
       write (*, 998) (anh(kk,jj,ii),kk=1,11)
       enddo
       close (unit=11)
      enddo

      bnh=0.0
      bsh=0.0
      btr=0.0

      do jj = 1, 32
       do kk = 1, 11
        do ii = 1, jdays
        bnh(kk,jj) = bnh(kk,jj) + anh(kk,jj,ii)/float(jdays)
        bsh(kk,jj) = bsh(kk,jj) + ash(kk,jj,ii)/float(jdays)
        btr(kk,jj) = btr(kk,jj) + atr(kk,jj,ii)/float(jdays)
        enddo
       enddo
      enddo
      
      open(unit=51,file=ofile,form='formatted',status='unknown')

      do jj = 1, 32
       write (51,998) (bnh(kk,jj),kk=1,11)
       write (* ,998) (bnh(kk,jj),kk=1,11)
       write (51,998) (bsh(kk,jj),kk=1,11)
       write (51,998) (btr(kk,jj),kk=1,11)
      enddo

      close (unit=51)

 998  format (11f6.3)
 999  format (5x,11f6.3)
      stop
      end
