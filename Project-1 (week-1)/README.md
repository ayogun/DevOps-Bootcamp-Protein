


## Backup.sh

This script backs up the home directory of every user in the machine. The name of the file is name of user and the time of back up. The backup directory is `/mnt` and there is a md5 file is included in order to make confirmation. The back up script is planned to be scheduled at 23:05 every day with the `crontab.txt` as a crontab file. Also it is planned to create a log file when it is worked last time as it is displayed below.


```bash

Example:  
backup_name: username_01011987_2201.tar.gz
md5_sum_file_name: username_01011987_2201.tar.gz.md5.txt
last_work_time: /tmp/yedekleme_scripti_son_calisma_saati.log

```

## Alert.sh

This script has planned to be schedully work every minute thanks to cron. It checks every minute if any of partitions or disks use exceed the 90% threshold value; and send an email to the specified user about alert. In my script it has been set as `yigitogun@gmail.com` but needs to be replaced according to user needs.








