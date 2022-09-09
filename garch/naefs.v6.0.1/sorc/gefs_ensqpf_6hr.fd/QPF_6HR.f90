      PROGRAM CQPF_BIAS                                        
!
! MAIN PROGRAM: CQPF_BIAS
!   PRGMMR: YAN LUO          DATE: 13-12-18
!
!  ABSTRACT:
!    PQPF - Probabilitistic Quatitative Precipitation Forecast        
!   CPQPF - Calibrated PQPF by using reduced bias method             
!                                                                    
!   This program will read in 22 ensemble members and multiply        
!        by the coefficents for different threshold amount            
!        of every individual members. The coefficents will be         
!        two sets: one for MRF high resolution, another is           
!        low resolution control which based on past month/season      
!        statistics by using QTPINT interpolation program                              
!
!  PARAMETERS:
!     1. jpoint  ---> model resolution or total grid points ( 259920 )
!     2. iensem ---> number of ensember members ( 22 )
!     3. nfhrs   ---> total number of 6hrs
!     4. numreg  ---> number of RFC regions
!     5. ncat    ---> number of thresholds for bias correction
!     6. istd    ---> number of thresholds for PQPF output
!
! PROGRAM HISTORY LOG:
! 01-03-22 YUEJIAN ZHU IBM-ASP
! 01-09-25 YUEJIAN ZHU IBM-ASP modefied
! 04-02-09 YUEJIAN ZHU IBM-frost implememtation
! 06-02-06 YUEJIAN ZHU For new configuration
! 11-12-15 YAN LUO Upgrade to 1 deg and 6 hourly
! 13-12-18 YAN LUO Convert I/O from GRIB1 to GRIB2
!
! USAGE:
!
!   INPUT FILE:
!     
!     UNIT 05 -    : CONTROL INPUT FOR RUNNING THE CODE
!     UNIT 11 -    : RFC mask file, binary format     
!     UNIT 12 -    : statistics numbers for GFS deterministic (mrf)
!     UNIT 13 -    : statitsics numbers for GEFS control (ctl)               
!     UNIT 20 -    : QPF GRIB file           
!
!   OUTPUT FILE: 
! 
!     UNIT 50 -    : bias-free calibrated precipitation forecast, grib format
!     UNIT 51 -    : raw PQPF, grib format
!     UNIT 52 -    : bias-free CPQPF, grib format
!
! PROGRAMS CALLED:
!   
!   BAOPENW          GRIB I/O
!   BACLOSE          GRIB I/O
!   GETGRB2          GRIB2 READER
!   PUTGB2           GRIB2 WRITER
!   GF_FREE          FREE UP MEMORY FOR GRIB2 
!   INIT_PARM        DEFINE GRID DEFINITION AND PRODUCT DEFINITION
!   PRINTINFR        PRINT GRIB2 DATA INFORMATION
!   QTPINT           INTERPOLATION PROGRAM
!   CPCOEF           CALCULATE THE PRECIPITATION CALIBRATION
!                    COEFFICENT/RATIO BY USING STATISTICAL DISTRIBUTIONS
!   
! ATTRIBUTES:
!   LANGUAGE: FORTRAN 90
!
!$$$
      use grib_mod
      use params

      implicit none

      integer jpoint,iensem,nfhrs,numreg,ncat,istd
      parameter(jpoint=720*361,iensem=22,nfhrs=64,numreg=12,ncat=9)
      parameter(istd=13)
      real rk(istd),smask(jpoint)
      real rti(ncat),rob(ncat),rft(ncat)
      real rmrf(ncat),rctl(ncat) 
      real rmrf_us(ncat),rctl_us(ncat)
      real rti_r(ncat),rmrf_r(ncat),rctl_r(ncat)
      real aaa,bbb
      real, allocatable :: rmrf_reg(:,:),rctl_reg(:,:)
      real, allocatable :: thit_mrf(:,:,:),tobs_mrf(:,:,:)
      real, allocatable :: tfcs_mrf(:,:,:),ttot_mrf(:,:,:)
      real, allocatable :: thit_ctl(:,:,:),tobs_ctl(:,:,:)
      real, allocatable :: tfcs_ctl(:,:,:),ttot_ctl(:,:,:)
      real, allocatable :: usobs(:,:),usfcs(:,:)
      real, allocatable :: f(:),q(:)
      real, allocatable :: ff(:,:),fff(:,:),qqq(:,:)
      integer fhrs,icyc,maxgrd 
      integer kk,n,ii,jj,iend,k,ijk
      integer maskreg(jpoint)
      integer lctmpd,lpgb,lpgs,lpgr,lpgm
      integer ier20,ier50,ier51,ier52,iret
      integer e16(iensem),e17(iensem)
      integer ee16(iensem-1),ee17(iensem-1)
      integer temp(200)

      integer ipd1,ipd2,ipd10,ipd11,ipd12
      integer jskp,jdisc,jpdtn,jgdtn,idisc,ipdtn,igdtn
      integer,dimension(200) :: jids,jpdt,jgdt,iids,ipdt,igdt
      common /param/jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt

      type(gribfield) :: gfld,gfldo
      integer :: currlen=0
      logical :: unpack=.true.
      logical :: expand=.false.

      logical :: first=.true.

      character datcmd*3,datcyc*2
      character*255 clmrf,fclmrf,clctl,fclctl,pcpda,cmask,dmask,ctmpd
      character*255 cpgbf,coptr,copts,coptm 
! VAIABLE: APCP

      data ipd1 /1/
      data ipd2 /8/
      data ipd10/1/
      data ipd11/0/
      data ipd12/0/
      data e16/0,1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3/
      data e17/0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20/
      data ee16/1,3,3,3,3,3,3,3,3,3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3/
      data ee17/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20/

      data rk/0.254,1.00,1.27,2.54,5.00,6.35,10.00,12.7,20.0,25.4, &
              50.8,101.6,152.4/
      data rti/25.0,15.0,10.0,7.0,5.0,3.2,2.0,1.0,0.2/

 80   format(a80)
!  READ IN FOR TEMP DIRECTORY                                
      read   (5,80,end=9000) ctmpd 
      write  (6,*) 'FOR TEMP DIRECTORY: ',ctmpd(1:80) 
      lctmpd=len_trim(ctmpd)
!  READ IN FOR CYCLE                                
      read   (5,*,end=9000) icyc
      write  (6,*) 'FOR CYCLE: ', icyc 
!  READ IN FOR FORECAST HOUR
      read   (5,*,END=9000)  fhrs
      write  (6,*) 'FOR : FORECAST HOUR', fhrs
!ccc
!ccc   Step 1: read in the data on GRIB 3 ( 720*361 ) of global
!ccc
      n = fhrs/6      
       print *, " ***********************************"
       print *, " ***      SIX HOURS = ",n,"        ***"
       print *, " ***********************************"
!      if (fhrs.lt.100) then
!        write (datcmd,121) fhrs
!      else 
        write (datcmd,122) fhrs
!      endif
      write (datcyc,121) icyc
121   format(i2.2)
122   format(i3.3)

           cpgbf=ctmpd(1:lctmpd) // '/' //'geprcp.t'// &
                 datcyc(1:2)// 'z.pgrb2a.0p50.f' //datcmd           
           coptr=ctmpd(1:lctmpd) // '/' //'gepqpf.t'// &
                 datcyc(1:2)// 'z.pgrb2a.0p50.f' //datcmd
!
!        CALL FUNCTION STAT TO FIND NUMBER OF BYTES IN FILE
!
        write  (6,*) '=============================================='
           write  (6,*) 'FORECAST DATA NAME: ',cpgbf(1:100)
           write  (6,*) 'BIAS CORRECTED FORECAST DATA NAME: ',copts(1:100)
           lpgb=len_trim(cpgbf)
           lpgr=len_trim(coptr)
           call baopenr(20,cpgbf(1:lpgb),ier20)
           call baopenw(51,coptr(1:lpgr),ier51)           

!  READ IN PRECIP FORECAST
      if (n.le.40) then
       iend=iensem
      else
       iend=iensem-1
      endif

      allocate(f(jpoint),q(jpoint))
      allocate(ff(jpoint,iend),fff(jpoint,istd),qqq(jpoint,istd))

       do jj = 1, iend   ! iend = # of ensemble 
         iids=-9999;ipdt=-9999; igdt=-9999
         idisc=-1;  ipdtn=-1;   igdtn=-1
         ipdt(1)=ipd1
         ipdt(2)=ipd2
         ipdt(5)=107
         ipdt(10)=ipd10
         ipdt(11)=ipd11
         ipdt(12)=ipd12
         if (n.le.40) then
          if (jj.eq.1) ipdt(5)=96
          ipdt(16)=e16(jj)
          ipdt(17)=e17(jj)
         else
          ipdt(16)=ee16(jj)
          ipdt(17)=ee17(jj)
         endif
         ipdtn=11; igdtn=-1
         call init_parm(ipdtn,ipdt,igdtn,igdt,idisc,iids)
         call getgb2(20,0,jskp,jdisc,jids,jpdtn,jpdt,jgdtn,jgdt,&
                  unpack,jskp,gfld,iret)
        if (iret.eq.0) then
         maxgrd=gfld%ngrdpts
         if (maxgrd .ne. jpoint) then
         print*,'Mismatched resolution between mask and forecast, stop!'
         endif
         if (maxgrd .ne. jpoint) goto 9000
          f(1:jpoint) = gfld%fld(1:jpoint)
         call printinfr(gfld,jj)
        do ii = 1, jpoint
          ff(ii,jj) = f(ii)
        enddo
        endif  ! if (iret.eq.0)
        if (jj.ne.iend) call gf_free(gfld)
       enddo   ! for jj = 1, iend; iend = # of ensemble 
       gfldo=gfld

       print *,'fcst= ', ff(4600,iend) 
       print *, "============================================"

!ccc
!ccc    Step 2: calculate the PQPF
!ccc
       do k = 1, istd
        f   = 0.0
        do ii = 1, jpoint
!ccccc to exclude GFS/AVN high resolution forecast
       if (n.le.40) then
         do jj = 2, iend
          if (ff(ii,jj).ge.rk(k)) then
           f(ii) = f(ii) + 1.0
          endif
         enddo
         else
         do jj = 1, iend
          if (ff(ii,jj).ge.rk(k)) then
           f(ii) = f(ii) + 1.0
          endif
         enddo
       endif
         f(ii) = f(ii)*100.00/float(21)
         if (f(ii).ge.99.0) then
          f(ii) = 100.0
         endif
        enddo
         do ii = 1, jpoint
         fff(ii,k)=f(ii)
          enddo        
       enddo

!ccc
!ccc    write out the PQPF/CPQPF results
!ccc
        print *, '----- Output PQPF/CPQPF -----'

      temp=-9999

      ! change grib2 pdt message for new ensemble products

      gfldo%idsect(2)=2  ! Identification of originating/generating subcenter
                         ! 2: NCEP Ensemble Products

      gfldo%idsect(13)=5 ! Type of processed data in this GRIB message       
                         ! 5: Control and Perturbed Forecast Products

!     print *, 'gfldo%ipdtlen=',gfldo%ipdtlen 
!     print *, 'gfldo%ipdtmpl=',gfldo%ipdtmpl 

      temp(1:gfldo%ipdtlen)=gfldo%ipdtmpl(1:gfldo%ipdtlen)

      deallocate (gfldo%ipdtmpl)
                              ! 5: Probability Forecast 
      gfldo%ipdtnum=9         ! Probability forecasts from ensemble 
      if(gfldo%ipdtnum.eq.9) gfldo%ipdtlen=36
      if(gfldo%ipdtnum.eq.9) allocate (gfldo%ipdtmpl(gfldo%ipdtlen))

      gfldo%ipdtmpl(1:15)=temp(1:15)

      gfldo%ipdtmpl(1)=1      ! Parameter category : 1 Moisture
      gfldo%ipdtmpl(2)=8      ! Parameter number : 8 Total Precipitation(APCP)

      gfldo%ipdtmpl(16)=0     ! Forecast probability number 
      gfldo%ipdtmpl(17)= iensem-1  ! Total number of forecast probabilities
       if (n.le.40) gfldo%ipdtmpl(17)= iensem
      gfldo%ipdtmpl(18)=1     ! Probability Type
                              ! 1: Probability of event above upper limit
      gfldo%ipdtmpl(19)=0     ! Scale factor of lower limit
      gfldo%ipdtmpl(20)=0     ! Scaled value of lower limit
      gfldo%ipdtmpl(21)=3     ! Scale factor of upper limit

      ! gfldo%ipdtmpl(22) will be set below 

      gfldo%ipdtmpl(23:36)=temp(19:32)
     ! gfldo%ipdtmpl(22): Scaled value of upper limit

       do k = 1, istd

        do ii = 1, jpoint
          f(ii) = fff(ii,k)
        enddo

      gfldo%ipdtmpl(3) = 5
      gfldo%ipdtmpl(22)=rk(k)*(10**gfldo%ipdtmpl(21))

      gfldo%fld(1:jpoint)=f(1:jpoint)

!     print *, 'gfldo%ipdtlen=',gfldo%ipdtlen
!     print *, 'gfldo%ipdtmpl=',gfldo%ipdtmpl
!      print *, 'k=',k,  'temp=', (temp(i), i=1,32)

      call putgb2(51,gfldo,iret)

       enddo    ! for k = 1, istd
      call gf_free(gfldo)

       call baclose (20,ier20)
       call baclose (51,ier51)
       deallocate(f,q)
       deallocate(ff,fff,qqq)
       
9000      stop
          end


