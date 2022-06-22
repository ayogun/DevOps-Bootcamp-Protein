#!/bin/bash
###########################################################################
# Author  : Ali Yigit Ogun                                                |      
# Date    : 26.05.2022                                                    |
# Version : 0.1                                                           |
# Usage   : This script backsup everyfile under the home directory of     |
#	    each user and archive them in .tar.gz format.                 |
###########################################################################

#Variable declareation
NOW=$(date +"%m%d%Y_%H%M")
DST_DIR=/mnt
LOG_DIR=/tmp

#creating loop to access all users
for each in `ls -d /home/* | cut -d/ -f3`
do
	#checks whether the directory is present in /etc/passwd
	if grep -q $each /etc/passwd
		then
			#creating tar file for user
		tar -czf $DST_DIR/${each}_${NOW}.tar.gz /home/${each}	
			#generating an MD5 checksum
		sha512sum $DST_DIR/${each}_${NOW}.tar.gz \
		     	> $DST_DIR/${each}_${NOW}.tar.gz.md5.txt
	fi
done	

#generating log file regarding last execution time
touch $LOG_DIR/$NOW.log
