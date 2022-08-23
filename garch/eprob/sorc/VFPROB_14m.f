      program VFPROB
      parameter(ngrid=10512,nens=14)
      parameter(ifprob=0,iprob=0,ictl=0)
      parameter(nep1=nens+1,jctl=iprob+ictl)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c--------+---------+---------+---------+---------+---------+---------+---------+
c     This is ensemble probability calculation program based on Gepal Iyenger
c     original program which only could handle 14 ensemble members.
c     The new feture of this program is more flexible with different
c     ensemble members, additional calculation such as maximum probability
c     and etc.
c     ----------------- Yuejian Zhu (07/18/97)
c
c     Modified to IBM-SP
c     ----------------- Yuejian Zhu (08/09/99)
c     
c     ngrid=10512 ; number of grid points in 2.5 X 2.5 resolution grid
c     nens=####   ; number of ensemble members or number of control forecasts.
c     clip(100)   ; climatology
c     anl         ; verification field
c     fmrf        ; control forecast field
c     ft62        ; low resolution forecast field
c     favn        ; avn run at 12Z                               
c     fcst        ; perturbed forecast fields
c     fcp(ngrid,10) ; forecast numbers at each point in ten climate bins
c     anp(ngrid,10) ; verification for forecast at each point 
c     rfcp
c     ranp
c     sfcp
c     sanp
c     fp
c     bsf         ; brier score for forecasts
c     bsc         ; brier score for climatological forecasts
c     bs          ; improvement ratio
c     nyy(11)
c     nyn(11)
c     hr(11)
c     falm(11)
c    
c     PARAMETERS:
c      1. ifprob = forecast probability ( 0:using default 1:using read in )
c      2. iprob  = single forecast control ( 1:MRF 2:T62 0:normal )
c      3. ictl   = 1:maximun calculation ( 1:max )                 
c                = 10:special calculation ( 10:for mrf or t62 )
c                  if ictl=10, nens must be 10.
c                = 0:normal
c
      dimension clip(100),clipm1(100),clipm2(100)
      dimension anl(ngrid),fmrf(ngrid),ft62(ngrid),favn(ngrid)
      dimension fcst(ngrid,nens)
      dimension fcp(ngrid,10),anp(ngrid,10)
      dimension rfcp(nep1,10),ranp(nep1,10),dfcp(ngrid,10)
      dimension sfcp(nep1),sanp(nep1),fp(nep1),fprob(0:nens)
      dimension bsf(11),bsc(11),bs(11)
      dimension nyy(nep1),nyn(nep1),nny(nep1),nnn(nep1)
      dimension hr(nep1),falm(nep1)
      dimension hrc(11),falmc(11)
      dimension latss(6),latee(6),lonss(6),lonee(6),rfp(10)
      dimension alat(73),weight(73),wdom(6)
      dimension kdate(100) 
      character*10 domain(6)
      character*29 file1,file2 
      character*80 cfilea(2,100),cfilef(2),filea(2),fileb(2)
      character*28 asunitg,asuniti
      character*40 asunit1,asunit2
      character*3 cmon(12)
      namelist/files/cfilea,cfilef
      namelist/kdata/kdate
      namelist/namin/nhours,ilv,kp5,kp6,kp7,icon,icoeff   
      data cmon/'JAN','FEB','MAR','APR','MAY','JUN',
     .          'JUL','AUG','SEP','OCT','NOV','DEC'/
      data latss/  6, 45, 29, 13,  6, 21/
      data latee/ 29, 68, 45, 29, 25, 37/
      data lonss/  1,  1,  1, 89,  1, 17/
      data lonee/144,144,144,125, 17, 49/
      data rfp/5.,15.,25.,35.,45.,55.,65.,75.,85.,95./
      data domain/'N HEM','S HEM','TROPICS','N Amer.','Europe','India'/
      data lupgi/21/,lupgb/11/
      data nuc1/13/,nuc2/14/,nuc/15/
      data file1/'/global/cdas/500HGT.'/
      data file2/'/global/cdas/500HGT.'/
c--------+---------+---------+---------+---------+---------+---------+---------+
c     OPEN THE FORMAT AND UNFORMATTED DATA SET              
c--------+---------+---------+---------+---------+---------+---------+---------+
      open(unit=10,file='Reference_200111.dat',err=1000)
      open(unit=51,file='prob.ens',err=1000)
      open(unit=nuc,file='flip',form='unformatted',
     .     status='unknown',err=1000)
c--------+---------+---------+---------+---------+---------+---------+---------+
c     READ THE NAMELIST FILES                               
c--------+---------+---------+---------+---------+---------+---------+---------+
      print *, '++++++++++++++++++++++++++++++++++++'
      print *, '        READ THE NAMELIST '
      print *, '++++++++++++++++++++++++++++++++++++'
      read  (5,files)
      write (6,files)
      read  (5,namin)
      write (6,namin)
      read  (5,kdata)
      write (6,kdata)
      call  wgt(weight,wdom)
c--------+---------+---------+---------+---------+---------+---------+---------+
c     READ THE ANALYSIS AND THE FORECAST FILES                
c--------+---------+---------+---------+---------+---------+---------+---------+
      nstep  =  nhours/12
      do 999 nfcst = 1, nstep
       nfp      = nfcst + 2
       ndate    = kdate(nfp)
       jdate    = kdate(1)
       mdate    = kdate(2)
       ifh      = 12*nfcst
       filea(1) = cfilea(1,1)
       filea(2) = cfilea(2,1)
       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '        READ ANALYSIS DATA'
       print *, '++++++++++++++++++++++++++++++++++++'
       call getanl(anl,filea(1),filea(2),kp5,kp7,ndate,0)
       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '        READ FORECAST DATA'
       print *, '++++++++++++++++++++++++++++++++++++'
       call getgrb(fcst,nens,fmrf,ft62,favn,cfilef(1),cfilef(2),
     *             kp5,kp7,jdate,mdate,ifh,10)
       if ( iprob.eq.1 ) then
        do ng = 1, ngrid
         fcst(ng,1) = fmrf(ng)
        enddo
       endif
       if ( iprob.eq.2 ) then
        do ng = 1, ngrid
         fcst(ng,1) = ft62(ng)
        enddo
       endif
c--------+---------+---------+---------+---------+---------+---------+---------+
c     READ CLIMATOLOGY(M1 & M2) PUT NEW CLIMATOLOGY OUT  
c--------+---------+---------+---------+---------+---------+---------+---------+
       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '       READ CLIMATOLOGY DATA'
       print *, '++++++++++++++++++++++++++++++++++++'
       call nd2ymd(ndate,jyr,jmth,jday,jhour)
       m1 = jmth
       file1(21:23) = cmon(m1)
       if (jday.le.15) then
        m2 = jmth-1
        if (m2.eq.0) then
         m2 = 12
        endif
       endif
       if (jday.gt.15) then
        m2 = jmth+1
        if (m2.gt.12) then
         m2 = 1
        endif
       endif
       file2(21:23) = cmon(m2)
       print *," MONTH-1 is ",file1
       print *," MONTH-2 is ",file2
       open(unit=nuc1,file=file1,form='unformatted',status='old')
       open(unit=nuc2,file=file2,form='unformatted',status='old')
       rewind (nuc1)
       rewind (nuc2)
c
       fac2 = abs((float(jday)-15.0)/30.)
       fac1 = 1.0-fac2
       print *,' DAY FACTORS (',ndate,')',fac1,fac2
c
       do ng = 1, ngrid
        read (nuc1) clipm1
        read (nuc2) clipm2
        do n = 1, 100
         clip(n) = clipm1(n)*fac1+clipm2(n)*fac2
        enddo
        write(nuc) clip
       enddo
       close (nuc1)
       close (nuc2)
c--------+---------+---------+---------+---------+---------+---------+---------+
c     READ NEW CLIMATOLOGY, CALCULATE FCST & ANL FALLING 10 CLIM BINS
c--------+---------+---------+---------+---------+---------+---------+---------+
       fcp = 0.0
       anp = 0.0
       rewind (nuc)  
       do ng = 1, ngrid
        read (nuc) clip
ccc   nenso is the option of nens in special calculation
        if (ictl.eq.10) then
         nenso = 1
        else
         nenso = nens
        endif
ccc
	do n = 1, nenso
	 fc = fcst(ng,n)
         if (fc.le.clip(10)) then
	  fcp(ng,1) = fcp(ng,1)+1
	  goto 102
	 endif
         if (fc.gt.clip(90)) then
	  fcp(ng,10) = fcp(ng,10)+1
	  goto 102
	 endif
         do nb = 2, 9
	  ll = (nb-1)*10 
	  lh = nb*10 
	  if (fc.gt.clip(ll).and.fc.le.clip(lh)) then
	   fcp(ng,nb) = fcp(ng,nb)+1
	   goto 102
	  else
	   goto 101
	  endif
 101  continue
         enddo       ! nb
 102  continue
        enddo        ! n
c
        if(anl(ng).le.clip(10))then
         anp(ng,1) = anp(ng,1)+1
        endif
        if(anl(ng).gt.clip(90))then
         anp(ng,10) = anp(ng,10)+1
        endif
        do nb = 2, 9
         ll = (nb-1)*10 
         lh = nb*10 
         if (anl(ng).gt.clip(ll).and.anl(ng).le.clip(lh)) then
          anp(ng,nb) = anp(ng,nb)+1
 	 endif
        enddo       ! nb
       enddo        ! ng
ccc --- using fcst(ngrid,nb) replace fcp(ngrid,nb) if (ictl.eq.10)
       if (ictl.eq.10) then
        do ng = 1, ngrid
         do nb = 1, 10
          fcst(ng,nb) = fcp(ng,nb)
         enddo
        enddo
       endif
c--------+---------+---------+---------+---------+---------+---------+---------+
c     Loop over the six domains : N Hem, S Hem, Trop, N America, India, Europe
c--------+---------+---------+---------+---------+---------+---------+---------+
       do 998 ndom = 1, 6
cccccc --- Background probability ( usually from previous month average )
        if (ifprob.eq.0) then
         if (ictl.eq.10) then
          fprob = 0.0 
          fprob(nens) = 100.0
         else 
          do np = 0, nens
           fprob(np) = (100.0/nens)*float(np)
          enddo
         endif
        else
c        read (10,1004)(fprob(np),np=0,nens)
         read (10,1005)(fprob(np),np=0,nens)
        endif
        lats = latss(ndom)
        late = latee(ndom)
        lons = lonss(ndom)
        lone = lonee(ndom)
        if(ndom.eq.1) write(51,1031)
        if(ndom.eq.1) write(*, 1031)
        if(ndom.eq.2) write(51,1032)
        if(ndom.eq.2) write(*, 1032)
        if(ndom.eq.3) write(51,1033)
        if(ndom.eq.3) write(*, 1033)
        if(ndom.eq.4) write(51,1034)
        if(ndom.eq.4) write(*, 1034)
        if(ndom.eq.5) write(51,1035)
        if(ndom.eq.5) write(*, 1035)
        if(ndom.eq.6) write(51,1036)
        if(ndom.eq.6) write(*, 1036)
        write(51,1021) ndate,jdate
c       if (nens.eq.14.or.nens.eq.10) then
        if (ictl.eq.10) then
         if(ndom.eq.1) write(52,1031)
         if(ndom.eq.2) write(52,1032)
         if(ndom.eq.3) write(52,1033)
         if(ndom.eq.4) write(52,1034)
         if(ndom.eq.5) write(52,1035)
         if(ndom.eq.6) write(52,1036)
                       write(52,1021) ndate,jdate
        endif
        write(*,1021)  ndate,jdate
c--------+---------+---------+---------+---------+---------+---------+---------+
c     RELIABILTY DIAGRAM                                            
c--------+---------+---------+---------+---------+---------+---------+---------+
        print *, '++++++++++++++++++++++++++++++++++++'
        print *, '        RELIABILITY DIAGRAM '
        print *, '++++++++++++++++++++++++++++++++++++'
        rfcp = 0.0
        ranp = 0.0
        indom= 0
        ofprob= 0.0
 201    continue
        do nlat = lats , late
         ngl    = (nlat-1)*144
         do nlon = lons , lone
          ng     = ngl+nlon
          wfac   = weight(nlat)*wdom(ndom)
ccc
ccc --- for forecast probability substitute and calculation
ccc
ccc --- PART I
          if (ictl.eq.10) then
           do nb = 1, 10
            if (fcst(ng,nb).eq.1.0) then
             do np = 1, 10
              nbp = 9 - abs(nb - np) 
              dfcp(ng,np) = fprob(nbp)
              fcp(ng,np)  = nbp                         
             enddo
            endif
           enddo
          else
           do nb = 1, 10
            dfcp(ng,nb) = fprob(int(fcp(ng,nb)))
           enddo
          endif
          if (ictl.eq.1) then
ccc
ccc --- for maximum calculation
ccc
           fcpmax= 0.0 
           do nb = 1, 10
            if (fcpmax.le.fcp(ng,nb)) then
             fcpmax = fcp(ng,nb)
             nbmax   = nb
            endif
           enddo
           do nb = 1, 10
            if (nb.ne.nbmax) then
             dfcp(ng,nb) = (100.0-dfcp(ng,nbmax))/9.0
             fcp(ng,nb)  = -1.0
            endif
           enddo
          endif
c
          do nb = 1, 10
           do np = 1, nep1   
            npm  = np-1
            if (fcp(ng,nb).eq.float(npm)) then
	     rfcp(np,nb) = rfcp(np,nb)+1*wfac
	     if (anp(ng,nb).ne.0.0) then
	      ranp(np,nb) = ranp(np,nb)+1*wfac
	     endif
	    endif
           enddo         ! np
          enddo          ! nb
         enddo           ! nlon
        enddo            ! nlat
c
c     For Europe region there is a break in the longitude loop. 
c     Computations are done twice first for 0-40E and then for 0-20W  
c
        lons  = 137
        lone  = 144
        indom = indom + 1
        if (ndom.eq.5.and.indom.eq.1) goto  201
        lons  = lonss(ndom)
        lone  = lonee(ndom)
c
        sanp = 0.0
        sfcp = 0.0
        fp   = 0.0
c
        do np = 1, nep1  
         do nb = 1, 10
          sanp(np) = sanp(np)+ranp(np,nb)
          sfcp(np) = sfcp(np)+rfcp(np,nb)
         enddo
         if (sfcp(np).ne.0.0) then
          fp(np) = (sanp(np)/sfcp(np))*100.0
         endif
        enddo
ccc
        write(51,1022)
        write(51,1001) (sanp(i),i=1,nep1)
        write(51,1001) (sfcp(i),i=1,nep1)
        write(51,1023)
        write(51,1005) (fprob(i),i=0,nens)
        write(51,1005) (fp(i),i=1,nep1)
        write(*, 1005) (fp(i),i=1,nep1)
c
c--------+---------+---------+---------+---------+---------+---------+---------+
c     COMPUTATION OF BRIER SCORES
c--------+---------+---------+---------+---------+---------+---------+---------+
        print *, '++++++++++++++++++++++++++++++++++++'
        print *, '  THE COMPUTATION OF BRIER SCORES'
        print *, '++++++++++++++++++++++++++++++++++++'
        bsf    = .0
        bsc    = .0
        ngp    =  0
        indom  =  0
 301    continue
        do nlat = lats, late
         ngl = (nlat-1)*144
         do nlon = lons, lone
          ng   = ngl+nlon
          ngp  = ngp+1
	  wfac = weight(nlat)*wdom(ndom)
	  do nb = 1 , 10
	   fcbs = dfcp(ng,nb)
	   anbs = anp(ng,nb)
	   if (anbs.ne.0.0) then
	    ei = 1.0
	   else
	    ei = 0.0
	   endif
           sf = (ei-fcbs/100.0)**2
	   sc = (ei-0.1)**2
           bsf(nb) = bsf(nb) + sf*wfac
	   bsc(nb) = bsc(nb) + sc*wfac
          enddo     ! nb
         enddo      ! nlon
        enddo       ! nlat
c
c     For Europe region there is a break in the longitude loop. 
c     Computations are done twice first for 0-40E and then for 0-20W  
c
        lons  = 137
        lone  = 144
        indom = indom + 1
        if (ndom.eq.5.and.indom.eq.1) goto  301
        lons = lonss(ndom)
        lone = lonee(ndom)
c
        bsfa = 0.0
        bsca = 0.0
        do nb = 1, 10
         bsf(nb) = bsf(nb)/float(ngp)
         bsfa    = bsfa+bsf(nb)
         bsc(nb) = bsc(nb)/float(ngp)
         bsca    = bsca+bsc(nb)
         if (bsc(nb).ne.0.0) then
          bs(nb) = (bsc(nb)-bsf(nb))/bsc(nb)
          if (bs(nb).le.-10.0) bs(nb)=-9.99
         endif
        enddo
c
        bsfa = bsfa/10.0
        bsca = bsca/10.0
        if (bsca.ne.0.0) then
         bsa = (bsca-bsfa)/bsca
         if (bsa.le.-10.0) bsa=-9.99
        endif
        bsf(11) = bsfa
        bsc(11) = bsca
        bs(11)  = bsa
c	
        write(51,1024)
        write(51,1002) (bsf(i),i=1,11)
        write(*, 1002) (bsf(i),i=1,11)
        write(51,1002) (bsc(i),i=1,11)
        write(51,1002) (bs(i),i=1,11)
c--------+---------+---------+---------+---------+---------+---------+---------+
c     RANKED PROBABILITY SCORE 
c--------+---------+---------+---------+---------+---------+---------+---------+
        print *, '++++++++++++++++++++++++++++++++++++'
        print *, '      RANKED PROBABILITY SCORE'
        print *, '++++++++++++++++++++++++++++++++++++'
        trpfs = .0
        trpfc = .0
        ngp   =  0
        indom =  0
 401    continue
        do nlat = lats, late
         ngl    = (nlat-1)*144
         do nlon = lons, lone
          ng     = ngl+nlon
          ngp    = ngp+1
          wfac   = weight(nlat)*wdom(ndom)
          rpfs   = .0
          rpfc   = .0
          do nb = 1, 10
           sfcbs = .0
           sfcbc = .0
	   sanbs = .0
	   do ii = 1, nb
	    fcbs  = dfcp(ng,ii)
	    fcbc  = .1 
	    anbs  = anp(ng,ii)
	    sfcbs = sfcbs+(fcbs/100.0)
	    sfcbc = sfcbc+fcbc
	    sanbs = sanbs+anbs
	   enddo
	   rpfs = rpfs+(sfcbs-sanbs)**2
	   rpfc = rpfc+(sfcbc-sanbs)**2
          enddo 
	  rpfs  = 1.0-(1.0/9.0)*rpfs
	  rpfc  = 1.0-(1.0/9.0)*rpfc
	  trpfs = trpfs+rpfs*wfac
	  trpfc = trpfc+rpfc*wfac
         enddo      ! nlon
        enddo       ! nlat
c
c     For Europe region there is a break in the longitude loop.
c     Computations are done twice first for 0-40E and then for 0-20W  
c
        lons  = 137
        lone  = 144
        indom = indom + 1
        if (ndom.eq.5.and.indom.eq.1) goto  401
        lons = lonss(ndom)
        lone = lonee(ndom)
c
        trpfs = trpfs/float(ngp)
        trpfc = trpfc/float(ngp)
        rpss  = (trpfs-trpfc)/(1-trpfc)
        write(51,1028) trpfs,trpfc
        write(51,1029) rpss
        write(*, 1029) rpss
c--------+---------+---------+---------+---------+---------+---------+---------+
c     RELATIVE OPERATING CHARACTERISTICS
c--------+---------+---------+---------+---------+---------+---------+---------+
        print *, '++++++++++++++++++++++++++++++++++++'
        print *, ' RELATIVE OPERATING CHARACTERISTICS'
        print *, '++++++++++++++++++++++++++++++++++++'
        hr    = .0
        falm  = .0
        nyy   =  0
        nyn   =  0
        indom =  0
 501  continue
        do nlat = lats, late
         ngl    = (nlat-1)*144
         wfac   = weight(nlat)*wdom(ndom)
         do nlon = lons, lone
          ng     = ngl+nlon
          do nb = 1, 10
           do np = 1, nep1  
            npm  = np-1
            if (fcp(ng,nb).eq.float(npm)) then
             if (anp(ng,nb).eq.1.) then
              nyy(np) = nyy(np)+1*wfac
             else
              nyn(np) = nyn(np)+1*wfac
             endif
            endif
           enddo
           if (ictl.eq.1.and.fcp(ng,nb).eq.-1.0) then
            if (anp(ng,nb).eq.1.) then
             nyy(1) = nyy(1)+1*wfac
            else
             nyn(1) = nyn(1)+1*wfac
            endif
           endif
          enddo
         enddo          ! nlon
        enddo           ! nlat
c
c     For Europe region there is a break in the longitude loop. 
c     Computations are done twice first for 0-40E and then for 0-20W  
c
        lons  = 137
        lone  = 144
        indom = indom + 1
        if (ndom.eq.5.and.indom.eq.1) goto  501
        lons = lonss(ndom)
        lone = lonee(ndom)
c--------+---------+---------+---------+---------+---------+---------+---------+
c     HIT RATE AND FALSE ALARM                
c--------+---------+---------+---------+---------+---------+---------+---------+
        if (nens.eq.20.or.nens.eq.14.or.nens.eq.10.or.ictl.eq.10) then
         print *, '++++++++++++++++++++++++++++++++++++'
         print *, '     HIT RATE and FALSE ALARM'
         print *, '++++++++++++++++++++++++++++++++++++'
         tnyy = .0
         tnyn = .0
         do np = 1, nep1  
          tnyy = tnyy+float(nyy(np))
          tnyn = tnyn+float(nyn(np))
         enddo
         do np = 1, nens 
          noh  = 0
          nof  = 0
          npm  = np+1
          do npt = npm, nep1  
	   noh = noh + nyy(npt)
	   nof = nof + nyn(npt)
	  enddo
	  if (tnyy.ne.0.0) then
	   hr(np) = float(noh)/tnyy
	  endif
	  if (tnyn.ne.0.0) then
	   falm(np) = float(nof)/tnyn
	  endif
	 enddo
	 write(51,1025)
	 write(51,1003) (hr(np),np=1,nep1)
	 write(51,1003) (falm(np),np=1,nep1)
         if ( ictl.eq.0 ) then
c
c    HIT RATE AND  FALSE ALARM FOR MRF ( H-RES ) FORECAST
c
	 call relop(ndom,weight,wdom,fmrf,anl,lats,late,lons,lone,
     .              hrc,falmc,nuc)
          write(51,1026)
	  write(51,1002) (hrc(nb),nb=1,11)
	  write(*, 1002) (hrc(nb),nb=1,11)
	  write(51,1002) (falmc(nb),nb=1,11)
c
c    HIT RATE AND  FALSE ALARM FOR  LOW  RESOLUTION  FORECAST
c
	  call relop(ndom,weight,wdom,ft62,anl,lats,late,lons,lone,
     .               hrc,falmc,nuc)
	  write(51,1027)
	  write(51,1002) (hrc(nb),nb=1,11)
	  write(51,1002) (falmc(nb),nb=1,11)
         endif
        endif
c--------+---------+---------+---------+---------+---------+---------+---------+
c     BIMODE CULCULATION - ZOLTAN TOTH (09/11/2000)
c--------+---------+---------+---------+---------+---------+---------+---------+
         
 998   continue
      rewind (nuc)
 999  continue
 1000 continue
c--------+---------+---------+---------+---------+---------+---------+---------+
c     WRITE OUT FORMAT
c--------+---------+---------+---------+---------+---------+---------+---------+
 1001 format(11f6.0)
 1002 format(11f6.3)
 1003 format(11f6.3)
 1004 format(21f6.1)
 1005 format(11f6.1)
 1021 format('SCORES  AT VALID TIME ',i10,' (ic : ',i10,')')
 1022 format(' RELIABILITY DIAGRAM  ')
 1023 format(' Forecast Probability ')
 1024 format(' BRIER SCORES  ')
 1025 format(' HIT RATES AND FALSE ALARMS OF ENSEMBLE FORECASTS')
 1026 format(' HIT RATES AND FALSE ALARMS FOR MRF ')
 1027 format(' HIT RATES AND FALSE ALARMS FOR LOW RESOLUTION MODEL') 
 1028 format(' RANKED PROBABILITY SCORES = ',2F6.3)
 1029 format(' RANKED PROBABILITY SKILL SCORE = ',E15.8)
 1031 format(' ---------- Northern Hemisphere --------------')
 1032 format(' ----------Southern Hemisphere --------------')
 1033 format(' ----------     Tropics   --------------')
 1034 format(' ---------- N. America   --------------')
 1035 format(' -------------Europe------------------')
 1036 format(' ----------     India   --------------')
      stop
      end
c--------+---------+---------+---------+---------+---------+---------+---------+
      SUBROUTINE wgt(weight,wdom)
      dimension alat(73),weight(73),wdom(6)
      dimension latss(6),latee(6),lonss(6),lonee(6)
      data latss/6,45,29,13,6,21/
      data latee/29,68,45,29,25,37/
      data lonss/1,1,1,89,1,17/
      data lonee/144,144,144,125,17,49/
c
c     d2R     = 3.1415926/180.
      d2R     = 3.142/180.
      alat(1) = 90.
      do i = 2, 73
       alat(i) = alat(i-1)-2.5
      enddo
      do i = 1, 73
       weight(i) = cos(alat(i)*d2r)
      enddo
      do ndom = 1, 6
       lats   = latss(ndom)
       late   = latee(ndom)
       nl     = 0
       sumwgt = 0.
       wdom(ndom) = 0.0
       do nlat = lats, late
        nl     = nl+1
        sumwgt = sumwgt+weight(nlat)
       enddo
       wdom(ndom) = float(nl)/sumwgt
      enddo
      return
      end
c--------+---------+---------+---------+---------+---------+---------+---------+
      SUBROUTINE relop(ndom,weight,wdom,fgrid,anl,lamin,lamax,
     .                 lomin,lomax,fhr,fal,nuc)
c     parameter (ngrid=10512,nuc=15)
      dimension fgrid(*),anl(*),clip(100)
      dimension nh(10),nf(10),nm(10),nn(10),fhr(11),fal(11)
      dimension weight(73),wdom(6)
c
c     print *, lamin,lamax,lomin,lomax,ndom
      klmi=  lomin
      klmx=  lomax
      nh  =  0
      nf  =  0
      nm  =  0
      nn  =  0
      fhr = .0
      fal = .0
      indom= 0
 200  continue
      nskip = (lamin-1)*144
      rewind (nuc)
      do nr = 1, nskip
       read (nuc)
      enddo
      do nlat = lamin, lamax
       ngl  = (nlat-1)*144
       wfac = weight(nlat)*wdom(ndom)
       do nlon = lomin, lomax
        ng  = ngl+nlon
        fcc = fgrid(ng)
        if (nlon.eq.lomin.and.lomin.ne.1) then
         do nr = 1, lomin-1
          read (nuc)
         enddo
        endif
        read (nuc) clip
c       if (nlat.eq.lamax.and.nlon.eq.lomax) then
c       print 205, clip(1),clip(11),clip(21),clip(31),clip(41)
c       endif
        if (fcc.le.clip(10)) then
         if (anl(ng).le.clip(10)) then
          nh(1) = nh(1)+1*wfac
         else
          nf(1) = nf(1)+1*wfac
         endif
        endif
        if (fcc.gt.clip(10)) then
         if (anl(ng).le.clip(10)) then
          nm(1) = nm(1)+1*wfac
         else
          nn(1) = nn(1)+1*wfac
         endif
        endif
c
        do nb = 2, 9
         ll = (nb-1)*10
         lh = nb*10
         if (fcc.gt.clip(ll).and.fcc.le.clip(lh)) then
          if (anl(ng).gt.clip(ll).and.anl(ng).le.clip(lh)) then
           nh(nb) = nh(nb)+1*wfac
          else
           nf(nb) = nf(nb)+1*wfac
          endif
         endif
         if (fcc.le.clip(ll).or.fcc.gt.clip(lh)) then
          if (anl(ng).gt.clip(ll).and.anl(ng).le.clip(lh)) then
           nm(nb) = nm(nb)+1*wfac
          else
           nn(nb) = nn(nb)+1*wfac
          endif
         endif
        enddo
c
         if (fcc.gt.clip(90)) then
          if (anl(ng).gt.clip(90)) then
           nh(10) = nh(10)+1*wfac
          else
           nf(10) = nf(10)+1*wfac
          endif
         endif
         if (fcc.le.clip(90)) then
          if (anl(ng).gt.clip(90)) then
           nm(10) = nm(10)+1*wfac
          else
           nn(10) = nn(10)+1*wfac
          endif
         endif
c
         if (nlon.eq.lomax) then
          if (lomax.eq.144) then
           goto 201
          else
           do nr = 1, 144-lomax
            read(nuc)
           enddo
           goto 201
          endif
         endif
 201  continue
       enddo                 ! nlon
      enddo                  ! nlat
c
c     For Europe region there is a break in the longitude loop. 
c     Computations are done twice first for 0-40E and then for 0-20W  
c
      lomin = 137
      lomax = 144
      indom = indom + 1
      if (ndom.eq.5.and.indom.eq.1) goto 200
      sfnh = 0.
      sfnf = 0.
      sfnm = 0.
      sfnn = 0.
      do nb = 1, 10
       fnh  = float(nh(nb))
       sfnh = sfnh+fnh
       fnf  = float(nf(nb))
       sfnf = sfnf+fnf
       fnm  = float(nm(nb))
       sfnm = sfnm+fnm
       fnn  = float(nn(nb))
       sfnn = sfnn+fnn
       if ((fnh+fnm).ne.0.0) fhr(nb) = fnh/(fnh+fnm)
       if ((fnf+fnn).ne.0.0) fal(nb) = fnf/(fnf+fnn)
      enddo
      fhr(11) = sfnh/(sfnh+sfnm)
      fal(11) = sfnf/(sfnf+sfnn)
      lomin = klmi
      lomax = klmx
c     print 202, fhr
c     print 202, fal
c202  format (11f6.3)
c205  format (5f10.2)
      return
      end
