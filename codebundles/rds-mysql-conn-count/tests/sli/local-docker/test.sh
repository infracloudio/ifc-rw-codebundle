#!/bin/bash

export PROM_HOST="$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')/prometheus"

# Remove existing port-forward
kill -9 $(ps -ef | grep port-forward | awk 'NR==1 {print $2}')

# expose promethes endpoint on your localhost from dev-cluster
kubectl port-forward svc/prometheus-stack-kube-prom-prometheus 9090:9090 -n monitoring &

# Remove old containers
docker-compose down

# Build new containers
docker-compose build

# Run container
docker-compose up -d

# Run SLI
docker exec local-docker_rw-sli-test_1 bash -c "ro /app/codecollection/codebundles/rds-mysql-conn-count/sli.robot && ls -R /robot_logs"

## Show browser URLs
printf "\n Open Status page http://localhost:3000/"
printf "\n See logs http://localhost:3000/rds-mysql-conn-count/sli-log.html\n"
