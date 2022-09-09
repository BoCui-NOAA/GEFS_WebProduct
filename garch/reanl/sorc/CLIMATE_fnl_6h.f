c
c  Main program    CLIMATE_fnl_6h
c  Prgmmr: Yuejian Zhu           Org: np23          Date: 2005-09-29
c
c This is main program to get climatological data from 40-year re-analysis
c
c   subroutine                                                    
c              IADDATE---> to add forecast hours to initial data    
c              GETGRB ---> to get GRIB format data                  
c              GRANGE ---> to calculate max. and min value of array
c
c   parameters:
c      ix    -- x-dimensional
c      iy    -- y-dimensional
c
c   Fortran 77 on IBMSP 
c
C--------+---------+---------+---------+---------+----------+---------+--
      program CLIMATE_fnl_6h
      parameter (ix=144,iy=73,mlen=1240)
      dimension fanl(ix,iy,mlen),f1(10512),f2(10512),f3(10512)
      dimension lmon(12),ldat(12)
      double precision ccc(mlen),prob,fmon(3),opara(3),davg
      dimension aaa(mlen),bbb(101),ddd(40)
      dimension x1(20),y1(20),z1(20)
      dimension kpds(200),kgds(200)
      dimension jpds(200),jgds(200)
      logical*1 lb(10512)
      character*80 cfilea(40)
      character*80 cfileom,cfileos,cfileok
      namelist /namin/ ifd,itp,ilv,isthr,fc2,fc3,cfilea
      data cfileom/'pgrbmean'/
      data cfileos/'pgrbstdv'/
      data cfileok/'pgrbskew'/

      call baopen (81,cfileom(1:8),ires)
      call baopen (82,cfileos(1:8),ires)
      call baopen (83,cfileok(1:8),ires)

      read (5,namin,end=1000)
      write(6,namin)

ccc   t2m, tmax, tmin, u10m, v10m are all for end-time
      ifhr=24-isthr
      if (ifhr.eq.24) then
       ifhr=0
      endif

1000  continue

      lmon(1) = 720
      lmon(2) = 648
      lmon(3) = 720
      lmon(4) = 696
      lmon(5) = 720
      lmon(6) = 696
      lmon(7) = 720
      lmon(8) = 720
      lmon(9) = 696
      lmon(10) = 720
      lmon(11) = 696
      lmon(12) = 720

      ldat(1) = 1240
      ldat(2) = 1130
      ldat(3) = 1240
      ldat(4) = 1200
      ldat(5) = 1240
      ldat(6) = 1200
      ldat(7) = 1240
      ldat(8) = 1240
      ldat(9) = 1200
      ldat(10) = 1240
      ldat(11) = 1200
      ldat(12) = 1240

c ----
c     convert initial time + forecast time to verified time
c ----
      kcnt=0
      do imo = 1, 12
       kcnt=kcnt+1
       icnt=0
       jcnt=1
       do iyr = 1959, 1998
        if (mod(iyr,4).eq.0) then
         lmon(2) = 672
        else
         lmon(2) = 648
        endif
        idate=iyr*1000000 + imo*10000 + 100 + isthr
        icnt = icnt + 1
        do nfhrs = 0, lmon(imo), 24
         call iaddate(idate,nfhrs,jdate)
c        print *, 'JCNT=',jcnt,jdate,ifhr,ifd,itp,ilv,' F=',cfilea(icnt)(1:14)
         call getgrb(fanl(1,1,jcnt),ix,iy,cfilea(icnt),ifd,itp,ilv,
     *               jdate,ifhr,10+icnt,kpds,kgds)
         if (jcnt.eq.1) then
          jpds=kpds
          jgds=kgds
         endif
         if (fanl(50,25,jcnt).ge.-9990.00) then
          jcnt=jcnt+1
         else
          jcnt=jcnt
         endif

c        call fitr30(fanl(1,1,jcnt))
         call fitr20(fanl(1,1,jcnt))
        enddo
       enddo

       print *, 'jcnt=',jcnt-1,' ldat=',ldat(imo),' same?'
       ldat(imo) = jcnt-1

       lxy=0
       do jj = 1, iy
        do ii = 1, ix
         lxy = lxy + 1
         do len = 1, ldat(imo)
          aaa(len) = fanl(ii,jj,len)
         enddo
c        if (ii.eq.50.and.jj.eq.25) then
c         print *, 'aaa=',(aaa(len),len=1,ldat(imo))
c        endif

ccc   to calculate center mean instead of sample mean
ccc      it will not be used because missing data
         lmn=ldat(imo)/40
         lhmon=lmn/2 
         lcnt = 0
         do len = lhmon, ldat(imo), lmn
          lcnt = lcnt + 1
          ddd(lcnt) = fanl(ii,jj,len-2)*0.12 +
     *                fanl(ii,jj,len-1)*0.22 +
     *                fanl(ii,jj,len-0)*0.32 +
     *                fanl(ii,jj,len+1)*0.22 +
     *                fanl(ii,jj,len+2)*0.12
         enddo
         call sort(aaa,ldat(imo))
         do len = 1, ldat(imo)
          ccc(len) = aaa(len)       
         enddo
         
         bbb(1) = aaa(1)
         bbb(101) = aaa(ldat(imo))

         dst = bbb(1) 
         dint= (bbb(101)-bbb(1))/20.

         if (ii.eq.50.and.jj.eq.25) then
          print *, 'month=',imo,' int= 1 value=',bbb(1)
ccc       for plotting
          do llen = 1, 20
           x1(llen) = dst + dint*(llen-1)
           anum = x1(llen) + dint/2.0
           do len = 1, ldat(imo)
            if (aaa(len).le.anum) then
             y1(llen) = len
            endif
            if (llen.ge.2) then
             z1(llen) = (y1(llen) - y1(llen-1))/float(ldat(imo))
            else
             z1(llen) = y1(llen)/float(ldat(imo))
            endif
           enddo
          enddo
          open(unit=99,file='grads_tmp.dat',form='UNFORMATTED')
          write (99) (z1(llen),llen=1,20)
         endif

         do kk = 1, 99
          iint = 1+kk*ldat(imo)/100.0
          bbb(kk+1) = aaa(iint)
          if (ii.eq.50.and.jj.eq.25) then
c          if (kk.gt.1.and.mod(kk-1,10).eq.0) then
           if (kk.gt.1.and.mod(kk-1,1).eq.0) then
c          print *, 'month=',imo,' int=',kk/10+1,' value=',bbb(kk+1)
           print *, 'month=',imo,' int=',kk+1,' value=',bbb(kk+1)
           endif
          endif
         enddo

         if (ii.eq.50.and.jj.eq.25) then
          print *, 'month=',imo,' int= 101 value=',bbb(101)
         endif

         write (60+kcnt) (bbb(kk),kk=1,101)
 
         opara = 0.0D0
         call samlmr(ccc,ldat(imo),fmon,3,-0.35D0,0.0D0)
c        call samlmu(ccc,ldat(imo),fmon,5)
         call pelgev(fmon,opara)
c        call pelpe3(fmon,opara)
         if (ii.eq.50.and.jj.eq.25) then
          do kk = 1001, 1, -1
           prob = (kk-1)/1000.0 
           if (kk.eq.1001) prob=0.999999
           if (kk.eq.1)  prob=0.0
           aaa(1002-kk)=quagev(1.0-prob,opara)
c          aaa(1002-kk)=quape3(1.0-prob,opara)
c          fvalue=quagev(1.0-prob,opara)
          enddo
ccc       for plotting
          do llen = 1, 20
           x1(llen) = dst + dint*(llen-1)
           anum = x1(llen) + dint/2.0
           do len = 1, 1001      
            if (aaa(len).le.anum) then
             y1(llen) = len
            endif
            if (llen.ge.2) then
             z1(llen) = (y1(llen) - y1(llen-1))/1001.
            else
             z1(llen) = y1(llen)/1001.
            endif
           enddo
          enddo
          open(unit=99,file='grads_tmp.dat',form='UNFORMATTED')
          write (99) (z1(llen),llen=1,20)

c         do kk = 11, 1, -1
c          prob = (kk-1)/10.0 
c          if (kk.eq.11) prob=0.999999
c          if (kk.eq.1)  prob=0.0
c          fvalue=quagev(1.0-prob,opara)
c          print *, 'lm ',12-kk,' value=',fvalue
c         enddo
         endif

         davg=0.0
         do kk = 1, 40
          davg = davg + ddd(kk)/40.0
         enddo
c        f1(lxy) = davg
         f1(lxy) = fmon(1)
         f2(lxy) = fmon(2)
         f3(lxy) = fmon(3)
         if (ii.eq.50.and.jj.eq.25) then
          fmon(1)=davg
          call pelgev(fmon,opara)
c         call pelpe3(fmon,opara)
c         do kk = 11, 1, -1
c          prob = (kk-1)/10.0 
c          if (kk.eq.11) prob=0.999999
c          if (kk.eq.1)  prob=0.0
c          fvalue=quagev(1.0-prob,opara)
c          print *, 'lm ',12-kk,' value=',fvalue
c         enddo
          do kk = 1001, 1, -1
           prob = (kk-1)/1000.0
           if (kk.eq.1001) prob=0.999999
           if (kk.eq.1)  prob=0.0
           aaa(1002-kk)=quagev(1.0-prob,opara)
c          aaa(1002-kk)=quape3(1.0-prob,opara)
c          fvalue=quagev(1.0-prob,opara)
          enddo
ccc       for plotting
          do llen = 1, 20
           x1(llen) = dst + dint*(llen-1)
           anum = x1(llen) + dint/2.0
           do len = 1, 1001
            if (aaa(len).le.anum) then
             y1(llen) = len
            endif
            if (llen.ge.2) then
             z1(llen) = (y1(llen) - y1(llen-1))/1001.
            else
             z1(llen) = y1(llen)/1001.
            endif
           enddo
          enddo
          open(unit=99,file='grads_tmp.dat',form='UNFORMATTED')
          write (99) (z1(llen),llen=1,20)

         endif

        enddo
       enddo

cccc   write out GRIB data
       kpds=jpds
       kgds=jgds

c      kpds(8)=59
c      kpds(9)=imo
c      kpds(10)=1 
c      kpds(11)=0 
c      kpds(12)=0 
c      kpds(13)=3
c      kpds(14)=1           
c      kpds(15)=1        
c      kpds(16)=132      
c      kpds(17)=0       
       call putgb(81,10512,kpds,kgds,lb,f1,iret)
c      kpds(16)=136      
c      kpds(17)=0       
       call putgb(82,10512,kpds,kgds,lb,f2*fc2,iret)
c      kpds(16)=137     
c      kpds(17)=0       
       call putgb(83,10512,kpds,kgds,lb,f3*fc3,iret)

      enddo

      stop
      end
