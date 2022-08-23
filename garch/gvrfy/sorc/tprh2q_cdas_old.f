c      parameter(imths=1,imthe=12)
       parameter(imths=1,imthe=1)
c
       parameter(idbug=1)
       parameter(idim=144,jdim=73,kdim=8)
c
       character*80 tfile,tifile,rfile,rifile,qfile
       dimension gridt(idim,jdim)
       dimension gridrh(idim,jdim)
       dimension gridq(idim,jdim)
       dimension deg(jdim)
       integer ilev(kdim)
       integer KPDS(25),KGDS(22)
       integer JPDS(25),JGDS(22)
       integer GETENV
       logical lbms(idim,jdim)
c
       data ilev/1000,925,850,700,600,500,400,300/
c
       IERR = GETENV("tfile",tfile)
       if(ierr.eq.0) print *,'error in getenv for tfile '
       write(*,*) "tfile= ",tfile
c
       IERR = GETENV("tifile",tifile)
       if(ierr.eq.0) print *,'error in getenv for tifile '
       write(*,*) "tifile= ",tifile
c
       IERR = GETENV("rfile",rfile)
       if(ierr.eq.0) print *,'error in getenv for rfile '
       write(*,*) "rfile= ",rfile
c
       IERR = GETENV("rifile",rifile)
       if(ierr.eq.0) print *,'error in getenv for rifile '
       write(*,*) "rifile= ",rifile
c
       IERR = GETENV("qfile",qfile)
       if(ierr.eq.0) print *,'error in getenv for qfile '
       write(*,*) "qfile= ",qfile
c
       do j=1,jdim
       deg(j)=90.-float(j-1)*2.5
       enddo
c
       call assign('assign -R')
       call assign('assign -s unblocked u:11')
       open(11,file=tfile,form='unformatted')
       call assign('assign -s unblocked u:12')
       open(12,file=tifile,form='unformatted')
       call assign('assign -s unblocked u:21')
       open(21,file=rfile,form='unformatted')
       call assign('assign -s unblocked u:22')
       open(22,file=rifile,form='unformatted')
       call assign('assign -s unblocked u:51')
       open(51,file=qfile,form='unformatted')
c
       NT=-2
       NR=-2
       do imth=imths,imthe
c
       do nl=1,kdim
c
       kpds7=ilev(nl)
       P=float(kpds7)
c
c..   get temp first
       NT=NT+1
       do k=1,25
       JPDS(k)=-1
       enddo
       JPDS(5)=11
       JPDS(7)=kpds7
       JPDS(9)=imth
       do k=1,22
       JGDS(k)=-1
       enddo
       CALL GETGB(11,12,idim*jdim,NT,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,gridt,IRET)
       if(iret.ne.0) then
       print *,' temp error in GETGB for rc = ',iret,jpds
       call abort
       endif
c
c..   get rh next
       NR=NR+1
       do k=1,25
       JPDS(k)=-1
       enddo
       JPDS(5)=52
       JPDS(7)=kpds7
       JPDS(9)=imth
       do k=1,22
       JGDS(k)=-1
       enddo
       CALL GETGB(21,22,idim*jdim,NR,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,gridrh,IRET)
       if(iret.ne.0) then
       print *,'rh error in GETGB for rc = ',iret,jpds
       call abort
       endif
c
c..   compute q now..in g/Kg
       do j=1,jdim
       do i=1,idim
       gridq(i,j)=0.
       T=gridt(i,j)
       RH=gridrh(i,j)/100.
       if(RH .gt. 0.) then
       Q=TPRH2Q(T,P,RH)
       gridq(i,j)=Q*1000
       endif
       enddo
       enddo
c
       if(idbug.eq.1) then
       CALL GRIDAV(gridt,IDIM,JDIM,DEG,GLOBt)
       CALL GRIDAV(gridrh,IDIM,JDIM,DEG,GLOBrh)
       CALL GRIDAV(gridq,IDIM,JDIM,DEG,GLOBq)
       print *,imth,' level ',kpds7,' ',globt,globrh,globq
       endif
c
c...  now write out gribbed q...
       KPDS(5)=51
       KPDS(22)=6
       CALL PUTGB(51,NDATA,KPDS,KGDS,LBMS,gridq,IRET)
       if(iret.ne.0) then
       print *,' error in PUTGB for iret ',iret,kpds
       call abort
       endif
c
c  end level-loop
       enddo
c  end month-loop
       enddo
c
       stop
       end
