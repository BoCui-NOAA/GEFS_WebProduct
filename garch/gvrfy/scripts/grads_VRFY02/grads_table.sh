#---------------- start cut here ----------------------------------------------
###############################################################################
############ GrADS PLOTTING SET UP TABLES FOR GLOBAL MODEL VERIFICATION #######
###############################################################################

###
### Modify this table according to your experiments
###

### 1. experiment period ( verified time, 100 days maxmum )
export VHOUR=                             ### default is 00 ( T00Z )  

### 2. experiment scores directory ( 6 experiments maximum )
###    leave blank for less than 6 experiments
export SDIR_1=$GLOBAL/vrfy                ### 1st experiment scores directory
export SDIR_2=$GLOBAL/vrfy                ### 2nd experiment scores directory
export SDIR_3=$GLOBAL/vrfy                ### 3rd experiment scores directory
export SDIR_4=$GLOBAL/vrfy                ### 4th experiment scores directory
export SDIR_5=$GLOBAL/vrfy                ### 5th experiment scores directory
export SDIR_6=$GLOBAL/vrfy                ### 6th experiment scores directory

### 3. files ( scores ) name ( default=SCORES, leave blank if you use default )
export SNAME=

### 4. experiment ID (better use one character only, e.g. a/b/c )
###                  ( up to 6 experiments maximum )
export exp_id_1=s                         ### 1st experiment ID
export exp_id_2=s                         ### 2nd experiment ID
export exp_id_3=s                         ### 3rd experiment ID
export exp_id_4=s                         ### 4th experiment ID
export exp_id_5=e                         ### 5th experiment ID
export exp_id_6=e                         ### 6th experiment ID

### 5. the length ( forecasting days default PFDAYS=5 ) for die-off diagram
###    PFDAYS= (5/6/7/8/10/12/15) only
export PFDAYS=15

############## GLOBAL MODEL PLOTTING SET UP TABLES #############################
#-------------- end cut here ---------------------------------------------------

