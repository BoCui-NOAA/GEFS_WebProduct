

RZDMDIR=/home/people/emc/www/htdocs/gmb/yluo/gif/thorpex

#gfile=NH500h_monthly_ac.gr

#gxgif -r -x 1100 -y 850 -i NH500h_monthly_ac.gr -o NH500h_monthly_ac_d5.gif
#gxgif -r -x 1100 -y 850 -i SH500h_monthly_ac.gr -o SH500h_monthly_ac_d5.gif

#ftpemcrzdm emcrzdm put $RZDMDIR $home/evrfy/monthly_grads NH500h_monthly_ac_d5.gif
#ftpemcrzdm emcrzdm put $RZDMDIR $home/evrfy/monthly_grads SH500h_monthly_ac_d5.gif

gfile=NH500h_monthly_ac.gr

gxgif -r -x 1100 -y 850 -i NH500h_monthly_ac.gr -o NH500h_monthly_ac_d5_20m.gif
gxgif -r -x 1100 -y 850 -i SH500h_monthly_ac.gr -o SH500h_monthly_ac_d5_20m.gif

ftpemcrzdm emcrzdm put $RZDMDIR $home/evrfy/monthly_grads NH500h_monthly_ac_d5_20m.gif
ftpemcrzdm emcrzdm put $RZDMDIR $home/evrfy/monthly_grads SH500h_monthly_ac_d5_20m.gif

gfile=NH500h_monthly_ac_d7.gr
#
gxgif -r -x 1100 -y 850 -i NH500h_monthly_ac_d7.gr -o NH500h_monthly_ac_d7_20m.gif
gxgif -r -x 1100 -y 850 -i SH500h_monthly_ac_d7.gr -o SH500h_monthly_ac_d7_20m.gif

ftpemcrzdm emcrzdm put $RZDMDIR $home/evrfy/monthly_grads NH500h_monthly_ac_d7_20m.gif
ftpemcrzdm emcrzdm put $RZDMDIR $home/evrfy/monthly_grads SH500h_monthly_ac_d7_20m.gif
