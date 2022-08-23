      subroutine fitwav(field,iws,iwe,iromb)
      parameter (maxwv=40,mx=(maxwv+1)*(maxwv+2)/2)
c     parameter (maxwv=40,mx=861)
c     parameter (maxwv=60,mx=1891)
      dimension field(144,73),wave(2,mx),wavef(2,mx)

c
c     using sptez instead of sphert in splib
c
      call sptez(iromb,maxwv,0,144,73,wave,field,-1)      
c
c     fill zero for wave number less than iws and great than iwe 
c
      wavef = 0.0
      ij = 0
      do m = 1, maxwv+1
       do n = m, maxwv+1 
        ij = ij + 1
c       if (n.eq.(iws+2).and.m.eq.4) then
        if (n.gt.iws.and.n.le.(iwe+1)) then
c       if (m.gt.iws.and.m.le.(iwe+1)) then
c        print *, 'n,m,ij=',n,m,ij
         wavef(1,ij) = wave(1,ij)
         wavef(2,ij) = wave(2,ij)
        endif
       enddo
      enddo
      call sptez(iromb,maxwv,0,144,73,wavef,field,1)      

      return
      end

