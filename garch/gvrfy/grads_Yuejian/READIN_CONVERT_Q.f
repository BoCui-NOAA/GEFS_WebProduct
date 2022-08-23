      program READIN
C--------+---------+---------+---------+---------+---------+---------+---------+
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC
CCC   nf - no. of fields ( z,u,v )
CCC   nl - no. of levels ( 1000, 850, 500 )
CCC   nh - no. of regions ( nh, sh, tropical )
CCC   ng - no. of wave groups ( 1-3, 4-9, 10-20, 1-20 )
CCC   nd - no. of forecast length ( 5-days )
CCC   nfh- no. of nf*nh
CCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter (nfh=17, nv=24, nd=17)                                
c     dimension acr(nfh,nv,nd),rms(nfh,nv,nd)            
c     dimension tacr(nv),trms(nv)            
      dimension ifile(nd)
      character*80 cfile(nd)
      character*80 ofile
      character*71 acr(nfh,nv,nd),rms(nfh,nv,nd)
      character*71 tacr(nv),trms(nv)
      namelist/namin/cfile,ifile,ofile
CCC
      read (5,namin)
      write(6,namin)

      do ii = 1, nd   
       if (ifile(ii).eq.1) then
        print *, cfile(ii)
        open(unit=11,file=cfile(ii),err=1020)
        do jj = 1, nv
         read (11,991)
         read (11,992) tacr(jj)
         do kk = 1, nfh
          read (11,992) acr(ii,jj,kk)
          print*,       acr(ii,jj,kk)
         enddo

         read (11,991)
         read (11,992) trms(jj)
         do kk = 1, nfh
          read (11,992) rms(ii,jj,kk)
         enddo
        enddo
        close(unit=11)
       endif
      enddo
         
  991 format(a1)
  992 format(a71)
CCC
CCC   write out to format text
CCC
      open(unit=51,file=ofile,form='FORMATTED',err=1020)
      do jj = 1, nv
       write (51,991)
       write (51,992) tacr(jj)
       do ii = 1, nd
        do kk = 1, nfh
         if (ii.eq.kk) then
         write (51,992) acr(ii,jj,kk)
         endif
        enddo
       enddo

       write (51,991)
       write (51,992) trms(jj)
       do ii = 1, nd
        do kk = 1, nfh
         if (ii.eq.kk) then
         write (51,992) rms(ii,jj,kk)
         endif
        enddo
       enddo

      enddo
      close(unit=51)

      stop
 1020 print *, ' there is a error to open unit 11'
      stop
      end
