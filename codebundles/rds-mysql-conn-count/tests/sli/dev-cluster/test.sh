#!/bin/bash

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

# Remove old resources
kubectl delete -f sli-deployment.yaml --ignore-not-found=true -n ${NS}

# Deploy SLI test deployment
kubectl apply -f sli-deployment.yaml -n ${NS}
kubectl wait --for=condition=Ready pod -l app=rds-mysql-connection-count-sli --timeout 2m0s -n ${NS}

# Exposes SLI test deployment
kubectl port-forward deploy/rds-mysql-connection-count-sli 3000:3000 -n ${NS} &

## Show browser URLs
printf "\n Open Status page http://localhost:3000/"
printf "\n See logs http://localhost:3000/rds-mysql-conn-count/sli-log.html\n"