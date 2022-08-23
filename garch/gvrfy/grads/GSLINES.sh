
if [ $# -lt 2 ]; then
   echo "Usage: $0 need lines (how may lines ) and plotting days input "
   exit 8
fi

NLINES=$1
PFDAYS=$2

export GDIR=$GDIR;pwd $GDIR

if [ $NLINES -eq 1 ]; then
sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*LINES/lines=1/"                 \
    -e "s/*ZISTFDAY/istday=1/"             \
    -e "s/*ZIEDFDAY/iedday=6/"             \
    -e "s/*DVAR1/'d 'var'.1'/"            \
    -e "s/*DRAW1/'draw string 8.6 3.0 PP1='pr1vlev/" \
    -e "s/*VISTFDAY/istday=1/"             \
    -e "s/*VIEDFDAY/iedday=3/"             \
    -e "s/*VDRAW1/'draw string 2.2 7.6 PP1='pr1vlev/" \
    -e "s/*TDRAW1/'draw string 0.1 8.2 PP1='pr1vlev/" \
    -e "s/*BDRAW1/'draw string 0.1 4.4 PP1='pr1vlev/" \
    $SHOME/Yan.Luo/gvrfy/grads/grads_lines_pub.gs  >$GDIR/grads_lines.gs

sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*LINES/lines=1/"                 \
    -e "s/*FDAYS/fdays=$PFDAYS/"           \
    -e "s/*DVAR1/'d t1'frms''/"            \
    $SHOME/Yan.Luo/gvrfy/grads/grads_die_pub.gs  >$GDIR/grads_die.gs

elif [ $NLINES -eq 2 ]; then
sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*LINES/lines=2/"                 \
    -e "s/*ZISTFDAY/istday=1/"             \
    -e "s/*ZIEDFDAY/iedday=6/"             \
    -e "s/*DVAR1/'d 'var'.1'/"            \
    -e "s/*DVAR2/'d 'var'.2'/"            \
    -e "s/*DRAW1/'draw string 8.6 3.3 PP1='pr1vlev/" \
    -e "s/*DRAW2/'draw string 8.6 3.0 PP2='pr2vlev/" \
    -e "s/*VISTFDAY/istday=1/"             \
    -e "s/*VIEDFDAY/iedday=3/"             \
    -e "s/*VDRAW1/'draw string 2.2 7.6 PP1='pr1vlev/" \
    -e "s/*VDRAW2/'draw string 2.2 7.3 PP2='pr2vlev/" \
    -e "s/*TDRAW1/'draw string 0.1 8.2 PP1='pr1vlev/" \
    -e "s/*TDRAW2/'draw string 0.1 7.9 PP2='pr2vlev/" \
    -e "s/*BDRAW1/'draw string 0.1 4.4 PP1='pr1vlev/" \
    -e "s/*BDRAW2/'draw string 0.1 4.1 PP2='pr2vlev/" \
    $SHOME/Yan.Luo/gvrfy/grads/grads_lines_pub_new.gs  >$GDIR/grads_lines.gs

sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*LINES/lines=2/"                 \
    -e "s/*FDAYS/fdays=$PFDAYS/"           \
    -e "s/*DVAR1/'d t1'frms''/"            \
    -e "s/*DVAR2/'d t2'frms''/"            \
    $SHOME/Yan.Luo/gvrfy/grads/grads_die_pub.gs  >$GDIR/grads_die.gs

elif [ $NLINES -eq 3 ]; then
sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*LINES/lines=3/"                 \
    -e "s/*ZISTFDAY/istday=1/"             \
    -e "s/*ZIEDFDAY/iedday=6/"             \
    -e "s/*DVAR1/'d 'var'.1'/"            \
    -e "s/*DVAR2/'d 'var'.2'/"            \
    -e "s/*DVAR3/'d 'var'.3'/"            \
    -e "s/*DRAW1/'draw string 8.6 3.6 PP1='pr1vlev/" \
    -e "s/*DRAW2/'draw string 8.6 3.3 PP2='pr2vlev/" \
    -e "s/*DRAW3/'draw string 8.6 3.0 PP3='pr3vlev/" \
    -e "s/*VISTFDAY/istday=1/"             \
    -e "s/*VIEDFDAY/iedday=3/"             \
    -e "s/*VDRAW1/'draw string 2.2 7.6 PP1='pr1vlev/" \
    -e "s/*VDRAW2/'draw string 2.2 7.3 PP2='pr2vlev/" \
    -e "s/*VDRAW3/'draw string 2.2 7.0 PP3='pr3vlev/" \
    -e "s/*TDRAW1/'draw string 0.1 8.2 PP1='pr1vlev/" \
    -e "s/*TDRAW2/'draw string 0.1 7.9 PP2='pr2vlev/" \
    -e "s/*TDRAW3/'draw string 0.1 7.6 PP3='pr3vlev/" \
    -e "s/*BDRAW1/'draw string 0.1 4.4 PP1='pr1vlev/" \
    -e "s/*BDRAW2/'draw string 0.1 4.1 PP2='pr2vlev/" \
    -e "s/*BDRAW3/'draw string 0.1 3.8 PP3='pr3vlev/" \
    $SHOME/Yan.Luo/gvrfy/grads/grads_lines_pub_new.gs  >$GDIR/grads_lines.gs

sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*LINES/lines=3/"                 \
    -e "s/*FDAYS/fdays=$PFDAYS/"           \
    -e "s/*DVAR1/'d t1'frms''/"            \
    -e "s/*DVAR2/'d t2'frms''/"            \
    -e "s/*DVAR3/'d t3'frms''/"            \
    $SHOME/Yan.Luo/gvrfy/grads/grads_die_pub.gs  >$GDIR/grads_die.gs

elif [ $NLINES -eq 4 ]; then
sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*OPENFILE4/'open prEXPID4.ctl'/" \
    -e "s/*LINES/lines=4/"                 \
    -e "s/*ZISTFDAY/istday=1/"             \
    -e "s/*ZIEDFDAY/iedday=6/"             \
    -e "s/*DVAR1/'d 'var'.1'/"            \
    -e "s/*DVAR2/'d 'var'.2'/"            \
    -e "s/*DVAR3/'d 'var'.3'/"            \
    -e "s/*DVAR4/'d 'var'.4'/"            \
    -e "s/*DRAW1/'draw string 0.1 5.2 PP1='pr1vlev/" \
    -e "s/*DRAW2/'draw string 0.1 4.9 PP2='pr2vlev/" \
    -e "s/*DRAW3/'draw string 0.1 4.6 PP3='pr3vlev/" \
    -e "s/*DRAW4/'draw string 0.1 4.3 PP4='pr4vlev/" \
    -e "s/*VISTFDAY/istday=1/"             \
    -e "s/*VIEDFDAY/iedday=3/"             \
    -e "s/*VDRAW1/'draw string 2.2 7.6 PP1='pr1vlev/" \
    -e "s/*VDRAW2/'draw string 2.2 7.3 PP2='pr2vlev/" \
    -e "s/*VDRAW3/'draw string 2.2 7.0 PP3='pr3vlev/" \
    -e "s/*VDRAW4/'draw string 2.2 6.7 PP4='pr4vlev/" \
    -e "s/*TDRAW1/'draw string 0.1 8.2 PP1='pr1vlev/" \
    -e "s/*TDRAW2/'draw string 0.1 7.9 PP2='pr2vlev/" \
    -e "s/*TDRAW3/'draw string 0.1 7.6 PP3='pr3vlev/" \
    -e "s/*TDRAW4/'draw string 0.1 7.3 PP4='pr4vlev/" \
    -e "s/*BDRAW1/'draw string 0.1 4.4 PP1='pr1vlev/" \
    -e "s/*BDRAW2/'draw string 0.1 4.1 PP2='pr2vlev/" \
    -e "s/*BDRAW3/'draw string 0.1 3.8 PP3='pr3vlev/" \
    -e "s/*BDRAW4/'draw string 0.1 3.5 PP4='pr4vlev/" \
    $SHOME/Yan.Luo/gvrfy/grads/grads_lines_pub_new.gs  >$GDIR/grads_lines.gs

sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*OPENFILE4/'open prEXPID4.ctl'/" \
    -e "s/*LINES/lines=4/"                 \
    -e "s/*FDAYS/fdays=$PFDAYS/"           \
    -e "s/*DVAR1/'d t1'frms''/"            \
    -e "s/*DVAR2/'d t2'frms''/"            \
    -e "s/*DVAR3/'d t3'frms''/"            \
    -e "s/*DVAR4/'d t4'frms''/"            \
    $SHOME/Yan.Luo/gvrfy/grads/grads_die_pub.gs  >$GDIR/grads_die.gs
#   $SHOME/Yan.Luo/gvrfy/grads/grads_die_VRFY03.gs  >$GDIR/grads_die.gs

elif [ $NLINES -eq 5 ]; then
sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*OPENFILE4/'open prEXPID4.ctl'/" \
    -e "s/*OPENFILE5/'open prEXPID5.ctl'/" \
    -e "s/*LINES/lines=5/"                 \
    -e "s/*ZISTFDAY/istday=1/"             \
    -e "s/*ZIEDFDAY/iedday=6/"             \
    -e "s/*DVAR1/'d 'var'.1'/"            \
    -e "s/*DVAR2/'d 'var'.2'/"            \
    -e "s/*DVAR3/'d 'var'.3'/"            \
    -e "s/*DVAR4/'d 'var'.4'/"            \
    -e "s/*DVAR5/'d 'var'.5'/"            \
    -e "s/*DRAW1/'draw string 8.6 4.2 PP1='pr1vlev/" \
    -e "s/*DRAW2/'draw string 8.6 3.9 PP2='pr2vlev/" \
    -e "s/*DRAW3/'draw string 8.6 3.6 PP3='pr3vlev/" \
    -e "s/*DRAW4/'draw string 8.6 3.3 PP4='pr4vlev/" \
    -e "s/*DRAW5/'draw string 8.6 3.0 PP5='pr5vlev/" \
    -e "s/*VISTFDAY/istday=1/"             \
    -e "s/*VIEDFDAY/iedday=3/"             \
    -e "s/*VDRAW1/'draw string 2.2 7.6 PP1='pr1vlev/" \
    -e "s/*VDRAW2/'draw string 2.2 7.3 PP2='pr2vlev/" \
    -e "s/*VDRAW3/'draw string 2.2 7.0 PP3='pr3vlev/" \
    -e "s/*VDRAW4/'draw string 2.2 6.7 PP4='pr4vlev/" \
    -e "s/*VDRAW5/'draw string 2.2 6.4 PP5='pr5vlev/" \
    -e "s/*TDRAW1/'draw string 0.1 8.2 PP1='pr1vlev/" \
    -e "s/*TDRAW2/'draw string 0.1 7.9 PP2='pr2vlev/" \
    -e "s/*TDRAW3/'draw string 0.1 7.6 PP3='pr3vlev/" \
    -e "s/*TDRAW4/'draw string 0.1 7.3 PP4='pr4vlev/" \
    -e "s/*TDRAW5/'draw string 0.1 7.0 PP5='pr5vlev/" \
    -e "s/*BDRAW1/'draw string 0.1 4.4 PP1='pr1vlev/" \
    -e "s/*BDRAW2/'draw string 0.1 4.1 PP2='pr2vlev/" \
    -e "s/*BDRAW3/'draw string 0.1 3.8 PP3='pr3vlev/" \
    -e "s/*BDRAW4/'draw string 0.1 3.5 PP4='pr4vlev/" \
    -e "s/*BDRAW5/'draw string 0.1 3.2 PP5='pr5vlev/" \
    $SHOME/Yan.Luo/gvrfy/grads/grads_lines_pub_new.gs  >$GDIR/grads_lines.gs

sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*OPENFILE4/'open prEXPID4.ctl'/" \
    -e "s/*OPENFILE5/'open prEXPID5.ctl'/" \
    -e "s/*LINES/lines=5/"                 \
    -e "s/*FDAYS/fdays=$PFDAYS/"           \
    -e "s/*DVAR1/'d t1'frms''/"            \
    -e "s/*DVAR2/'d t2'frms''/"            \
    -e "s/*DVAR3/'d t3'frms''/"            \
    -e "s/*DVAR4/'d t4'frms''/"            \
    -e "s/*DVAR5/'d t5'frms''/"            \
    $SHOME/Yan.Luo/gvrfy/grads/grads_die_pub.gs  >$GDIR/grads_die.gs

elif [ $NLINES -eq 6 ]; then
sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*OPENFILE4/'open prEXPID4.ctl'/" \
    -e "s/*OPENFILE5/'open prEXPID5.ctl'/" \
    -e "s/*OPENFILE6/'open prEXPID6.ctl'/" \
    -e "s/*LINES/lines=6/"                 \
    -e "s/*ZISTFDAY/istday=1/"             \
    -e "s/*ZIEDFDAY/iedday=6/"             \
    -e "s/*DVAR1/'d 'var'.1'/"            \
    -e "s/*DVAR2/'d 'var'.2'/"            \
    -e "s/*DVAR3/'d 'var'.3'/"            \
    -e "s/*DVAR4/'d 'var'.4'/"            \
    -e "s/*DVAR5/'d 'var'.5'/"            \
    -e "s/*DVAR6/'d 'var'.6'/"            \
    -e "s/*DRAW1/'draw string 0.1 5.2 PP1='pr1vlev/" \
    -e "s/*DRAW2/'draw string 0.1 4.9 PP2='pr2vlev/" \
    -e "s/*DRAW3/'draw string 0.1 4.6 PP3='pr3vlev/" \
    -e "s/*DRAW4/'draw string 0.1 4.3 PP4='pr4vlev/" \
    -e "s/*DRAW5/'draw string 0.1 4.0 PP5='pr5vlev/" \
    -e "s/*DRAW6/'draw string 0.1 3.7 PP6='pr6vlev/" \
    -e "s/*VISTFDAY/istday=1/"             \
    -e "s/*VIEDFDAY/iedday=3/"             \
    -e "s/*VDRAW1/'draw string 2.2 7.6 PP1='pr1vlev/" \
    -e "s/*VDRAW2/'draw string 2.2 7.3 PP2='pr2vlev/" \
    -e "s/*VDRAW3/'draw string 2.2 7.0 PP3='pr3vlev/" \
    -e "s/*VDRAW4/'draw string 2.2 6.7 PP4='pr4vlev/" \
    -e "s/*VDRAW5/'draw string 2.2 6.4 PP5='pr5vlev/" \
    -e "s/*VDRAW6/'draw string 2.2 6.3 PP6='pr6vlev/" \
    -e "s/*TDRAW1/'draw string 0.1 8.2 PP1='pr1vlev/" \
    -e "s/*TDRAW2/'draw string 0.1 7.9 PP2='pr2vlev/" \
    -e "s/*TDRAW3/'draw string 0.1 7.6 PP3='pr3vlev/" \
    -e "s/*TDRAW4/'draw string 0.1 7.3 PP4='pr4vlev/" \
    -e "s/*TDRAW5/'draw string 0.1 7.0 PP5='pr5vlev/" \
    -e "s/*TDRAW6/'draw string 0.1 6.7 PP6='pr6vlev/" \
    -e "s/*BDRAW1/'draw string 0.1 4.4 PP1='pr1vlev/" \
    -e "s/*BDRAW2/'draw string 0.1 4.1 PP2='pr2vlev/" \
    -e "s/*BDRAW3/'draw string 0.1 3.8 PP3='pr3vlev/" \
    -e "s/*BDRAW4/'draw string 0.1 3.5 PP4='pr4vlev/" \
    -e "s/*BDRAW5/'draw string 0.1 3.2 PP5='pr5vlev/" \
    -e "s/*BDRAW6/'draw string 0.1 2.9 PP6='pr6vlev/" \
    $SHOME/Yan.Luo/gvrfy/grads/grads_lines_pub_new.gs  >$GDIR/grads_lines.gs

sed -e "s/*OPENFILE1/'open prEXPID1.ctl'/" \
    -e "s/*OPENFILE2/'open prEXPID2.ctl'/" \
    -e "s/*OPENFILE3/'open prEXPID3.ctl'/" \
    -e "s/*OPENFILE4/'open prEXPID4.ctl'/" \
    -e "s/*OPENFILE5/'open prEXPID5.ctl'/" \
    -e "s/*OPENFILE6/'open prEXPID6.ctl'/" \
    -e "s/*LINES/lines=6/"                 \
    -e "s/*FDAYS/fdays=$PFDAYS/"           \
    -e "s/*DVAR1/'d t1'frms''/"            \
    -e "s/*DVAR2/'d t2'frms''/"            \
    -e "s/*DVAR3/'d t3'frms''/"            \
    -e "s/*DVAR4/'d t4'frms''/"            \
    -e "s/*DVAR5/'d t5'frms''/"            \
    -e "s/*DVAR6/'d t6'frms''/"            \
    $SHOME/Yan.Luo/gvrfy/grads/grads_die_pub.gs  >$GDIR/grads_die.gs

fi
