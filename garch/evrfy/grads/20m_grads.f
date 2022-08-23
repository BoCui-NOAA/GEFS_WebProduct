      PROGRAM AVG 
      parameter(icyc=31,ih=3,iw=4,ig=14,idayss=400)
      dimension acr(ih,iw,ig,icyc,idayss)
      dimension rms(ih,iw,ig,icyc,idayss)
      dimension fit(ih,24,14,icyc,idayss)
      dimension pcor(3,20,icyc,idayss),prms(3,20,icyc,idayss)
      dimension pcormax(3,icyc,idayss)
      dimension pcormin(3,icyc,idayss)
      dimension pcormrf(3,icyc,idayss)
      dimension pcorctl(3,icyc,idayss)
      dimension ifile(idayss),level(2)
      character*5  chem(3),clab(16),flab(14)
      character*80 cfile(idayss),ofile,ofilm
      character*28 asuniti,asunitj,asunitk
      namelist/namin/ cfile,ifile,idays,ifdays,ofile,ofilm,ilevel
      data chem /'N Hem','S Hem','Trop.'/
      data clab/' GFS ',' CTL ','10mpa','14mpa','20mpa','22mpa','10map',
     &          '14map','20map','22map','10Med','14Med','20Med','22Med',
     &          '20pac','20rms'/
      data flab/'T10  ','T+1  ','T14  ','T14+1','T20  ','T20+1','T22  ',
     &          'T22+1','R10  ','R14  ','R20  ','R22  ','Rs5  ','Sg4  '/
      data iunit/11/,junit/12/,kunit/51/
      data level/1000,500/
    
      read  (5,namin,end=1020)
 1020 continue
      write (6,namin)

ccc
ccc   Read 1000 mb and 500 mb N + S Hem + trp. AC and RMS
ccc 

c     do il = ilevel, ilevel             ! 1000, 500 mb 
      do il = 1, 1                                            
      
      acr  = -999.99
      rms  = -999.99
      pcor = -999.99
      prms = -999.99
      fit  = -999.99
      aaa  = -10.0   
      pcormax=-999.99
      pcormin=-999.99

      do ii = 1, idays        ! totally files read

       if (ifile(ii).eq.1) then

        print *, ' open file ',cfile(ii)

        open(unit=iunit,file=cfile(ii),form='FORMATTED',status='OLD')

c       if (il.eq.2) then
         do jj = 1,3844
          read (iunit,200)
         enddo
c       endif

        do jj = 1, icyc          ! 31 cycles

         do i = 1, 3
          read (iunit,200)                              
          do k = 1, 14
           read (iunit,201) (acr(i,j,k,jj,ii),j=1,4), 
     *                      (rms(i,j,k,jj,ii),j=1,4)
           write(*,    201) (acr(i,j,k,jj,ii),j=1,4), 
     *                      (rms(i,j,k,jj,ii),j=1,4)
          enddo
          read (iunit,221) (pcor(i,j,jj,ii),j=1,20)
          read (iunit,222) (prms(i,j,jj,ii),j=1,20)
         enddo
   
         read (iunit,200)                        
         do i = 1, 3
          read (iunit,215)   
          read (iunit,212)  (fit(i,j,1,jj,ii),j=1,11)
          read (iunit,212)  (fit(i,j,2,jj,ii),j=1,11)

          read (iunit,212)  (fit(i,j,3,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,3,jj,ii),j=13,15)
          read (iunit,212)  (fit(i,j,4,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,4,jj,ii),j=13,15)

          read (iunit,212)  (fit(i,j,5,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,5,jj,ii),j=13,21)
          read (iunit,212)  (fit(i,j,6,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,6,jj,ii),j=13,21)

          read (iunit,212)  (fit(i,j,7,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,7,jj,ii),j=13,23)
          read (iunit,212)  (fit(i,j,8,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,8,jj,ii),j=13,23)

          read (iunit,212)  (fit(i,j,9,jj,ii),j=1,10)
          read (iunit,212)  (fit(i,j,10,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,10,jj,ii),j=13,14)
          read (iunit,212)  (fit(i,j,11,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,11,jj,ii),j=13,21)
          read (iunit,212)  (fit(i,j,12,jj,ii),j=1,12)
          read (iunit,212)  (fit(i,j,12,jj,ii),j=13,22)

          read (iunit,212)  (fit(i,j,13,jj,ii),j=1,5)
          read (iunit,212)  (fit(i,j,14,jj,ii),j=1,4)
         enddo
 200  format(1x)                              
 201  format(5x,4(f8.4),4(f9.2))
 212  format(5x,12(f6.2))
 215  format(80x)                              
 221  format(5x,1x,20(f5.3))
 222  format(5x,1x,20(f5.1))
c 
         upamt=950.00              
         do i = 1, 3    
          do j = 1, 4  
           do k = 1, ig
            if (acr(i,j,k,jj,ii).eq.9.9999
     *       .or.rms(i,j,k,jj,ii).gt.upamt) then
             print *, 'reg=',i,' wav=',j,' catg=',k, ' value=9.999'
             acr(i,j,k,jj,ii) = -999.99
             rms(i,j,k,jj,ii) = -999.99
            endif
           enddo
          enddo
         enddo
 
        enddo     ! for jj loop
        close(iunit)
       else
        print *, ' we will skip ii=',ii
       endif
    
      enddo       ! for ii loop

      enddo

CCC
CCC   write out to grads format
CCC
      open(unit=51,file=ofile,form='UNFORMATTED',err=1030)
      open(unit=52,file=ofilm,form='UNFORMATTED',err=1030)
      do ii = 1, idays
       do i = 1, ih    
        do k = 1, ig -1
         write (51) ((acr(i,j,k,jj,ii),jj=1,icyc),j=1,iw)
         write(*,'(4f7.3)') ((acr(i,j,k,jj,ii),jj=11,11),j=1,iw)
        enddo
       enddo
       do k = 1, ig
        write (52) ((acr(i,4,k,jj,ii),jj=1,icyc),i=1,ih)
       enddo
       do j = 1, 20
        write (52) ((pcor(i,j,jj,ii),jj=1,icyc),i=1,ih)
       enddo
       do jj=1,icyc
        do i=1, ih
         pcormax(i,jj,ii)=max(pcor(i,1,jj,ii),pcor(i,2,jj,ii),
     *                        pcor(i,3,jj,ii),pcor(i,4,jj,ii),
     *                        pcor(i,5,jj,ii),pcor(i,6,jj,ii),
     *                        pcor(i,7,jj,ii),pcor(i,8,jj,ii),
     *                        pcor(i,9,jj,ii),pcor(i,10,jj,ii),
     *                        pcor(i,11,jj,ii),pcor(i,12,jj,ii),
     *                        pcor(i,13,jj,ii),pcor(i,14,jj,ii),
     *                        pcor(i,15,jj,ii),pcor(i,16,jj,ii),
     *                        pcor(i,17,jj,ii),pcor(i,18,jj,ii),
     *                        pcor(i,19,jj,ii),pcor(i,20,jj,ii))

         pcormin(i,jj,ii)=min(pcor(i,1,jj,ii),pcor(i,2,jj,ii),
     *                        pcor(i,3,jj,ii),pcor(i,4,jj,ii),
     *                        pcor(i,5,jj,ii),pcor(i,6,jj,ii),
     *                        pcor(i,7,jj,ii),pcor(i,8,jj,ii),
     *                        pcor(i,9,jj,ii),pcor(i,10,jj,ii),
     *                        pcor(i,11,jj,ii),pcor(i,12,jj,ii),
     *                        pcor(i,13,jj,ii),pcor(i,14,jj,ii),
     *                        pcor(i,15,jj,ii),pcor(i,16,jj,ii),
     *                        pcor(i,17,jj,ii),pcor(i,18,jj,ii),
     *                        pcor(i,19,jj,ii),pcor(i,20,jj,ii))

         icnt=0
         do j = 1, 20
          if (acr(i,4,1,jj,ii).gt.pcor(i,j,jj,ii)) then
           icnt = icnt + 1
          endif
         enddo
         pcormrf(i,jj,ii)=float(icnt)/20.0
         icnt=0
         do j = 1, 20
          if (acr(i,4,2,jj,ii).gt.pcor(i,j,jj,ii)) then
           icnt = icnt + 1
          endif
         enddo
         pcorctl(i,jj,ii)=float(icnt)/20.0
        enddo
       enddo
        write (52) ((pcormax(i,jj,ii),jj=1,icyc),i=1,ih)
        write (52) ((pcormin(i,jj,ii),jj=1,icyc),i=1,ih)
        write (52) ((pcormrf(i,jj,ii),jj=1,icyc),i=1,ih)
        write (52) ((pcorctl(i,jj,ii),jj=1,icyc),i=1,ih)
       do i = 1, ih    
        do k = 1, ig-1
         write (51) ((rms(i,j,k,jj,ii),jj=1,icyc),j=1,iw)
         write(*,'(4f7.1)') ((rms(i,j,k,jj,ii),jj=11,11),j=1,iw)
        enddo
       enddo
       do k = 1, ig
        write (52) ((rms(i,4,k,jj,ii),jj=1,icyc),i=1,ih)
       enddo
       do j = 1, 20
        write (52) ((prms(i,j,jj,ii),jj=1,icyc),i=1,ih)
       enddo
       do i = 1, ih    
        do j = 1, 4
         do jj = 1, icyc
          if (fit(i,j,12,jj,ii).eq.0.0) then
           fit(i,j,12,jj,ii) = -999.99
          endif
          if (fit(i,j,14,jj,ii).eq.0.0) then
           fit(i,j,14,jj,ii) = -999.99
          endif
         enddo
        enddo
c      ensemble spread
        write (51) ((fit(i,j,14,jj,ii),jj=1,icyc),j=1,4)
        write(*,'(4f7.1)') ((fit(i,j,12,jj,ii),jj=11,11),j=1,4)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,1,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,1,jj,ii),jj=1,icyc),j=10,11)
        write(*,'(4f7.1)') ((fit(i,j,1,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,1,jj,ii),jj=11,11),j=10,11)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,2,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,2,jj,ii),jj=1,icyc),j=10,11)
        write(*,'(4f7.1)') ((fit(i,j,2,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,2,jj,ii),jj=11,11),j=10,11)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,3,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,3,jj,ii),jj=1,icyc),j=20,21)
        write(*,'(4f7.1)') ((fit(i,j,3,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,3,jj,ii),jj=11,11),j=20,21)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,4,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,4,jj,ii),jj=1,icyc),j=20,21)
        write(*,'(4f7.1)') ((fit(i,j,4,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,4,jj,ii),jj=11,11),j=20,21)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,5,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,5,jj,ii),jj=1,icyc),j=21,22)
        write(*,'(4f7.1)') ((fit(i,j,5,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,5,jj,ii),jj=11,11),j=21,22)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,6,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,6,jj,ii),jj=1,icyc),j=21,22)
        write(*,'(4f7.1)') ((fit(i,j,6,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,6,jj,ii),jj=11,11),j=21,22)
       enddo
      enddo

      STOP
 1030 print *, "There is a problem to open unit=51"

      STOP
      END
