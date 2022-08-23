      PROGRAM AVG 
      parameter(icyc=31)
      dimension cor(3,4,11),acor(3,4,11,icyc),icor(3,4,11,icyc)
      dimension rms(3,4,11),arms(3,4,11,icyc),irms(3,4,11,icyc)
      dimension pcor(3,17),prms(3,17)
      dimension apcor(3,17,icyc),aprms(3,17,icyc)
      dimension ipcor(3,17,icyc)
      dimension fit(3,18,9),afit(3,18,9,icyc)
      dimension ifile(200),ilevel(2)
      character*5  chem(3),clab(11),flab(9)
      character*80 cfile(200),ofile
      character*28 asuniti,asunitj,asunitk
      namelist/namin/ cfile,ifile,idays,ofile
      data chem /'N Hem','S Hem','Trop.'/
      data clab /' MRF ',' CTL ','00Zpa',' AVN ','12Zpa',
     &           '17tsa',' 8ems','10ems','14ems','17tms','Meds '/
      data flab /'T17  ','T-1  ','T08  ','T10  ','T14  ','T-1  ',
     &           'R17  ','Rs5  ','Sg4  '/
      data iunit/11/,junit/12/,kunit/51/
      data ilevel/1000,500/
ccc
      read  (5,namin,end=1020)
 1020 continue
      write (6,namin)
      open(unit=kunit,file=ofile,form='FORMATTED',
     1     status='NEW')
ccc
ccc   Read 1000 mb and 500 mb N + S Hem. AC and RMS
ccc 
 
      do il = 1, 2           ! 1000, 500 mb

      acor = 0.0
      arms = 0.0
      apcor= 0.0
      aprms= 0.0
      afit = 0.0
      icor = 0
      irms = 0
      ipcor= 0

      do ii = 1, idays       ! totally files read

      if (ifile(ii).eq.1) then

      print *, ' open file ',cfile(ii)

      open(unit=iunit,file=cfile(ii),form='FORMATTED',status='OLD')

      if (il.eq.2) then
       do jj = 1,2914
        read (iunit,200)
       enddo
      endif

      do jj = 1, icyc          ! 30 cycles

      cor  = 0.0
      rms  = 0.0
      pcor = 0.0
      prms = 0.0
      fit  = 0.0
       do i = 1, 3
       read (iunit,200)                              
       do k = 1, 11
       read (iunit,201) (cor(i,j,k),j=1,4),(rms(i,j,k),j=1,4)
       enddo
       read (iunit,221) (pcor(i,j),j=1,10)
       read (iunit,221) (pcor(i,j),j=11,14)
       read (iunit,222) (prms(i,j),j=1,10)
       read (iunit,222) (prms(i,j),j=11,14)
       enddo

       read (iunit,200)                        
       do i = 1, 3
       read (iunit,215)   
       read (iunit,212)  (fit(i,j,1),j=1,9)
       read (iunit,212)  (fit(i,j,1),j=10,18)
       read (iunit,212)  (fit(i,j,2),j=1,9)
       read (iunit,212)  (fit(i,j,2),j=10,18)
       read (iunit,212)  (fit(i,j,3),j=1,9)
       read (iunit,212)  (fit(i,j,4),j=1,11)
       read (iunit,212)  (fit(i,j,5),j=1,9)
       read (iunit,212)  (fit(i,j,5),j=10,15)
       read (iunit,212)  (fit(i,j,6),j=1,9)
       read (iunit,212)  (fit(i,j,6),j=10,15)
       read (iunit,212)  (fit(i,j,7),j=1,9)
       read (iunit,212)  (fit(i,j,7),j=10,17)
       read (iunit,212)  (fit(i,j,8),j=1,5)
       read (iunit,212)  (fit(i,j,9),j=1,4)
       enddo
 200  format(80x)                              
 201  format(5x,4(f8.4),4(f9.2))
 212  format(5x,12(f6.2))
 215  format(80x)                              
 221  format(5x,1x,10(f7.4))
 222  format(5x,10(f7.2))
c
      do i = 1, 3    
       do j = 1, 4  
        do k = 1, 11 
           if (cor(i,j,1).eq.9.999) then
              print *, 'reg=',i,' wav=',j,' catg=',k, ' value=9.999'
           else
              acor(i,j,k,jj)=acor(i,j,k,jj)+cor(i,j,k)
              icor(i,j,k,jj)=icor(i,j,k,jj)+1
           endif
           if (rms(i,1,1).eq.99.99.or.rms(i,1,1).gt.200.0) then
              print *, 'reg=',i,' rms=',j,' value=99.99'
           else
              arms(i,j,k,jj)=arms(i,j,k,jj)+rms(i,j,k)
              irms(i,j,k,jj)=irms(i,j,k,jj)+1
           endif
        enddo
       enddo
      enddo
c
      do i = 1, 3
       do j = 1, 14
           if (pcor(i,j).ne.9.999) then
              apcor(i,j,jj) = apcor(i,j,jj) + pcor(i,j)
              aprms(i,j,jj) = aprms(i,j,jj) + prms(i,j)
              ipcor(i,j,jj) = ipcor(i,j,jj) + 1
           endif
       enddo
      enddo
c
      do i = 1, 3
       do j = 1, 18
        do k = 1, 9
           if (cor(i,j,1).ne.9.999) then
              afit(i,j,k,jj)=afit(i,j,k,jj)+fit(i,j,k)
           endif
        enddo
       enddo
      enddo
c
      enddo     ! for jj loop
      close(iunit)
      else
        print *, ' we will skip ii=',ii
      endif
      enddo
ccc
ccc get average filed
ccc
      do jj = 1, icyc
      do i = 1, 3    
       do j = 1, 4
        do k = 1, 11
           if (icor(i,j,k,jj).ne.0) then
           acor(i,j,k,jj) = acor(i,j,k,jj)/icor(i,j,k,jj)
           else
           acor(i,j,k,jj) = 0.00
           endif
           if (irms(i,j,k,jj).ne.0) then
           arms(i,j,k,jj) = arms(i,j,k,jj)/irms(i,j,k,jj)
           else
           arms(i,j,k,jj) = 0.00
           endif
        enddo
       enddo
      enddo
c
      do i = 1, 3
       do j = 1, 14
           if (ipcor(i,j,jj).ne.0) then
              apcor(i,j,jj) = apcor(i,j,jj)/ipcor(i,j,jj)
              aprms(i,j,jj) = aprms(i,j,jj)/ipcor(i,j,jj)  
           else
              apcor(i,j,jj) = 0.0
              aprms(i,j,jj) = 0.0
           endif
       enddo
      enddo
c
      do i = 1, 3
       do j = 1, 18
        do k = 1, 9
           if (icor(i,j,1,jj).ne.0) then
              afit(i,j,k,jj)=afit(i,j,k,jj)/icor(i,j,1,jj)  
           else
              afit(i,j,k,jj)= 0.0
           endif
        enddo
       enddo
      enddo
      enddo  ! jj loop
c  
      do jj = 1, icyc
        ihour=(jj-1)*12
        print *, ' for fhours = ', ihour
        write(kunit,331) ihour           
        write(kunit,330) (icor(1,1,k,jj),k=1,11)
        write(kunit,330) (irms(1,1,k,jj),k=1,11)
      enddo
      do jj = 1, icyc
       ihour=(jj-1)*12
       do i = 1, 3
       write(kunit,300) chem(i),ilevel(il),ihour
       do k = 1, 11
       write(kunit,301) clab(k),(acor(i,j,k,jj),j=1,4),
     &                          (arms(i,j,k,jj),j=1,4)
       enddo
       write(kunit,321) clab(3),(apcor(i,j,jj),j=1,10)
       write(kunit,321) clab(5),(apcor(i,j,jj),j=11,14)
       write(kunit,322) clab(3),(aprms(i,j,jj),j=1,10)
       write(kunit,322) clab(5),(aprms(i,j,jj),j=11,14)
       enddo
ccc
ccc
ccc
       do i = 1, 3
       write(kunit,315) chem(i)
       write(kunit,312)  flab(1),(afit(i,j,1,jj),j=1,9)
       write(kunit,312)  flab(1),(afit(i,j,1,jj),j=10,18)
       write(kunit,312)  flab(2),(afit(i,j,2,jj),j=1,9)
       write(kunit,312)  flab(2),(afit(i,j,2,jj),j=10,18)
       write(kunit,312)  flab(3),(afit(i,j,3,jj),j=1,9)
       write(kunit,312)  flab(4),(afit(i,j,4,jj),j=1,11)
       write(kunit,312)  flab(5),(afit(i,j,5,jj),j=1,9)
       write(kunit,312)  flab(5),(afit(i,j,5,jj),j=10,15)
       write(kunit,312)  flab(6),(afit(i,j,6,jj),j=1,9)
       write(kunit,312)  flab(6),(afit(i,j,6,jj),j=10,15)
       write(kunit,312)  flab(7),(afit(i,j,7,jj),j=1,9)
       write(kunit,312)  flab(7),(afit(i,j,7,jj),j=10,17)
       write(kunit,312)  flab(8),(afit(i,j,8,jj),j=1,5)
       write(kunit,312)  flab(9),(afit(i,j,9,jj),j=1,4)
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
