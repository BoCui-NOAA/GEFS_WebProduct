

RZDMDIR=/home/people/emc/www/htdocs/gmb/yzhu/gif/thorpex
gfile=NH500h_monthly_rpss_eval.gr

gxgif -r -x 1100 -y 850 -i $gfile -o NH500h_monthly_rpss_eval.gif

ftprzdm rzdm put $RZDMDIR $HOME/eprob/monthly_grads NH500h_monthly_rpss_eval.gif
