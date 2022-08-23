       program print
       dimension clim(100)
       character*80 file
       
       file='/global/cdas/500HGT.FEB'
       nuc1=11
       open(unit=nuc1,file=file,form='unformatted',status='old')
       rewind (nuc1)

       ictl=2393
       jctl=0
       do n = 1, 10512
        read (nuc1) clim

        if (n.eq.ictl.and.jctl.le.10) then

c       write(6,999) ictl,clim(1),clim(2),clim(99),clim(100)
        write(6,999) ictl,(clim(j),j=10,90,10)
c       write(6,999) ictl,(clim(j),j=1,9)
        ictl=ictl+144
        jctl=jctl+1

        endif
       enddo
       rewind (nuc1)
       ictl=1238
       jctl=0
       do n = 1, 10512
        read (nuc1) clim

        if (n.eq.ictl.and.jctl.le.10) then

c       write(6,999) ictl,clim(1),clim(2),clim(99),clim(100)
        write(6,999) ictl,(clim(j),j=10,90,10)
c       write(6,999) ictl,(clim(j),j=1,9)
        ictl=ictl+144
        jctl=jctl+1

        endif
       enddo
       rewind (nuc1)
       ictl=2401
       jctl=0
       do n = 1, 10512
        read (nuc1) clim

        if (n.eq.ictl.and.jctl.le.10) then

c       write(6,999) ictl,clim(1),clim(2),clim(99),clim(100)
        write(6,999) ictl,(clim(j),j=10,90,10)
c       write(6,999) ictl,(clim(j),j=1,9)
        ictl=ictl+144
        jctl=jctl+1

        endif
       enddo
       rewind (nuc1)
       ictl=2411
       jctl=0
       do n = 1, 10512
        read (nuc1) clim

        if (n.eq.ictl.and.jctl.le.10) then

c       write(6,999) ictl,clim(1),clim(2),clim(99),clim(100)
        write(6,999) ictl,(clim(j),j=10,90,10)
c       write(6,999) ictl,(clim(j),j=1,9)
        ictl=ictl+144
        jctl=jctl+1

        endif
       enddo
       rewind (nuc1)
       ictl=2421
       jctl=0
       do n = 1, 10512
        read (nuc1) clim

        if (n.eq.ictl.and.jctl.le.10) then

c       write(6,999) ictl,clim(1),clim(2),clim(99),clim(100)
        write(6,999) ictl,(clim(j),j=10,90,10)
c       write(6,999) ictl,(clim(j),j=1,9)
        ictl=ictl+144
        jctl=jctl+1

        endif
       enddo

 999   format(i5,3x,9f8.1)

       stop
       end
