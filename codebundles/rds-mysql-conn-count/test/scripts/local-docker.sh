#!/bin/bash

# Build Image
docker build --tag runwhen  . --no-cache

# Run container
docker run --rm -d -p 3000:3000 --name rds-codecollection \
--network="host" \
-e ENV_PROMETHEUS_HOST="http://af2ee8b74f89e4f8a83cd53d3745ccdc-1654255243.us-west-2.elb.amazonaws.com/prometheus/api/v1" \
-e ENV_QUERY="aws_rds_database_connections_average{dimension_DBInstanceIdentifier=\"robotshopmysql\"} > 1" \
-e MYSQL_USER="admin" \
-e MYSQL_PASSWORD_ENV="<password>" \
-e MYSQL_HOST="robotshopmysql.c9m6m4s8zo0.us-west-2.rds.amazonaws.com" \
-e PROCESS_USER="shipping" \
-e TRANSFORM=Raw \
-e RW_PATH_TO_ROBOT="/app/codecollection/codebundles/rds-mysql-conn-count/runbook.robot" \
runwhen:latest

# Run SLI
docker exec rds-codecollection bash -c "ro /app/codecollection/codebundles/rds-mysql-conn-count/sli.robot && ls -R /robot_logs"

# Run runbook
docker exec rds-codecollection bash -c "ro /app/codecollection/codebundles/rds-mysql-conn-count/runbook.robot && ls -R /robot_logs"