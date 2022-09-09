!!!! Huiling Yuan, last modified  June 03, 2008
!!!! function: generate pseudo precipitation for NCAR/NCEP Reanalysis II data
!!!! usage: pgf90 pseudogrib.f90 libw3.a pseudo.f -o pseudogrib.exe

IMPLICIT NONE

character(100) :: gribFile
integer :: stat, nx, ny,nz, numPtIn, numPtOut, K, numGribs=1, numGridsRead, nxny, i,j,ik,ij
parameter(nx=144, ny=73,nz=8) ! for NCAR/NCEP Reanalysis II data, nx,ny; nz is available pressure levels in upper-level and surface GRIB files
character(10) :: date
character(4)  :: syear
character(2)  :: smonth, sday, shour
integer :: year, month, day, hour
integer, dimension(200) :: jpds, jgds, KPDS, KGDS
logical*1, dimension(:), allocatable :: LB
logical, dimension(:,:), allocatable :: bitmap
real, dimension(:), allocatable :: tempArray
real, dimension(:,:), allocatable :: avgGrid, num, tempGrid
integer :: nyhl,kyhl,iunit,iout
        real pseudop(nx,ny),precip(nx,ny)  !pseudo precip., real total precip.
        real pwat(nx,ny)  !pwat
        real sfct(nx,ny),sfcrh(nx,ny),sfcp(nx,ny) !surface variables: temp, RH, pressure
        real t(nx,ny,nz),rh(nx,ny,nz) !upper levels variables: tmp, RH
        real p(nz),p0(nz) !pressure levels
        data p/1000,925,850,700,600,500,400,300/ !8 pressure levels, 'hPa'


nxny=nx*ny ! Max data points to read in by getgb

! Allocate array space
allocate(lb(nxny),tempArray(nxny),num(nx,ny),avgGrid(nx,ny),tempGrid(nx,ny),bitmap(nx,ny))

! Set some grib reading properties
jpds = -1 ! PDS input to getgb
jgds = -1 ! GDS input to getgb
kpds = -1
kgds = -1
iunit=2 ! for unit of GRIB file
iout=3 ! for output GRIB file

! Read namelist containing list of files to average
open(1,file='namelist',status='old',action='read',position='rewind',iostat=stat)
! Did it open successfully?
if (stat .ne. 0) THEN
	print *, 'Problem reading namelist'
	STOP
endif

! Open grib file
call baopenw(iout,'out.grb',stat)
! Did it open successfully?
if (stat .ne. 0) STOP 'Problem opening grib file'


! Loop over each grib file in namelist, reading each in
numGridsRead=0
num=0
avgGrid=0
	read(1,fmt='(A)',iostat=stat) gribFile
if (stat .ne. 0) STOP "1, Error reading from file"

	! Open grib file
	call baopen(iunit,trim(gribFile),stat)
	! Did it open successfully?
	if (stat .ne. 0) STOP 'Problem opening grib file'

do

sfct=0
sfcrh=0
sfcp=0
t=0
rh=0
pseudop=0
precip=0 ! pseudo precip definition 1: no precipitation input for the reanalysis data

	! Read next line of namelist
read(1,fmt='(I4,3(I2))',iostat=stat) year,month,day,hour
	if (stat > 0) STOP "Error reading from file"
	if (stat < 0) EXIT ! End of file
print*,year,month,day,hour,gribFile


	! Read in grib data
j=-1
if (year > 2000) then  ! must be 0-99, not 1-100
        jpds(8) = year-2000
else
        jpds(8) = year-1900
endif
jpds(9)=month ! mon
jpds(10)=day ! day
jpds(11)=hour ! hour
jpds(13) = 1  ! time unit = hour

!  TMP:30-0 mb above gnd:kpds=11,116,7680:anl:"Temp. [K]
jpds(5)=11 ! indicator of parameter
jpds(6)=116 !type of level
jpds(7)=7680 ! height pressure
	CALL GETGB(iunit,0,nxny,j,jpds,jgds,numPtOut,K,KPDS,KGDS,LB,tempArray,stat)
	print*,'GETGB TMP:30-0 mb, K ',K,minval(temparray),maxval(temparray)
	print*,'stat ', stat
	sfct = reshape(tempArray,(/nx,ny/))



! RH:30-0 mb above gnd:kpds=52,116,7680:anl:"Relative humidity [%]
jpds(5)=52 ! indicator of parameter
jpds(6)=116 !type of level
jpds(7)=7680 ! height pressure
	CALL GETGB(iunit,0,nxny,j,jpds,jgds,numPtOut,K,KPDS,KGDS,LB,tempArray,stat)
	print*,'GETGB RH:30-0 mb, K ',K,minval(temparray),maxval(temparray)
	sfcrh = reshape(tempArray,(/nx,ny/))


! PRES:sfc:kpds=1,1,0:anl:"Pressure [Pa]
jpds(5)=1 ! indicator of parameter
jpds(6)=1 !type of level
jpds(7)=0 ! height pressure
	CALL GETGB(iunit,0,nxny,j,jpds,jgds,numPtOut,K,KPDS,KGDS,LB,tempArray,stat)
	print*,'GETGB PRES:sfc, K ',K,minval(temparray),maxval(temparray)
	sfcp = reshape(tempArray,(/nx,ny/))


! TMP:1000 mb:kpds=11,100,1000:anl:"Temp. [K]
jpds(5)=11 ! indicator of parameter
jpds(6)=100 !type of level
do ik=1,nz
jpds(7)=p(ik) ! height pressure
	CALL GETGB(iunit,0,nxny,j,jpds,jgds,numPtOut,K,KPDS,KGDS,LB,tempArray,stat)
        print*,'GETGB TMP: mb, K ',K,minval(temparray),maxval(temparray)
        t(:,:,ik) = reshape(tempArray,(/nx,ny/))
enddo


! RH:1000 mb:kpds=52,100,1000:anl:"Relative humidity [%]
jpds(5)=52 ! indicator of parameter
jpds(6)=100 !type of level
do ik=1,nz
jpds(7)=p(ik) ! height pressure
	CALL GETGB(iunit,0,nxny,j,jpds,jgds,numPtOut,K,KPDS,KGDS,LB,tempArray,stat)
        print*,'GETGB RH: mb, K ',K,minval(temparray),maxval(temparray)
        rh(:,:,ik) = reshape(tempArray,(/nx,ny/))
enddo


! PWAT:atmos col:kpds=54,200,0:anl:"Precipitable water [kg/m^2]
jpds(5)=54 ! indicator of parameter
jpds(6)=200 !type of level
jpds(7)=0 ! height pressure
        CALL GETGB(iunit,0,nxny,j,jpds,jgds,numPtOut,K,KPDS,KGDS,LB,tempArray,stat)
        print*,'GETGB PWAT:atmos, K ',K,minval(temparray),maxval(temparray)
        pwat = reshape(tempArray,(/nx,ny/))


!!!!!!!!!!!!!!! call pseudo precipitation program, elroy:/scratch/local/Reanalysis/Pseudo/anapseudo.f

        p0=p*100 ! convert to 'Pa'
!!! convert unit to standard unit
        sfcp=sfcp-30*100 ! minus 30 mb
        sfct=sfct-273.15 ! convert to 'C'
        sfcrh=sfcrh*0.01 ! convert to 0-1
        t=t-273.15  ! convert to 'C'
        rh=rh*0.01  ! convert to 0-1
        call pseudo(sfct,sfcrh,sfcp,t,rh,p0,precip,pseudop,nx,ny,nz) !calculate pseudo precipitation
!!!!!!!!!!!!!!!!
	numGridsRead=numGridsRead+1 ! increment number of grids successfully read in
        print*,'Pseudo precip, numGridsRead ',numGridsRead,minval(pseudop),maxval(pseudop)

	bitmap   = reshape(lb,(/nx,ny/))
	where (bitmap) avgGrid = pseudop
	where (bitmap) num = num + 1
	

! Make a new bitmap
where(num .eq. 0) bitmap = .FALSE.
where(num > 0) bitmap = .TRUE.

!----- Write data to a grib file -----!
! Adjust PDS
kpds(5)  = 255 ! user defined

! Reshape grids back to a 1d array
lb = reshape(bitmap,(/nxny/))
tempArray = reshape(avgGrid,(/nxny/))

stat=999

! Write to grib
call putgb(iout,nxny,kpds,kgds,lb,tempArray,stat)
! Did it write the data successfully?
if (stat .ne. 0) then
        print *, 'Problem writing grib data, error status code =',stat
        STOP
endif
print *, 'Stat is now',stat

enddo

	! Close grib file
	call baclose(iunit,stat)
	! Did it close successfully?
	if (stat .ne. 0) then
		print *, 'Problem closing grib file, status code =',stat
		STOP
	endif
close(1)




! Close grib file
call baclose(iout,stat)
! Did it close successfully?
if (stat .ne. 0) then
        print *, 'Problem closing grib file, status code =',stat
        STOP
endif

! Deallocate array space
deallocate(lb,tempArray,num,avgGrid,tempGrid,bitmap)



END PROGRAM




