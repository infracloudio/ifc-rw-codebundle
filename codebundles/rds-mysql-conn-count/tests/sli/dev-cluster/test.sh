#!/bin/bash

# Remove existing port-forward
kill -9 $(ps -ef | grep port-forward | awk 'NR==1 {print $2}')

# Remove old resources
kubectl delete -f sli-deployment.yaml
kubectl delete -f ./sli-svc.yaml

# Deploy SLI test deployment
kubectl apply -f sli-deployment.yaml
kubectl apply -f ./sli-svc.yaml

# Exposes SLI test deployment
kubectl port-forward svc/rds-mysql-connection-count-sli-svc 3000:3000 &

## Show browser URLs
printf "\n Open Status page http://localhost:3000/"
printf "\n See logs http://localhost:3000/rds-mysql-conn-count/sli-log.html\n"