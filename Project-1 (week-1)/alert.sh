#!/bin/bash
###########################################################################
# Author  : Ali Yigit Ogun                                                |      
# Date    : 26.05.2022                                                    |
# Version : 0.1                                                           |
# Usage   : This script alerts the specified emmail owner in case of      |
#	    any of partitions or dısks are occupıed more than %90.        |
###########################################################################

#Variables are declared
#Limit has been set to 90 arbitrarily.
LIMIT=90

#Disks and partitions with their use as percentage are displayed.
#We grep only ones which includes /dev/sd in order to grep disks and partitions.
DISKS=$(df | grep '^/dev/sd' | awk -F' '  'int($5)>(90){printf "%s %d \n", $1, $5}')

#Number of arguments are counted in order to use it in for loop.
ARG=$(echo $DISKS | wc -w)

#Hostname and date are collected in order to use in email content.
HOST=$(hostname)
NOW=$(date)
	
	#Looping through arguments to send e-mail seperately for each disks and partitions.
	for((i=1 ; i <=$ARG ; i++)) do
	PARTITION=$(echo $DISKS | cut -d" " -f $i)
	((i=i+1))
	USE=$(echo $DISKS | cut -d" " -f $i)
	SUBJECT="$HOST Disk Usage Alert: $USE% used"
	mail -s "$SUBJECT" yigitogun@gmail.com << EOF
			The partition $PARTITION on $HOST has used: $USE% at $NOW
EOF
done

