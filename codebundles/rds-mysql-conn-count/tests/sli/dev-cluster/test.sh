#!/bin/bash

# Prerequisites
# 1) Please login to ecr using this command: aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <registry_url>
# 2) Build and Push the image to ecr and update image in sli-deployment.yaml

NS=runwhen
PF_PORT=3001
SLI_NAME=rds-mysql-connection-count-sli

kubectl create ns ${NS} --dry-run=client -o yaml | kubectl apply -f -

# Remove existing port-forward
process_id=$(ps -ef | grep 'port-forward' | grep "${SLI_NANE}" | grep "${PF_PORT}" | awk '{print $2}')

if [ -z "$process_id" ]; then
    echo "No ${SLI_NAME} port-forward process found."
else
    echo "Killing ${SLI_NAME} port-forward with PID: $process_id"
    kill -9 $process_id
fi

# Remove old resources
kubectl delete -f sli-deployment.yaml --ignore-not-found=true -n ${NS}

# Deploy SLI test deployment
kubectl apply -f sli-deployment.yaml -n ${NS}
kubectl wait --for=condition=Ready pod -l app=${SLI_NAME} --timeout 2m0s -n ${NS}

kubectl exec deploy/${SLI_NAME} -n ${NS} -- ro /app/codecollection/codebundles/rds-mysql-conn-count/sli.robot

# Exposes SLI test deployment
kubectl port-forward deploy/${SLI_NAME} ${PF_PORT}:3000 -n ${NS} &

## Show browser URLs
printf "\n Open Status page http://localhost:${PF_PORT}/"
printf "\n See logs http://localhost:${PF_PORT}/rds-mysql-conn-count/sli-log.html\n"