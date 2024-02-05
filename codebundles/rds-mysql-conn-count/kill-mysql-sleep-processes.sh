#!/bin/bash

# Get process list IDs
PROCESS_IDS=$(MYSQL_PWD="$MYSQL_PASSWORD" mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -N -s -e "SELECT ID FROM INFORMATION_SCHEMA.PROCESSLIST WHERE USER='$PROCESS_USER'")

if [ $? -ne 0 ]; then
    echo "Error connecting to MySQL"
    exit 1
fi

for ID in $PROCESS_IDS; do 
    MYSQL_PWD="$MYSQL_PASSWORD" mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -e "CALL mysql.rds_kill($ID)"
    echo "Terminated connection with ID $ID for user 'shipping'"
done