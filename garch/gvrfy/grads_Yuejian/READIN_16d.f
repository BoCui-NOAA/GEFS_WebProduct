      program READIN
C--------+---------+---------+---------+---------+---------+---------+---------+
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCC
CCC   nf - no. of fields ( z,u,v )
CCC   nl - no. of levels ( 1000, 850, 500 )
CCC   nh - no. of regions ( nh, sh, tropical )
CCC   ng - no. of wave groups ( 1-3, 4-9, 10-20, 1-20 )
CCC   nd - no. of forecast length ( 16-days )
CCC   nfh- no. of nf*nh
CCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter (nf=3,nl=3,nh=3,ng=4,nd=17,nfh=nf*nh)            
      dimension acr(nfh,nl,ng,nd,100),rms(nfh,nl,ng,nd,100)
      dimension ifile(100)
      character*80 cfile(100)
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
CCC   read AC and RMS for 1000mb and 500mb (NH and SH)
CCC
       do ih = 1, 2
        do il = 1, 3, 2
         read (11,991)
         read (11,991)
         ifh = ih*1
         do jj = 1, nd
          read (11,992) (acr(ifh,il,kk,jj,ii),kk=1,ng)
         enddo
         read (11,991)
         read (11,991)
         do jj = 1, nd
          read (11,993) (rms(ifh,il,kk,jj,ii),kk=1,ng)
         enddo
        enddo
       enddo
CCC
CCC   read AC and RMS for 850mb U.V for tropical
CCC
       do ih = 3, 3
        do il = 2, 2
         read (11,991)
         read (11,991)
         ifh = ih*2
         do jj = 1, nd
          read (11,992) (acr(ifh,il,kk,jj,ii),kk=1,ng)
         enddo
         read (11,991)
         read (11,991)
         do jj = 1, nd
          read (11,993) (rms(ifh,il,kk,jj,ii),kk=1,ng)
         enddo
         read (11,991)
         read (11,991)
         ifh = ih*3
         do jj = 1, nd
          read (11,992) (acr(ifh,il,kk,jj,ii),kk=1,ng)
         enddo
         read (11,991)
         read (11,991)
         do jj = 1, nd
          read (11,993) (rms(ifh,il,kk,jj,ii),kk=1,ng)
         enddo
        enddo
       enddo
       close(unit=11)
      endif
      enddo
  991 format(a10)
  992 format(39x,4(1x,f7.4))
  993 format(39x,4(1x,f7.2))
  994 format(10(f8.4))
CCC
CCC   write out to grads format
CCC
      irec=0
      open(unit=51,file=ofile,form='UNFORMATTED',
     *     access='DIRECT',recl=64*4,err=1020)
      do ii = 1, idays
       do ifh = 1, nfh
        do il = 1, nl
         irec=irec+1
         write (51,rec=irec) ((acr(ifh,il,ig,id,ii),id=1,nd),ig=1,ng)
c        write (*,994) ((acr(ifh,il,ig,id,ii),id=1,nd),ig=1,ng)
        enddo
       enddo
      enddo
      
      stop
 1020 print *, ' there is a error to open unit 11'
      stop
      end
