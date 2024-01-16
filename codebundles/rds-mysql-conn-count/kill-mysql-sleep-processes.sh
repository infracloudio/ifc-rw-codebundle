#!/bin/bash

# MySQL connection details
MYSQL_USER="admin"
MYSQL_PASSWORD="docdb3421z"
MYSQL_HOST="robotshopmysql.cn9m6m4s8zo0.us-west-2.rds.amazonaws.com"
PROCESS_USER="shipping"
echo $MYSQL_USER_ENV
echo $MYSQL_PASSWORD_ENV
echo $MYSQL_HOST_ENV
echo $PROCESS_USER_ENV

# Get process list IDs
PROCESS_IDS=$(MYSQL_PWD="$MYSQL_PASSWORD" mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -N -s -e "SELECT ID FROM INFORMATION_SCHEMA.PROCESSLIST WHERE USER='shipping'")

for ID in $PROCESS_IDS; do 
    MYSQL_PWD="$MYSQL_PASSWORD" mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -e "CALL mysql.rds_kill($ID)"
    echo "Terminated connection with ID $ID for user 'shipping'"
done