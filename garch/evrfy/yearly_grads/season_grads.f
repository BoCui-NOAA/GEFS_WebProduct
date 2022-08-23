      PROGRAM SEASON 
      parameter(icyc=99,jcyc=99,iv=14)
      dimension dat(icyc,iv,jcyc)                    
      character*7 cyy(icyc)
ccc 
      dat=-999.99

      open(unit=10,file='season_g.dat',form='FORMATTED',status='OLD')

      jcnt=0
      do jc = 1, jcyc
       icnt=0
       do ic = 1, icyc
        read (10,201,end=1000) cyy(ic),(dat(ic,i,jc),i=1,14)
        write (*,201) cyy(ic),(dat(ic,i,jc),i=1,7)
        if (cyy(ic)==cyy(1).and.ic.gt.1) then
         print *, "the same"
         backspace (10)
         goto 1001
        endif
        icnt=icnt+1
       enddo
 1001  continue
       jcnt=jcnt+1
      enddo
 1000 continue
      jcnt=jcnt+1
 200  format(1x)                              
 201  format(a7,3(f7.4),4(f7.2),3(f7.4),4(f7.2))

      print *, 'icnt=',icnt,' and jcnt=',jcnt
CCC
CCC   write out to grads format
CCC
      open(unit=51,file='season_grads.dat',form='UNFORMATTED',err=1030)
      do ic = 1, icnt  
       do i = 1, 14     
        write (51) (dat(ic,i,jc),jc=1,jcnt)                        
       enddo
      enddo

      STOP
 1030 print *, "There is a problem to open unit=51"

      STOP
      END
