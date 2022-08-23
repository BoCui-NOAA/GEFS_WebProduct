
for dd in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
do

gxps -c -i gmeta$dd -o tmp$dd.ps
gxgif -r -i gmeta$dd -o reliability$dd.gif

lpr -P phaser3 tmp$dd.ps

done

