      PROGRAM AVG 
      parameter(icyc=31,ih=3,iw=4,ig=13,idayss=100)
      dimension acr(ih,iw,ig,icyc,idayss)
      dimension rms(ih,iw,ig,icyc,idayss)
      dimension fit(ih,24,9,icyc,idayss)
      dimension pcor(3,20,icyc,idayss),prms(3,20,icyc,idayss)
      dimension ifile(200),level(2)
      character*5  chem(3),clab(13),flab(12)
      character*80 cfile(200),ofile
      character*28 asuniti,asunitj,asunitk
      namelist/namin/ cfile,ifile,idays,ifdays,ofile
      data chem /'N Hem','S Hem','Trop.'/
      data clab /'MRF  ','CTL  ','00Zpa','AVN  ','12Zpa','23tsa',
     .           '00Zap','12Zap','20ems','23tms','23Med','00Med',
     .           '12Med'/
      data flab /'T23  ','T+1  ','T1000','T10+1','T1012','T10+1',
     .           'T20  ','R23  ','Rs5  ','R1000','R1012','Sg4  '/
      data iunit/11/,junit/12/,kunit/51/
      data level/1000,500/
    
      read  (5,namin,end=1020)
 1020 continue
      write (6,namin)

ccc
ccc   Read 1000 mb and 500 mb N + S Hem + trp. AC and RMS
ccc 

      do il = 1, 1             ! 1000, 500 mb 
      
      acr  = -999.99
      rms  = -999.99
      pcor = -999.99
      prms = -999.99
      fit  = -999.99
      aaa  = -10.0   

      do ii = 1, idays        ! totally files read

       if (ifile(ii).eq.1) then

        print *, ' open file ',cfile(ii)

        open(unit=iunit,file=cfile(ii),form='FORMATTED',status='OLD')

c       do jj = 1, icyc          ! 31cycles
        do jj = 1, 21            ! 21cycles
         jjj=jj+1
         if (jjj.gt.icyc) then
          jjj = 1    
         endif

         do i = 1, 3
          read (iunit,200)                              
          do k = 1, 11
           read (iunit,201) (acr(i,j,k,jj,ii),j=1,4), 
     *                      (rms(i,j,k,jj,ii),j=1,4)
           write(*,    201) (acr(i,j,k,jj,ii),j=1,4), 
     *                      (rms(i,j,k,jj,ii),j=1,4)
          enddo
          read (iunit,221) (pcor(i,j,jj,ii),j=1,10)
          read (iunit,221) (pcor(i,j,jj,ii),j=11,17)
          read (iunit,222) (prms(i,j,jj,ii),j=1,10)
          read (iunit,222) (prms(i,j,jj,ii),j=11,17)
         enddo
   
         read (iunit,200)                        
         do i = 1, 3
          read (iunit,215)   
          read (iunit,212)  (fit(i,j,1,jj,ii),j=1,9)
          read (iunit,212)  (fit(i,j,1,jj,ii),j=10,18)
          read (iunit,212)  (fit(i,j,2,jj,ii),j=1,9)
          read (iunit,212)  (fit(i,j,2,jj,ii),j=11,18)
          read (iunit,212)  (fit(i,j,3,jj,ii),j=1,11)
          read (iunit,212)  (fit(i,j,4,jj,ii),j=1,11)
          read (iunit,212)  (fit(i,j,5,jj,ii),j=1,9)
          read (iunit,212)  (fit(i,j,5,jj,ii),j=10,17)
          read (iunit,212)  (fit(i,j,6,jj,ii),j=1,9)
          read (iunit,212)  (fit(i,j,6,jj,ii),j=10,17)
          read (iunit,212)  (fit(i,j,7,jj,ii),j=1,9)
          read (iunit,212)  (fit(i,j,7,jj,ii),j=10,17)
          read (iunit,212)  (fit(i,j,8,jj,ii),j=1,5)
          read (iunit,212)  (fit(i,j,9,jj,ii),j=1,4)
         enddo
 200  format(1x)                              
 201  format(5x,4(f8.4),4(f9.2))
 212  format(5x,12(f6.2))
 215  format(80x)                              
 221  format(5x,1x,10(f7.4))
 222  format(5x,10(f7.2))
c 
         upamt=250.00              
         do i = 1, 3    
          do j = 1, 4  
           do k = 1, 11
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
      do ii = 1, idays
       do i = 1, ih    
        do k = 1, ig
         write (51) ((acr(i,j,k,jj,ii),jj=1,icyc),j=1,iw)
         write(*,'(4f7.3)') ((acr(i,j,k,jj,ii),jj=11,11),j=1,iw)
        enddo
       enddo
       do i = 1, ih    
        do k = 1, ig
         write (51) ((rms(i,j,k,jj,ii),jj=1,icyc),j=1,iw)
         write(*,'(4f7.1)') ((rms(i,j,k,jj,ii),jj=11,11),j=1,iw)
        enddo
       enddo
       do i = 1, ih    
        do j = 1, 4
         do jj = 1, icyc
          if (fit(i,j,9,jj,ii).eq.0.0) then
           fit(i,j,9,jj,ii) = -999.99
          endif
         enddo
        enddo
        write (51) ((fit(i,j,9,jj,ii),jj=1,icyc),j=1,4)
        write(*,'(4f7.1)') ((fit(i,j,9,jj,ii),jj=11,11),j=1,4)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,1,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,1,jj,ii),jj=1,icyc),j=17,18)
        write(*,'(4f7.1)') ((fit(i,j,1,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,1,jj,ii),jj=11,11),j=17,18)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,2,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,2,jj,ii),jj=1,icyc),j=17,18)
        write(*,'(4f7.1)') ((fit(i,j,2,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,2,jj,ii),jj=11,11),j=17,18)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,3,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,3,jj,ii),jj=1,icyc),j=10,11)
        write(*,'(4f7.1)') ((fit(i,j,3,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,3,jj,ii),jj=11,11),j=10,11)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,4,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,4,jj,ii),jj=1,icyc),j=10,11)
        write(*,'(4f7.1)') ((fit(i,j,4,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,4,jj,ii),jj=11,11),j=10,11)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,5,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,5,jj,ii),jj=1,icyc),j=16,17)
        write(*,'(4f7.1)') ((fit(i,j,5,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,5,jj,ii),jj=11,11),j=16,17)
       enddo
       do i = 1, ih    
        write (51) ((fit(i,j,6,jj,ii),jj=1,icyc),j=1,2),
     *             ((fit(i,j,6,jj,ii),jj=1,icyc),j=16,17)
        write(*,'(4f7.1)') ((fit(i,j,6,jj,ii),jj=11,11),j=1,2),
     *             ((fit(i,j,6,jj,ii),jj=11,11),j=16,17)
       enddo
      enddo

      STOP
 1030 print *, "There is a problem to open unit=51"

      STOP
      END
