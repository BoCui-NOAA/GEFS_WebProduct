      program VFPROB_opr
      parameter(ngrid=10512,nens=20)
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
c                 for Northern Hemisphere only
c     ----------------- Yuejian Zhu (11/01/00)
c
c     Modified to calculate the relative measure of ensemble predictability
c                 for Northern Hemisphere only
c     ----------------- Yuejian Zhu (05/30/06)
c
c     Modified to calculate the relative measure of ensemble predictability
c                 for global (20m)                 
c     ----------------- Yuejian Zhu (02/19/09)
c     
c     ngrid=10512 ; number of grid points in 2.5 X 2.5 resolution grid
c     nens=20     ; number of ensemble members
c     clip(100)   ; climatology
c     fmrf        ; control forecast field - do not used
c     ft62        ; low resolution forecast field - do not used
c     fcst        ; perturbed forecast fields
c     fcp(ngrid,10) ; forecast numbers at each point in ten climate bins
c    
c     PARAMETERS:
c
c     UNITS: - input
c           11: pgrb forecast file
c           21: index of pgrb forecast file
c           13: /global/cdas/500HGT.month1 ( climatology data )
c           14: /global/cdas/500HGT.month2 ( climatology data )
c           15: flip - internal use only
c           16: ~wx20yz/data/prob_nh_$MM.dat (probability statistics)
c           18: dis_avg.dat ( 30 day accumulated predictability distribution )
c     UNITS: - output
c           51: prob.ens (ensember mean and rel. probability output-grads form)
c           56: tmp.dat (probability statistic output of every 10%-blue numbers)
c           58: dis_avg_new.dat ( new 30 day accumulated distribution )
c           61: probex.ens(ensember mean and rel. probability output-production)
c
      dimension clip(100),clipm1(100),clipm2(100)
      dimension fmrf(ngrid),ft62(ngrid),favn(ngrid)
      dimension fcst(ngrid,nens),fprob(11),fprob1(21),iprob(21)
      dimension fcp(ngrid),fmn(ngrid),cbin(10),cbin1(10)
      dimension kdate(100) 
      dimension latss(6),latee(6),lonss(6),lonee(6)
      dimension alat(73),weight(73),wdom(6)
      dimension fcp21(ngrid,21),fcpn(ngrid,3),fcpm(ngrid)
      dimension fcp100(21,3),fcpg(21,3),fcpgn(21,3),tfcpg(3)
      dimension tcnt(3),fnh(73),fsh(73),ftr(73)

      character*49 file1,file2 
      character*80 cfilef(2),pfile
      character*28 asunitg,asuniti
      character*40 asunit1,asunit2
      character*3  cmon(12)
      character*32 cmsg(45)

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
      data file1/'/lfs/h2/emc/vpppg/noscrub/yan.luo
     ./cdas/500HGT.'/
      data file2/'/lfs/h2/emc/vpppg/noscrub/yan.luo
     ./cdas/500HGT.'/
      data pfile/'/lfs/h2/emc/vpppg/save/yan.luo
     ./eprob/scripts/prob_nh.dat'/
c      data file1/'/global/shared/stat/cdas/500HGT.'/
c      data file2/'/global/shared/stat/cdas/500HGT.'/
c      data pfile/'/global/save/wx20yz/eprob/scripts/prob_nh.dat'/
c--------+---------+---------+---------+---------+---------+---------+---------+
c     OPEN THE FORMAT AND UNFORMATTED DATA SET              
c--------+---------+---------+---------+---------+---------+---------+---------+
      call baopen(51,'prob.grads',iret)
      call baopen(61,'probex.ens',iret)
      open(unit=nuc,file='flip',form='unformatted',
     .     status='unknown',err=1001)
      open(unit=16,file=pfile,form='formatted',status='old',err=1002)
      open(unit=18,file='dis_avg20.dat',form='formatted',err=1003)
      open(unit=56,file='tmp.dat',form='formatted',err=1004)
      open(unit=58,file='dis_avg_new.dat',form='formatted',err=1005)
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

       print *, '+++++++++++++++++++++++++++++++++++++++++'
       print *, '        READ HISTORIC MONTHLY PROBABILITY'
       print *, '+++++++++++++++++++++++++++++++++++++++++'

       read (16,'(11f6.1)') (fprob(ii),ii=1,11)
       write(*, '(11f6.1)') (fprob(ii),ii=1,11)

       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '        READ FORECAST DATA'
       print *, '++++++++++++++++++++++++++++++++++++'
       call getgrb(fcst,nens,fmrf,ft62,favn,cfilef(1),cfilef(2),
     *             kp5,kp7,jdate,mdate,ifh,10)

       if (fcst(1,1).eq.-9999.99) goto 1000
c--------+---------+---------+---------+---------+---------+---------+---------+
c     READ CLIMATOLOGY(M1 & M2) PUT NEW CLIMATOLOGY OUT  
c--------+---------+---------+---------+---------+---------+---------+---------+
       print *, '++++++++++++++++++++++++++++++++++++'
       print *, '       READ CLIMATOLOGY DATA'
       print *, '++++++++++++++++++++++++++++++++++++'
       call nd2ymd(ndate,jyr,jmth,jday,jhour)
       m1 = jmth
       file1(47:49) = cmon(m1)
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
       file2(47:49) = cmon(m2)
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

c
c   to find out ensemble mean/medium
c
        fm = 0.0
        do n = 1, nens
         fm = fm + fcst(ng,n)/float(nens)
        enddo
        fmn(ng) = fm
c
c   based on ensemble mean, to find out the ensemble falling in the same bin
c    fcp contains the numbers of ensemble agree ensemble mean ( same bin )
c
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
         write(*,501) (fcst(ng,n),n=11,20)
         write(*,502) (clip(n),n=10,90,10)
        endif
        if (ng.eq.2500) then
         print *, 'fll=',fll,' flh=',flh
         write(*,501) (fcst(ng,n),n=1,10)
         write(*,501) (fcst(ng,n),n=11,20)
         write(*,502) (clip(n),n=10,90,10)
        endif

       enddo         ! ng
       
       rewind (nuc)

       print *, 'jdate=',jdate,' ifh=',ifh
       print *, 'fcp=',fcp(2000),' fmn=',fmn(2000)
       print *, 'fcp=',fcp(2500),' fmn=',fmn(2500)

c
c based on today's forecast distribution
c    modified by Yuejian Zhu (11/20/00)

c   20 ensemble number will create 21 possibility ( categories )
c      fcpgn is the region account average numbers for 21 categories 
c      for each leading time, sum. of these 21 numbers are equal to 1.0
c
 
       call  wgt(weight,wdom)

       fcp21 = 0.0
       do ng = 1, ngrid
        ii = fcp(ng)
        fcp21(ng,ii+1) = 1.0
       enddo

       fcpgn = 0.00   
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
          do icat = 1, 21
           if (fcp21(ng,icat).eq.1.0) then
            fcpgn(icat,ndom)=fcpgn(icat,ndom)+1.*wfac/tcnt(ndom)
           endif
          enddo
         enddo
        enddo
       enddo

c
c reading 30 day rotation ( acumulated ) probability distribution
c      replaced calculation distribution
c      modified by Yuejian Zhu (11/20/00)
      
       if (nfcst.eq.1) then
       read(18,'(13x,i10)') iymdh 
       endif
       fcpg = 0.0
       read(18,224) (fcpg(icat,1),icat=1,21)
       read(18,224) (fcpg(icat,2),icat=1,21)
       read(18,224) (fcpg(icat,3),icat=1,21)
       print *, "===== READ IN DISTRIBUTIONS ====="
       print *, "===== Updated to ",iymdh," ====="
       write(*,222) (fcpg(icat,1),icat=1,21,2)
       write(*,222) (fcpg(icat,2),icat=1,21,2)
       write(*,222) (fcpg(icat,3),icat=1,21,2)
       print *, "===== today's DISTRIBUTIONS ====="
       write(*,222) (fcpgn(icat,1),icat=1,21,2)
       write(*,222) (fcpgn(icat,2),icat=1,21,2)
       write(*,222) (fcpgn(icat,3),icat=1,21,2)

c
c calculate the new distribution by adding todays
c
       if (jdate.le.iymdh) then
        print *, "===== VERY IMPORTANT, VERY IMPORTANAT ====="
        print *, "===== NO UPDATE DISTRIBUTION !!!!!!!! ====="
        icnt = 0
        do icat = 1, 21
         fcpgn(icat,1) = fcpg(icat,1)
         fcpgn(icat,2) = fcpg(icat,2)
         fcpgn(icat,3) = fcpg(icat,3)
        enddo
       else
        icnt = 1
        do icat = 1, 21
         fcpgn(icat,1) = (fcpg(icat,1)*29.0 + fcpgn(icat,1))/30.0
         fcpgn(icat,2) = (fcpg(icat,2)*29.0 + fcpgn(icat,2))/30.0
         fcpgn(icat,3) = (fcpg(icat,3)*29.0 + fcpgn(icat,3))/30.0
        enddo
       endif

       print *, "===== NEWLY   DISTRIBUTIONS ====="
       write(*,222) (fcpgn(icat,1),icat=1,21,2)
       write(*,222) (fcpgn(icat,2),icat=1,21,2)
       write(*,222) (fcpgn(icat,3),icat=1,21,2)
       write(58,224) (fcpgn(icat,1),icat=1,21)
       write(58,224) (fcpgn(icat,2),icat=1,21)
       write(58,224) (fcpgn(icat,3),icat=1,21)

       tfcpg = 0.0
       do ndom = 1, 3
        do icat = 1, 21
         tfcpg(ndom) = tfcpg(ndom) + fcpg(icat,ndom)
        enddo
       enddo

c
c  fcp100 & fprob1 are a accumulated distribution account of forecasts
c    from 0 - 100 for each categories ( 0 - 10 )
c

       do ndom = 1, 3
        fcptmp = 0.0
        ipm1   = 1
        iprob(1)  = 0
        do icat = 1, 21
         fcptmp = fcptmp + fcpg(icat,ndom)/tfcpg(ndom)
         fcp100(icat,ndom) = fcptmp*100.0
         fprob1(icat)      = fcptmp*100.0
        enddo

c
c   for Northern Himsphere only
c     iprob is the 11 numbers ( plotting blue color on the maps )
c
c   e. g. input: fprob(11)
c   .5  8.8 17.9 25.7 36.4 48.7 68.4 76.4 85.4 90.7 97.4 (fcst probability-vrfy)
c                fcpg(11)
c   .029 .047 .077 .085 .100 .135 .116 .089 .081 .070 .177 (distribution)
c      accumulate fcpg*100.0 = fcp100(11)
c  2.9  7.6 15.3 23.8 33.8 47.3 58.9 67.8 75.9 82.9 100.0
c         10%  20%  30%  40%  50%  60%  70%  80%  90%
c    upto first 10% = (0.5*2.9 + 8.8*4.7 17.9*2.4)/10.0 = 8.577
c        8.577 is the first number on the relative measure map.
c
        if (ndom.eq.1) then
         do icat = 1, 20            ! for every 5% probability
          rul = 5.0*float(icat-1)
          rur = 5.0*float(icat) - 0.0001
          fprob0 = 0.0
          jcatl  = 1
          jcatr  = 21
          factl  = 0.0
          factr  = 0.0
          do jcat = 1, 21
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
          do jcat = 1, 21
           if (fcp100(jcat,ndom).ge.rur) then
            if (jcat.eq.jcatl) then
             factl = 5.0
            elseif (jcat.eq.(jcatl+1)) then
             factr = 5.0 - factl
            elseif (jcat.ge.(jcatl+2)) then
             factr = rur - fcp100(jcat-1,ndom)
            elseif (jcatl.eq.100) then
             factl = 5.0
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
           if (mod(jcat,2).eq.0) then
            fprobav = (fprob(jcat/2)+fprob(jcat/2+1))/2.0
           else
            fprobav = fprob(jcat/2+1)
           endif
c          fprob0 = fprob0 + fprob(jcat)*fact/5.0
           fprob0 = fprob0 + fprobav*fact/5.0
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

       write(*,223) (fcp100(icat,1),icat=1,21,2)
       write(*,223) (fcp100(icat,2),icat=1,21,2)
       write(*,223) (fcp100(icat,3),icat=1,21,2)
      
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

       write(56,'(11I6)') (iprob(ii),ii=1,21,2)
       write(*, '(11I6)') (iprob(ii),ii=1,21,2)


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
c reading addtional message
      do il=1,45
       read (18,'(a32)',end=901) cmsg(il)
      enddo
  901 continue

c adding message to distribution data
      if ( icnt.eq.1 ) then
       write (58,225) jdate
      else
       write (58,226) jdate
      endif
      do il = 1, 44
       write (58,'(a32)') cmsg(il)
      enddo

  222 format('fcpg=',11f6.4)
  223 format('fcpn=',11f6.1)
  224 format(21f6.4)
  225 format(2x,i10,'  has been     added ')
  226 format(2x,i10,'  has been not added ')
  501 format('fcst=',10f7.1)
  502 format('clim=',9f7.1)
      stop
 1000 print *, "There is no data read in, quit!!! "
      stop
 1001 print *, "There is a problem to open file unit=",nuc
      stop
 1002 print *, "There is a problem to open file unit=16"   
      stop
 1003 print *, "There is a problem to open file unit=18"   
      stop
 1004 print *, "There is a problem to open file unit=56"   
      stop
 1005 print *, "There is a problem to open file unit=58"    
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

