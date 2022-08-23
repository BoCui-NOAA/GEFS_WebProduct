      program VFPROB_opr
      parameter(ngrid=10512,nens=10)
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
c     Modified to calculate the relative measure of ensemble predictability
c     ----------------- Yuejian Zhu (11/01/00)
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
c    
c     PARAMETERS:
c      2. iprob  = single forecast control ( 1:MRF 2:T62 0:normal )
c      3. ictl   = 1:maximun calculation ( 1:max )                 
c                = 10:special calculation ( 10:for mrf or t62 )
c                  if ictl=10, nens must be 10.
c                = 0:normal
c
      dimension clip(100),clipm1(100),clipm2(100)
      dimension anl(ngrid),fmrf(ngrid),ft62(ngrid),favn(ngrid)
      dimension fcst(ngrid,nens),fprob(11),fprob1(11),iprob(11)
      dimension fcp(ngrid),fmn(ngrid),cbin(10),cbin1(10)
      dimension kdate(100) 
      dimension latss(6),latee(6),lonss(6),lonee(6)
      dimension alat(73),weight(73),wdom(6)
      dimension fcp11(ngrid,11),fcpn(ngrid,3),fcpm(ngrid)
      dimension fcp100(11,3),fcpg(11,3),tfcpg(3)
      dimension tcnt(3),fnh(73),fsh(73),ftr(73)

      character*29 file1,file2 
      character*80 cfilef(2),pfile
      character*28 asunitg,asuniti
      character*40 asunit1,asunit2
      character*3 cmon(12)

      namelist/files/cfilef
      namelist/kdata/kdate
      namelist/namin/nhours,ilv,kp5,kp6,kp7,icon,icoeff   
      data cmon/'JAN','FEB','MAR','APR','MAY','JUN',
     .          'JUL','AUG','SEP','OCT','NOV','DEC'/
      data latss/  1, 43, 27, 13,  6, 21/
      data latee/ 31, 73, 47, 29, 25, 37/
      data lonss/  1,  1,  1, 89,  1, 17/
      data lonee/144,144,144,125, 17, 49/
      data cbin1/ 5.0,15.0,25.0,35.0,45.0,55.0,65.0,75.0,85.0,95.0/
      data lupgi/21/,lupgb/11/
      data nuc1/13/,nuc2/14/,nuc/15/
      data file1/'/global/cdas/500HGT.'/
      data file2/'/global/cdas/500HGT.'/
      data pfile/'/nfsuser/g01/wx20yz/eprob/scripts/prob_nh.dat'/
c--------+---------+---------+---------+---------+---------+---------+---------+
c     OPEN THE FORMAT AND UNFORMATTED DATA SET              
c--------+---------+---------+---------+---------+---------+---------+---------+
      call baopen(51,'prob.ens',iret)
      call baopen(61,'probex.ens',iret)
      open(unit=nuc,file='flip',form='unformatted',
     .     status='unknown',err=1000)
      open(unit=16,file=pfile,form='formatted',status='old',err=1000)
      open(unit=56,file='tmp.dat',form='formatted')
      open(unit=58,file='dis_avg.dat',form='formatted')
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
c--------+---------+---------+---------+---------+---------+---------+---------+
c     READ THE ANALYSIS AND THE FORECAST FILES                
c--------+---------+---------+---------+---------+---------+---------+---------+
      nstep  =  nhours/12
      do nfcst = 1, nstep

       nfp      = nfcst + 2
       ndate    = kdate(nfp)
       jdate    = kdate(1)
       mdate    = kdate(2)
       ifh      = 12*nfcst

       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '        READ PAST 3-MONTH PROBABILITY'
       print *, '++++++++++++++++++++++++++++++++++++'

       read (16,'(11f6.1)') (fprob(ii),ii=1,11)
       write(*, '(11f6.1)') (fprob(ii),ii=1,11)

       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '        READ FORECAST DATA'
       print *, '++++++++++++++++++++++++++++++++++++'
       call getgrb(fcst,nens,fmrf,ft62,favn,cfilef(1),cfilef(2),
     *             kp5,kp7,jdate,mdate,ifh,10)
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
       rewind (nuc)  

       do ng = 1, ngrid

        read (nuc) clip

ccc to find out ensemble mean/medium
        fm = 0.0
        do n = 1, nens
         fm = fm + fcst(ng,n)/float(nens)
        enddo
        fmn(ng) = fm
ccc
        if (fm.le.clip(10)) then
         fll=0.0                   
         flh=clip(10)
         goto 101
        endif
        if (fm.gt.clip(90)) then
         fll=clip(90)              
         flh=999999.99
         goto 101
        endif
        do nb = 2, 9
         ll = (nb-1)*10
         lh = nb*10
         if (fm.gt.clip(ll).and.fm.le.clip(lh)) then
          fll=clip(ll)            
          flh=clip(lh)            
          goto 101
         endif
        enddo

  101  continue

	do n = 1, nens
	 fc = fcst(ng,n)
         if (fc.gt.fll.and.fc.le.flh) then
	  fcp(ng) = fcp(ng)+1.0
	 endif
        enddo
        if (ng.eq.2000) then
         print *, 'fll=',fll,' flh=',flh
         write(*,501) (fcst(ng,n),n=1,10)
         write(*,502) (clip(n),n=10,90,10)
        endif
        if (ng.eq.2500) then
         print *, 'fll=',fll,' flh=',flh
         write(*,501) (fcst(ng,n),n=1,10)
         write(*,502) (clip(n),n=10,90,10)
        endif

       enddo         ! ng
       
       rewind (nuc)

       print *, 'jdate=',jdate,' ifh=',ifh
       print *, 'fcp=',fcp(2000),' fmn=',fmn(2000)
       print *, 'fcp=',fcp(2500),' fmn=',fmn(2500)

       call  wgt(weight,wdom)

       fcp11 = 0.0
       do ng = 1, ngrid
        ii = fcp(ng)
        fcp11(ng,ii+1) = 1.0
       enddo

       fcpg = 0.00   
       tcnt(1) = 4464.0
       tcnt(2) = 4464.0
       tcnt(3) = 3024.0
       do ndom = 1, 3
        lats = latss(ndom)
        late = latee(ndom)
        lons = lonss(ndom)
        lone = lonee(ndom)

        do nlat = lats , late
         ngl    = (nlat-1)*144
         wfac   = weight(nlat)*wdom(ndom)
         do nlon = lons , lone
          ng     = ngl+nlon
          do icat = 1, 11
           if (fcp11(ng,icat).eq.1.0) then
            fcpg(icat,ndom)=fcpg(icat,ndom)+1.*wfac/tcnt(ndom)
           endif
          enddo
         enddo
        enddo
       enddo
      
c      read(58,224) (fcpg(icat,1),icat=1,11)
c      read(58,224) (fcpg(icat,2),icat=1,11)
c      read(58,224) (fcpg(icat,3),icat=1,11)
       write(*,222) (fcpg(icat,1),icat=1,11)
       write(*,222) (fcpg(icat,2),icat=1,11)
       write(*,222) (fcpg(icat,3),icat=1,11)
       
       tfcpg = 0.0
       do ndom = 1, 3
        do icat = 1, 11
         tfcpg(ndom) = tfcpg(ndom) + fcpg(icat,ndom)
        enddo
       enddo

       do ndom = 1, 3
        fcptmp = 0.0
        ipm1   = 1
        iprob(1)  = 0
        do icat = 1, 11
         fcptmp = fcptmp + fcpg(icat,ndom)/tfcpg(ndom)
         fcp100(icat,ndom) = fcptmp*100.0
         fprob1(icat)      = fcptmp*100.0
        enddo

        if (ndom.eq.1) then
         do icat = 1, 10            ! for every 10% probability
          rul = 10.0*float(icat-1)
          rur = 10.0*float(icat) - 0.0001
          fprob0 = 0.0
          jcatl  = 1
          jcatr  = 11
          factl  = 0.0
          factr  = 0.0
          do jcat = 1, 11
c--------+---------+----------+----------+---------+---------+---------+--
        if (fcp100(jcat,ndom).ge.rul.and.fcp100(jcat,ndom).lt.rur) then
            jcatl = jcat
            jcatr = jcat
            factl = fcp100(jcat,ndom) - rul
            goto 102
           else
            jcatl = 100
           endif
          enddo
 102      continue
          do jcat = 1, 11
           if (fcp100(jcat,ndom).ge.rur) then
            if (jcat.eq.jcatl) then
             factl = 10.0
            elseif (jcat.eq.(jcatl+1)) then
             factr = 10.0 - factl
            elseif (jcat.ge.(jcatl+2)) then
             factr = rur - fcp100(jcat-1,ndom)
            elseif (jcatl.eq.100) then
             factl = 10.0
             jcatl = jcat
            endif
            jcatr = jcat
            goto 103
           endif
          enddo
 103      continue
          do jcat = jcatl, jcatr
           if (jcat.eq.jcatl) then
            fact = factl
           elseif (jcat.eq.jcatr) then
            fact = factr
           else
            fact = fcpg(jcat,ndom)*100.00
           endif
c          print *, jcatl,jcatr,'icat=',icat,' jcat=',jcat,' fact=',fact
           fprob0 = fprob0 + fprob(jcat)*fact/10.0
          enddo
          iprob(icat+1) = fprob0
         enddo
        endif

c       if (ndom.eq.1) then
c        call stpint(fprob1,fprob,11,2,cbin1,cbin,10,aux,naux)
c        do icat = 1, 10
c         if (fprob1(1).gt.cbin1(icat)) then
c          iprob(icat+1) = fprob(1)
c         else
c          iprob(icat+1) = cbin(icat)
c         endif
c        enddo
c       endif

       enddo

       write(*,223) (fcp100(icat,1),icat=1,11)
       write(*,223) (fcp100(icat,2),icat=1,11)
       write(*,223) (fcp100(icat,3),icat=1,11)
      
       do ndom = 1, 3
        lats = latss(ndom)
        late = latee(ndom)
        lons = lonss(ndom)
        lone = lonee(ndom)
        do nlat = lats , late
         ngl    = (nlat-1)*144
         do nlon = lons , lone
          ng     = ngl+nlon
          ii = fcp(ng)
          fcpn(ng,ndom) = fcp100(ii+1,ndom)
         enddo
        enddo
       enddo

       do nlat = 1, 26            
        ngl    = (nlat-1)*144
        do nlon = 1, 144           
         ng     = ngl+nlon
         fcpm(ng) = fcpn(ng,1)
        enddo
       enddo
     
       fnh(27) = 0.90
       ftr(27) = 0.10
       fnh(28) = 0.70
       ftr(28) = 0.30
       fnh(29) = 0.50
       ftr(29) = 0.50
       fnh(30) = 0.30
       ftr(30) = 0.70
       fnh(31) = 0.10
       ftr(31) = 0.90

       do nlat = 27, 31           
        ngl    = (nlat-1)*144
        do nlon = 1, 144           
         ng     = ngl+nlon
         fcpm(ng) = fcpn(ng,1)*fnh(nlat) + fcpn(ng,3)*ftr(nlat)
        enddo
       enddo

       do nlat = 32, 42           
        ngl    = (nlat-1)*144
        do nlon = 1, 144           
         ng     = ngl+nlon
         fcpm(ng) = fcpn(ng,3)
        enddo
       enddo

       fsh(43) = 0.10
       ftr(43) = 0.90
       fsh(44) = 0.30
       ftr(44) = 0.70
       fsh(45) = 0.50
       ftr(45) = 0.50
       fsh(46) = 0.70
       ftr(46) = 0.30
       fsh(47) = 0.90
       ftr(47) = 0.10

       do nlat = 43, 47           
        ngl    = (nlat-1)*144
        do nlon = 1, 144           
         ng     = ngl+nlon
         fcpm(ng) = fcpn(ng,2)*fsh(nlat) + fcpn(ng,3)*ftr(nlat)
        enddo
       enddo

       do nlat = 48, 73           
        ngl    = (nlat-1)*144
        do nlon = 1, 144           
         ng     = ngl+nlon
         fcpm(ng) = fcpn(ng,2)
        enddo
       enddo

       print *, 'fcpm=',fcpm(2000),' fcpn=',fcpn(2000,1)
       print *, 'fcpm=',fcpm(2500),' fcpn=',fcpn(2500,1)

       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '       WRITE PAST 3-MONTH PROBABILITY'
       print *, '++++++++++++++++++++++++++++++++++++'

       write(56,'(11I6)') (iprob(ii),ii=1,11)
       write(*, '(11I6)') (iprob(ii),ii=1,11)


       call putgrb(fcpm,500,9,jdate,ifh)
       call putgrbex(fcpm,500,191,jdate,ifh)
       call putgrb(fmn,500,7,jdate,ifh)
       call putgrbex(fmn,500,7,jdate,ifh)

       close (nuc1)
       close (nuc2)
c--------+---------+---------+---------+---------+---------+---------+---------+
      enddo   
      call baclose(51,iret)
      call baclose(61,iret)
  222 format('fcpg=',11f6.3)
  223 format('fcpn=',11f6.1)
  224 format(11f6.3)
  501 format('fcst=',10f7.1)
  502 format('clim=',9f7.1)
 1000 continue
      stop
      end
c--------+---------+---------+---------+---------+---------+---------+---------+
      SUBROUTINE wgt(weight,wdom)
      dimension alat(73),weight(73),wdom(6)
      dimension latss(6),latee(6),lonss(6),lonee(6)
      data latss/1,43,31,13,6,21/
      data latee/31,73,47,29,25,37/
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

