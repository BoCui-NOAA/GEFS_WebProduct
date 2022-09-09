!!! Huiling Yuan (YHL)  July 16, 2007, to create pseudo precip map, at NOAA/ESRL/GSD, huiling.yuan@noaa.gov
!!! usage: f90 (pgf90) anapseudo.f
!!! update 12/19/2007 for NCEP/NCAR Reanalysis pressure level data, global
!!! formula   pseudoprecip=1/g*integral <(q-qsat)dp>; q is specific humidity, qsat is saturated specific humidity

	program pseudoprecip
	parameter(nx=144,ny=73,nz=8) ! NCEP/NCAR Reanalysis pressure data grid
	real pseudop(nx,ny),precip(nx,ny)  !pseudo precip., real total precip.
	real sfct(nx,ny),sfcrh(nx,ny),sfcp(nx,ny) !surface variables: temp, RH, pressure
	real t(nx,ny,nz),rh(nx,ny,nz) !upper levels variables: tmp, RH
	real p(nz) !pressure levels
	data p/1000,925,850,700,600,500,400,300/ !8 pressure levels, 'hPa'

	open(11,file='TMPsfc.dat',form='unformatted') !surface temperature 'K'
	open(12,file='RHsfc.dat',form='unformatted') !surface relative humidity '%'
	open(13,file='PRESsfc.dat',form='unformatted') !surface pressure 'Pa'
!!!	open(14,file='APCP.dat',form='unformatted')  !total precipitation 'mm'
	open(21,file='TMP.dat',form='unformatted')  !upper temperature 'K'
	open(22,file='RH.dat',form='unformatted')    !upper realtive humidity '%'
	open(50,file='pseudop.dat',form='unformatted')  !output pseudo precipitation 'mm'

	precip=0 ! no precipitation input for the reanalysis data I
	p=p*100 ! convert to 'Pa'

300	continue

!!! YHL read surface variables
	read(11,end=999)sfct !30-0 mb above ground
	read(12)sfcrh !30-0 mb above ground
	read(13)sfcp 
!!	read(14)precip

!!! YHL read upper levels variables
	do k=1,nz
	read(21)((t(i,j,k),i=1,nx),j=1,ny)
	read(22)((rh(i,j,k),i=1,nx),j=1,ny)
	enddo

!!! convert unit to standard unit
	sfcp=sfcp-30*100 ! minus 30 mb
	sfct=sfct-273.15 ! convert to 'C'
	sfcrh=sfcrh*0.01 ! convert to 0-1
	t=t-273.15  ! convert to 'C'
	rh=rh*0.01  ! convert to 0-1

!	call maxmin(sfct,dmax,dmin,nx,ny,1,'sfcTMP')
!	call maxmin(sfcrh,dmax,dmin,nx,ny,1,'sfcrh')
!	call maxmin(sfcp,dmax,dmin,nx,ny,1,'sfcp ')
!	call maxmin(t,dmax,dmin,nx,ny,nz,'TMP  ')
!	call maxmin(rh,dmax,dmin,nx,ny,nz,'rh   ')
!!!	call maxmin(precip,dmax,dmin,nx,ny,1,'precip')

	call pseudo(sfct,sfcrh,sfcp,t,rh,p,precip,pseudop,nx,ny,nz) !calculate pseudo precipitation

!	call maxmin(pseudop,dmax,dmin,nx,ny,1,'pseudop')
	write(50)pseudop !output pseudo precipitation (kg/m², equivalent to mm)
	goto 300

999	stop 999
	end

	SUBROUTINE PSEUDO (sfct,sfcrh,sfcp,t,rh,p,precip,pseudop,nx,ny,nz)
!!!!!!!!!! YHL, SUBROUTINE PSEUDO, create pseudo precipitation (mm), by integral of specific humidity 
!YHL, read in pressure(Pa), relative humididy(fraction),temperature(C) at all upper levels and surface
!YHL, read in total precipitation (mm)
!YHL, output pseudo precipitation (kg/m², equivalent to mm)

	parameter (g=9.80665) !Gravitational acceleration m/s² (32.17 ft/s²)
	real pseudop(nx,ny),precip(nx,ny) !pseudo precip., real total precip.
	real sfct(nx,ny),sfcrh(nx,ny),sfcp(nx,ny) ! surface variables:temp, RH, pressure
	real t(nx,ny,nz),rh(nx,ny,nz) ! upper levels variables:tmp,RH
	real p(nz) ! pressure levels
	real qvap(nx,ny,nz),qvsat(nx,ny,nz),es(nx,ny,nz) !specific humidity, saturated specific humidity, water vapor saturation pressure
	real sfcqvap(nx,ny),sfcqvsat(nx,ny),sfces(nx,ny) !surface variables: q, qsat, water vapor saturation pressure

!!!!! caculate specific humidity (qvap,qvsat,sfcqvat,sfcqvsat)
	do j=1,ny
	do i=1,nx

	do k=1,nz 
	es(i,j,k)=6.112*exp(17.67*t(i,j,k)/(t(i,j,k)+243.5)) !YHL, water vapor saturation pressure, Bolton (1980), t in [C], and es in [hPa]
	es(i,j,k)=es(i,j,k)*100 ! convert [hPa] to [Pa]
	qvsat(i,j,k)=0.622*es(i,j,k)/p(k) ! YHL, saturated specific humidity
	qvap(i,j,k)=qvsat(i,j,k)*rh(i,j,k) !YHL, specific humidity
	enddo

	sfces(i,j)=6.112*exp(17.67*sfct(i,j)/(sfct(i,j)+243.5)) !surface water vapor saturation pressure
	sfces(i,j)=sfces(i,j)*100 ! convert [hPa] to [Pa]
	sfcqvsat(i,j)=0.622*sfces(i,j)/sfcp(i,j) ! YHL, surface saturate specific humidity
	sfcqvap(i,j)=sfcqvsat(i,j)*sfcrh(i,j) !YHL, surface specific humidity

	enddo
	enddo

!	call maxmin(qvsat,dmax,dmin,nx,ny,nz,'qvsat')
!	call maxmin(qvap,dmax,dmin,nx,ny,nz,'qvap')
!	call maxmin(sfcqvsat,dmax,dmin,nx,ny,1,'sfcqvsat')
!	call maxmin(sfcqvap,dmax,dmin,nx,ny,1,'sfcqv')
!!!!! end calculate specific humidity


!!!!!!! calculate pseudo precipitation (pseudop)
        pseudop=precip   ! initialize pseudo precipitation (pseudop)

	do j=1,ny
	do i=1,nx

! integral of 30-0 mb above ground
	pseudop(i,j)=pseudop(i,j)+(sfcqvap(i,j)-sfcqvsat(i,j))*3000.0/g !30-0 mb above ground

! integral of specific humidity between two layers
	if(sfcp(i,j).gt.p(1))then ! YHL, integral if sfcp > the lowest layer
	dp=sfcp(i,j)-p(1)   !pressure interval
	qm=(sfcqvap(i,j)+qvap(i,j,1))/2 !average specific humidity between two layers
        qsatm=(sfcqvsat(i,j)+qvsat(i,j,1))/2 !average saturated specific humidity between two layers
        pseudop(i,j)=pseudop(i,j)+(qm-qsatm)*dp/g !integral
	endif

	do k=1,nz-1
	if(sfcp(i,j).lt.p(k).and.sfcp(i,j).gt.p(k+1))then ! YHL, integral between surface and the lowest layer
	dp=sfcp(i,j)-p(k+1)   !pressure interval
	qm=(sfcqvap(i,j)+qvap(i,j,k+1))/2 !average specific humidity between two layers
        qsatm=(sfcqvsat(i,j)+qvsat(i,j,k+1))/2 !average saturated specific humidity between two layers
        pseudop(i,j)=pseudop(i,j)+(qm-qsatm)*dp/g !integral
	endif

	if(sfcp(i,j).ge.p(k))then ! YHL, integral if two layers above ground
	dp=p(k)-p(k+1)   !pressure interval
	qm=(qvap(i,j,k)+qvap(i,j,k+1))/2 !average specific humidity between two layers
        qsatm=(qvsat(i,j,k)+qvsat(i,j,k+1))/2 !average saturated specific humidity between two layers
        pseudop(i,j)=pseudop(i,j)+(qm-qsatm)*dp/g !integral
	endif
	enddo !end  k=1,nz-1

	enddo
	enddo
!!!!!!!! end calculate pseudo precipitation

	return
	END !YHL, end PSEUDO

	subroutine maxmin(data,qmax,qmin,nx,ny,nz,var) ! rerun miminum, maximum value
	real  data(nx,ny,nz)
	character var*5
	qmin=minval(data)
	qmax=maxval(data)
	print*,var,qmin,qmax
	return
	end
