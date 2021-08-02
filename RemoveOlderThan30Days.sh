#!/bin/bash

#Variables
TIME=$(date +"%Y-%m-%d_%H-%M-%S")
CURRENT_TIME=$TIME
CURRENT_USER=`stat -f "%Su" /dev/console`
  #Folder with files to be deleted and how many days old
FILES_FOLDER_DIR="/Users/${CURRENT_USER}/Downloads"
DAYS_OLD=+30
  #Log Directories
LOG_FOLDER_DIR="/Library/Logs/CustomerDataRemoval/"
LOG_DIR=$LOG_FOLDER_DIR$CURRENT_TIME.log

      ##LOGGING DESIGNED TO BE RAN AS ROOT TO ACCESS /LIBRARY/LOGS SYSTEM FILES##

#Makes directory for logs if doesn't exist
sudo mkdir -p /Library/Logs/CustomerDataRemoval

#Lists files
echo "Files in $FILES_FOLDER_DIR older than $DAYS_OLD days removed and listed in: $LOG_DIR"
echo "Files older than ${DAYS_OLD} to be deleted:"
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD | wc -l | sed -e 's/^[ \t]*//'
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD

  #Logs files
scutil --get LocalHostName > $LOG_DIR
echo "Files deleted:" >> $LOG_DIR
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD | wc -l | sed -e 's/^[ \t]*//' >> $LOG_DIR
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD >> $LOG_DIR

  #Deletes files
sudo find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD -delete;

  #Logs files not deleted
echo "Files older than $DAYS_OLD days old remaining:" >> $LOG_DIR
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD | wc -l | sed -e 's/^[ \t]*//' >> $LOG_DIR
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD >> $LOG_DIR

  #Echos files not deleted
echo "Files older than $DAYS_OLD days old remaining:"
find $FILES_FOLDER_DIR -name "*" -type f -mtime $DAYS_OLD | wc -l | sed -e 's/^[ \t]*//'

exit 0