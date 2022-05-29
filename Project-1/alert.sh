#!/bin/bash

LIMIT=10
DISKS=$(df | grep '^/dev/sd' | awk -F' '  'int($5)>(0){printf "%s %d \n", $1, $5}')
ARG=$(echo $DISKS | wc -w)
HOST=$(hostname)
NOW=$(date)
SUBJECT="$HOSTNAM Disk Usage Alert: x used DISK USAGE ALERT: PERCENTused"
	#USED_AMOUNT=$line| awk '{print $5}' | cut -d% -f1
	#USED_DISK=$line | awk '{print $1}'
	for((i=1 ; i <=$ARG ; i++)) do
	PARTITION=$(echo $DISKS | cut -d" " -f $i)
	((i=i+1))
	USE=$(echo $DISKS | cut -d" " -f $i)
	SUBJECT="$HOST Disk Usage Alert: $USE% used"
	mailx -s "$SUBJECT" yigitogun@gmail.com << EOF
			The partition $PARTITION on $HOST has used: $USE% at $NOW
EOF
done

