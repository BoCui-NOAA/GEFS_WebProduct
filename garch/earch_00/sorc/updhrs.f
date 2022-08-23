C$$$  MAIN PROGRAM DOCUMENTATION BLOCK
C
C MAIN PROGRAM: UPDHRS        UPDATED HOURS IN CALCULATION 
C   PRGMMR: YUEJIAN ZHU       ORG:NP23           DATE: 97-03-17
C
C ABSTRACT: USING W3 ROUTINE TO SHIFT DATE/HOUR FORWARD OR BACKWARD
C
C PROGRAM HISTORY LOG:
C   94-??-??   ROBERT KISTLER   - Originator
C   97-03-17   YUEJIAN ZHU      - Added DOCBLOACK
C
C USAGE:
C
C   INPUT FILES:
C     NAMELIST /NAMIN/ iyear,imonth,iday,ihour,idate,nhours,cdate
C
C   OUTPUT FILES:
C     NAMELIST /NAMOUT/ iyear,imonth,iday,ihour
C
C   SUBPROGRAMS CALLED:
C     W3FS11 -- W3LIB ROUTINE
C     W3FS15 -- W3LIB ROUTINE
C
C   EXIT STATES:
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C
C$$$
      program updhrs
	  character * 80 cdate
	  data idate/0/,iyear/0/,imonth/0/,iday/0/,ihour/-1/
	  namelist /namin/ iyear,imonth,iday,ihour,idate,nhours,cdate
	  namelist /namout/ iyear,imonth,iday,ihour
      read(5,namin)
	  if ( idate .ne. 0) then
		  nstart = idate
		  call w3fs15(nstart,nhours,newdat)
      else if (cdate(1:4) .eq. 'DATE') then
		  read(cdate(09:10),'(i2)') iyear
		  read(cdate(11:12),'(i2)') imonth
		  read(cdate(13:14),'(i2)') iday
		  read(cdate(15:16),'(i2)') ihour
          call w3fs11(nstart,iyear,imonth,iday,ihour,0)
	  else
          call w3fs11(nstart,iyear,imonth,iday,ihour,0)
	  endif
	  call w3fs15(nstart,nhours,newdat)
	  call w3fs11(newdat,iyear,imonth,iday,ihour,1)
c	  write(6,namout)
	  newdat = iyear*10**6 + imonth*10**4 + iday*10**2 + ihour
	  print '(''DATE  C2'',i8,''    WASHINGTON  '')',newdat
      stop
      end

