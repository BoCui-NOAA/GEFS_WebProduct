      program READIN
C--------+---------+---------+---------+---------+---------+---------+---------+
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC
CCC   nl - no. of levels ( 1000, 925, 850, 700, 600, 500, 400, 300 )
CCC   nh - no. of regions ( nh, sh, tropical )
CCC   ng - no. of wave groups ( 1-3, 4-9, 10-20, 1-20 )
CCC   nd - no. of forecast length ( 16-days )
CCC   nfh- no. of nf*nh
CCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter (nl=8,nh=3,ng=4,nd=17)            
      dimension acr(nh,nl,ng,nd,500),rms(nh,nl,ng,nd,500)
      dimension ifile(500)
      character*80 cfile(500)
      character*80 ofile
      namelist/namin/cfile,ifile,ofile,idays
CCC
      read (5,namin)
      write(6,namin)

      acr=9.9999
      rms=99.99

      do ii = 1, idays
      if (ifile(ii).eq.1) then
       print *, cfile(ii)
       open(unit=11,file=cfile(ii),err=1020)
CCC
CCC   read AC and RMS for 8 pressure levels               
CCC
       do ih = 1, nh
        do il = 1, nl
         read (11,991)
         read (11,991)
         do jj = 1, nd
          read (11,992) (acr(ih,il,kk,jj,ii),kk=1,ng)
c         write(*,992) (acr(ih,il,kk,jj,ii),kk=1,ng)
         enddo
         read (11,991)
         read (11,991)
         do jj = 1, nd
          read (11,993) (rms(ih,il,kk,jj,ii),kk=1,ng)
c         write(*,993) (rms(ih,il,kk,jj,ii),kk=1,ng)
         enddo
        enddo
       enddo
       close(unit=11)
      endif
      enddo
  991 format(a1)
  992 format(39x,4(1x,f7.4))
  993 format(39x,4(1x,f7.2))
  994 format(10(f8.4))
CCC
CCC   write out to grads format
CCC
      irec=0
      open(unit=51,file=ofile,form='UNFORMATTED',
     *     access='DIRECT',recl=68*4,err=1020)
      do ii = 1, idays
       do ih = 1, nh

        do il = 1, nl
         do id = 1, nd
          do ig = 1, ig
           if (acr(ih,il,ig,id,ii).eq.9.9999) then
            acr(ih,il,ig,id,ii) = -999.99
            if ((il.eq.2).and.(acr(ih,1,ig,id,ii).ne.-999.99)
     *                   .and.(acr(ih,3,ig,id,ii).ne.9.9999)) then
             acr(ih,2,ig,id,ii) =
     *        (acr(ih,1,ig,id,ii) + acr(ih,3,ig,id,ii))/2.0
            endif
            if ((il.eq.5).and.(acr(ih,4,ig,id,ii).ne.-999.99)
     *                   .and.(acr(ih,6,ig,id,ii).ne.9.9999)) then
             acr(ih,5,ig,id,ii) =
     *        (acr(ih,4,ig,id,ii) + acr(ih,6,ig,id,ii))/2.0
            endif
           endif
           if (rms(ih,il,ig,id,ii).eq.99.99) then
            rms(ih,il,ig,id,ii) = -999.99
            if ((il.eq.2).and.(rms(ih,1,ig,id,ii).ne.-999.99)
     *                   .and.(rms(ih,3,ig,id,ii).ne.99.99)) then
             rms(ih,2,ig,id,ii) =
     *        (rms(ih,1,ig,id,ii) + rms(ih,3,ig,id,ii))/2.0
            endif
            if ((il.eq.5).and.(rms(ih,4,ig,id,ii).ne.-999.99)
     *                   .and.(rms(ih,6,ig,id,ii).ne.99.99)) then
             rms(ih,5,ig,id,ii) =
     *        (rms(ih,4,ig,id,ii) + rms(ih,6,ig,id,ii))/2.0
            endif
           endif
          enddo
         enddo
        enddo

        do il = 1, nl
         irec=irec+1
         write (51,rec=irec) ((acr(ih,il,ig,id,ii),id=1,nd),ig=1,ng)
c        write (*,994) ((acr(ih,il,ig,id,ii),id=1,nd),ig=1,ng)
        enddo
        do il = 1, nl
         irec=irec+1
         write (51,rec=irec) ((rms(ih,il,ig,id,ii),id=1,nd),ig=1,ng)
        enddo
       enddo
      enddo
      
      stop
 1020 print *, ' there is a error to open unit 11'
      stop
      end
