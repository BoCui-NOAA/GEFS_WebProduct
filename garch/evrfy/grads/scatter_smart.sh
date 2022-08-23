
file=dat.14mnh
echo `scatter.sh 20000701 20000731 | grep Result | awk '{print $4}' ` >$file  
echo `scatter.sh 20000801 20000831 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20000901 20000930 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20001001 20001031 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20001101 20001130 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20001201 20001231 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010101 20010131 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010201 20010228 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010301 20010331 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010401 20010430 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010501 20010531 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010601 20010630 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010701 20010731 | grep Result | awk '{print $4}' ` >>$file    
echo `scatter.sh 20010801 20010831 | grep Result | awk '{print $4}' ` >>$file    
