#!/bin/bash

# Prerequisites
# 1) Please login to ecr using this command: aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <registry_url>
# 2) Build and Push the image to ecr and update image in runbook-deployment.yaml

NS=runwhen
PF_PORT=3002
RUNBOOK_NAME=rds-mysql-connection-count-runbook

kubectl create ns ${NS} --dry-run=client -o yaml | kubectl apply -f -

# Remove existing port-forward
process_id=$(ps -ef | grep 'port-forward' | grep "${RUNBOOK_NAME}" | grep "${PF_PORT}" | awk '{print $2}')

if [ -z "$process_id" ]; then
    echo "No ${RUNBOOK_NAME} port-forward process found."
else
    echo "Killing ${RUNBOOK_NAME} port-forward with PID: $process_id"
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
kubectl wait --for=condition=Ready pod -l app=${RUNBOOK_NAME} --timeout 2m0s -n ${NS}

kubectl exec deploy/${RUNBOOK_NAME} -n ${NS} -- ro /app/codecollection/codebundles/rds-mysql-conn-count/runbook.robot

# Exposes runbook test deployment
kubectl port-forward deploy/${RUNBOOK_NAME} ${PF_PORT}:3000 -n ${NS} & 

## Show browser URLs
printf "\n Open Status page http://localhost:${PF_PORT}/"
printf "\n See logs http://localhost:${PF_PORT}/rds-mysql-conn-count/runbook-log.html\n"


