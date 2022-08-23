      PROGRAM PROBMN
      parameter (nens=NENS,nep1=nens+1,lrg=6,len=30)
      dimension anp(nep1,lrg,len),danp(nep1)
      dimension fcp(nep1,lrg,len),dfcp(nep1)
      dimension fpb(nep1,lrg,len),dfpb(nep1)
      dimension fpf(nep1,lrg,len),dfpf(nep1)
      dimension bsf(11,lrg,len),dbsf(11)
      dimension bsc(11,lrg,len),dbsc(11)
      dimension bst(11,lrg,len),dbst(11)
      dimension pfs(lrg,len)
      dimension pfc(lrg,len)
      dimension rps(lrg,len)
      dimension hrt(nep1,lrg,len),dhrt(nep1)
      dimension fam(nep1,lrg,len),dfam(nep1)
      dimension hrh(11,lrg,len),dhrh(11)
      dimension fah(11,lrg,len),dfah(11)
      dimension hrl(11,lrg,len),dhrl(11)
      dimension fal(11,lrg,len),dfal(11)
      character*80 cfile,cfileo
      character*28 asuniti,asunitk
      namelist/filec/ cfile
      namelist/namin/ ictl,cfileo
      data iunit/11/,kunit/51/
ccc
      write (asuniti,'(22Hassign              u:i2)') iunit
      write (asunitk,'(22Hassign              u:i2)') kunit
      call assign(asuniti,ier)
      call assign(asunitk,ier)
ccc
      read  (5,filec,end=100)
 100  continue
      write (6,filec)
      read  (5,namin,end=102)
 102  continue
      write (6,namin)
      open(unit=kunit,file=cfileo,form='FORMATTED',
     1     status='NEW')
ccc
ccc   Read 500 mb probability scores:  
ccc
      anp  = 0.0
      fcp  = 0.0
      fpb  = 0.0
      fpf  = 0.0
      bsf  = 0.0
      bsc  = 0.0
      bst  = 0.0
      pfs  = 0.0
      pfc  = 0.0
      rps  = 0.0
      hrt  = 0.0
      fam  = 0.0
      hrh  = 0.0
      fah  = 0.0
      hrl  = 0.0
      hrl  = 0.0
      open(unit=iunit,file=cfile,form='FORMATTED',
     1     status='OLD')
      do ii = 1, len
       jf = ii*12
       do jj = 1, lrg
c       if (ictl.ne.0) then
         read  (iunit,*)
         read  (iunit,*)
         read  (iunit,*)
         read  (iunit,1001) (danp(i),i=1,nep1)
         read  (iunit,1001) (dfcp(i),i=1,nep1)
         read  (iunit,*)
         read  (iunit,1002) (dfpb(i),i=1,nep1)
         read  (iunit,1002) (dfpf(i),i=1,nep1)
         read  (iunit,*)
         read  (iunit,1003) (dbsf(i),i=1,11)
         read  (iunit,1003) (dbsc(i),i=1,11)
         read  (iunit,1003) (dbst(i),i=1,11)
         read  (iunit,1004) dpfs,dpfc
         read  (iunit,1005) drps
         if (ictl.eq.12.or.ictl.eq.13.or.ictl.eq.0) then
          read  (iunit,*)
          read  (iunit,1003) (dhrt(i),i=1,nep1)
          read  (iunit,1003) (dfam(i),i=1,nep1)
         endif
         if (ictl.eq.1) then
          read  (iunit,*)
          read  (iunit,1003) (dhrt(i),i=1,nep1)
          read  (iunit,1003) (dfam(i),i=1,nep1)
          read  (iunit,*)
          read  (iunit,1003) (dhrh(i),i=1,11)
          read  (iunit,1003) (dfah(i),i=1,11)
          read  (iunit,*)
          read  (iunit,1003) (dhrl(i),i=1,11)
          read  (iunit,1003) (dfal(i),i=1,11)
         endif
c       else
c        read  (iunit,*)
c        read  (iunit,*)
c        read  (iunit,*)
c        read  (iunit,1001) (danp(i),i=1,nep1)
c        read  (iunit,1001) (dfcp(i),i=1,nep1)
c        read  (iunit,*)
c        read  (iunit,1002) (dfpf(i),i=1,nep1)
c       endif
cccccccccc
        sanp = 0.0
        sfcp = 0.0
        xinfsum = 0.0
        do i = 1, nep1
c
         if ( ictl.eq.0 ) then
         if (i.gt.1) then
          sanp = sanp + danp(i)
          sfcp = sfcp + dfcp(i)
         endif
         if ( i.gt.1.and.dfpf(i).gt.0.0 ) then
          xrat1=dfpf(i)/100.0
          xrat2=(1.0-xrat1)/9.0
          xinf = (alog10(xrat1))*xrat1
          xinf = xinf+(alog10(xrat2))*xrat2*9.0
          xinfsum = xinfsum + xinf*dfcp(i)
         endif
         else
          sanp = sanp + danp(i)
          sfcp = sfcp + dfcp(i)
         if ( dfpf(i).gt.0.0 ) then
          xrat1=dfpf(i)/100.0
          xinf = (alog10(xrat1))*xrat1
          xinfsum = xinfsum + xinf*dfcp(i)
         endif
         endif
        enddo
        xinfsum = xinfsum/sfcp
c       print *, 'sfcp=',sfcp
        if (ictl.eq.0) then
        write (kunit,1006) jj,jf,sanp/sfcp,1.0+xinfsum
        else
        write (kunit,1006) jj,jf,sanp/sfcp,1.0+xinfsum*10.0
        endif
       enddo
      enddo
      close (iunit)
ccc
 1000 format(22x,i8,7x,i8)
 1001 format(11f6.0)
 1002 format(11f6.1)
 1003 format(11f6.3)
 1004 format(29x,2F6.3)
 1005 format(34x,E15.8)
 1006 format(i1,' F',i3,' Overall Reliability = ',f8.3,
     .' Information Content = ',f8.3)
 1007 format(15f6.1)
 1011 format(' ---------- Northern Hemisphere --------------')
 1012 format(' ----------Southern Hemisphere --------------')
 1013 format(' ----------     Tropics   --------------')
 1014 format(' ---------- N. America   --------------')
 1015 format(' -------------Europe------------------')
 1016 format(' ----------     India   --------------')
 1021 format(' FORECAST PROBABILITY ')
 1022 format(' RELIABILITY DIAGRAM  ')
 1023 format(' BRIER SCORES  ')
 1024 format(' RANKED PROBABILITY SCORES = ',2F6.3)
 1025 format(' RANKED PROBABILITY SKILL SCORE = ',E15.8)
 1026 format(' HIT RATES AND FALSE ALARMS OF ENSEMBLE FORECASTS')
 1027 format(' HIT RATES AND FALSE ALARMS FOR MRF ')
 1028 format(' HIT RATES AND FALSE ALARMS FOR LOW RESOLUTION MODEL')
      stop
      end
