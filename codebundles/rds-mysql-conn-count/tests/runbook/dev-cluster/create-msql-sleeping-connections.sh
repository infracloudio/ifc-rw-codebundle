#!/bin/bash

# MySQL connection details
MYSQL_USER="shipping"
MYSQL_PASSWORD="secret"
MYSQL_HOST="robotshopmysql.c5eo4uy8mys1.us-west-2.rds.amazonaws.com"

CONNECTIONS=30
SLEEP_TIMEOUT=260

for ((i=1;i<=$CONNECTIONS;i++))
do
    MYSQL_PWD="$MYSQL_PASSWORD" mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -N -s -e "SELECT SLEEP(${SLEEP_TIMEOUT});" &
done
