#!/bin/bash

# Prerequisites
# 1) Please login to ecr using this command: aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <registry_url>
# 2) Build and Push the image to ecr and update image in runbook-deployment.yaml

NS=codebundles

kubectl create ns ${NS} --dry-run=client -o yaml | kubectl apply -f -

# Remove existing port-forward
process_id=$(ps -ef | grep '[p]ort-forward' | awk '{print $2}')

if [ -z "$process_id" ]; then
    echo "No process found with the name 'port-forward'."
else
    echo "Killing process with PID: $process_id"
    kill -9 $process_id
fi

# Delete old resources
kubectl delete -f ./create-mysql-sleep-conn-deployment.yaml  --ignore-not-found=true -n ${NS}
kubectl delete -f ./runbook-deployment.yaml --ignore-not-found=true -n ${NS}

# Create sleep connections
kubectl apply -f ./create-mysql-sleep-conn-deployment.yaml -n ${NS}
kubectl wait --for=condition=Ready pod -l app=create-mysql-sleep-connection -n ${NS}

# Run runbook to kill the sleep connections
kubectl apply -f ./runbook-deployment.yaml -n ${NS}
kubectl wait --for=condition=Ready pod -l app=rds-mysql-connection-count-runbook --timeout 2m0s -n ${NS}

# port-forward rds-mysql-connection-count-runbook-svc
kubectl port-forward deploy/rds-mysql-connection-count-runbook 3000:3000 -n ${NS} & 

## Show browser URLs
printf "\n Open Status page http://localhost:3000/"
printf "\n See logs http://localhost:3000/rds-mysql-conn-count/runbook-log.html"


