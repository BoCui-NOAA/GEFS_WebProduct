      PROGRAM AVG 
      parameter(icyc=31)
      dimension cor(3,4,11,100,icyc,2)
      dimension acor(3,4,11,icyc),icor(3,4,11,icyc)
      dimension rms(3,4,11,100,icyc,2)
      dimension arms(3,4,11,icyc),irms(3,4,11,icyc)
      dimension pcor(3,20),prms(3,20)
      dimension apcor(3,20,icyc),aprms(3,20,icyc)
      dimension ipcor(3,20,icyc)
      dimension fit(3,24,9),afit(3,24,9,icyc)
      dimension ifile(200),level(2)
      character*5  chem(3),clab(11),flab(8)
      character*80 cfile(200),ofile
      character*28 asuniti,asunitj,asunitk
      namelist/namin/ cfile,ifile,idays,ofile
      data chem /'N Hem','S Hem','Trop.'/
      data clab /'MRF  ','CTL  ','00Zpa','AVN  ','12Zpa','23tsa',
     .           '00Zap','12Zap','20ems','23tms','Meds '/
      data flab /'T23  ','T+1  ','T1000','T1012',
     .           'T20  ','R23  ','Rs5  ','Sg4  '/
      data iunit/11/,junit/12/,kunit/51/
      data level/1000,500/
    
      read  (5,namin,end=1020)
 1020 continue
      write (6,namin)

      open(unit=kunit,file=ofile,form='FORMATTED',status='NEW')

ccc
ccc   Read 1000 mb and 500 mb N + S Hem + trp. AC and RMS
ccc 
      
      acor = 0.0
      arms = 0.0
      apcor= 0.0
      aprms= 0.0
      afit = 0.0
      icor = 0
      irms = 0
      ipcor= 0

      do il = 1, 2             ! 1000, 500 mb 

      do ii = 1, idays        ! totally files read

       if (ifile(ii).eq.1) then

        print *, ' open file ',cfile(ii)

        open(unit=iunit,file=cfile(ii),form='FORMATTED',status='OLD')

        if (il.eq.2) then
         do jj = 1,2728
          read (iunit,200)
         enddo
        endif

        do jj = 1, icyc          ! 7 cycles
 
         cor  = 0.0
         rms  = 0.0
         pcor = 0.0
         prms = 0.0
         fit  = 0.0

         do i = 1, 3
          read (iunit,200)                              
          do k = 1, 11
           read (iunit,201) (cor(i,j,k,ii,jj,il),j=1,4),
    *                       (rms(i,j,k,ii,jj,il),j=1,4)
           write(*,    201) (cor(i,j,k,ii,jj,il),j=1,4),
    *                       (rms(i,j,k,ii,jj,il),j=1,4)
          enddo
          read (iunit,221) (pcor(i,j),j=1,10)
          read (iunit,221) (pcor(i,j),j=11,20)
          read (iunit,222) (prms(i,j),j=1,10)
          read (iunit,222) (prms(i,j),j=11,20)
         enddo
   
         read (iunit,200)                        
         do i = 1, 3
          read (iunit,215)   
          read (iunit,212)  (fit(i,j,1),j=1,12)
          read (iunit,212)  (fit(i,j,1),j=13,24)
          read (iunit,212)  (fit(i,j,2),j=1,12)
          read (iunit,212)  (fit(i,j,2),j=13,24)
          read (iunit,212)  (fit(i,j,3),j=1,11)
          read (iunit,212)  (fit(i,j,4),j=1,11)
          read (iunit,212)  (fit(i,j,5),j=1,12)
          read (iunit,212)  (fit(i,j,5),j=13,21)
          read (iunit,212)  (fit(i,j,6),j=1,12)
          read (iunit,212)  (fit(i,j,6),j=13,23)
          read (iunit,212)  (fit(i,j,7),j=1,5)
          read (iunit,212)  (fit(i,j,8),j=1,4)
         enddo
 200  format(1x)                              
 201  format(5x,4(f8.4),4(f9.2))
 212  format(5x,12(f6.2))
 215  format(80x)                              
 221  format(5x,1x,10(f7.4))
 222  format(5x,10(f7.2))
c
        enddo  ! jj loop
   
       enddo   ! ii loop

      enddo    ! il loop

      do ii = 1, idays
       do ifh = 1, 3
        do il = 1, 2  
         do im = 1, 11
         write (51) ((cor(ifh,ig,im,ii,jj,il),jj=1,icyc),ig=1,ng)
         enddo
        enddo
       enddo
       do ifh = 1, 3
        do il = 1, 2  
         do im = 1, 11
         write (51) ((rms(ifh,ig,im,ii,jj,il),jj=1,icyc),ig=1,ng)
         enddo
        enddo
       enddo
      enddo


 300  format(' Anomaly Corr. For ',a5,i5, 
     .       ' mb at verify hours = ',i3)                    
 301  format(a5,4(f8.4),4(f9.2))
 312  format(a5,12(f6.2))
 315  format('    ---- for ',a5,' ----' )
 321  format(a5,1x,10(f7.4))
 322  format(a5,10(f7.2))
 330  format(5x,18(i4))
 331  format(5x,' for fhours = ',i4)
      STOP
      END
