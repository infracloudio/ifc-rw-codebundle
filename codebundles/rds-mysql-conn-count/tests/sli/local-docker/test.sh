#!/bin/bash

# expose promethes endpoint on your localhost from dev-cluster
kubectl port-forward service/prom-... 9090:9090
# Run container
docker-compose up -d

# Run SLI
docker exec local-docker-rw-sli-test bash -c "ro /app/codecollection/codebundles/rds-mysql-conn-count/sli.robot && ls -R /robot_logs"

## Show browser URLs
echo <status page URL>
echo <log page URL>
