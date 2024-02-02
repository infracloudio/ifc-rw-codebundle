#!/bin/bash

# Prerequisites
# 1) Please login to ecr using this command: aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <registry_url>

# Remove existing port-forward
kill -9 $(ps -ef | grep port-forward | awk 'NR==1 {print $2}')

# Delete old resources
kubectl delete -f ./create-mysql-sleep-conn-deployment.yaml  --ignore-not-found=true
kubectl delete -f ./runbook-svc.yaml --ignore-not-found=true
kubectl delete -f ./runbook-deployment.yaml --ignore-not-found=true

# Create sleep connections
kubectl apply -f ./create-mysql-sleep-conn-deployment.yaml
kubectl wait --for=condition=Ready pod -l app=create-mysql-sleep-connection

# Run runbook to kill the sleep connections
kubectl apply -f ./runbook-svc.yaml
kubectl apply -f ./runbook-deployment.yaml
kubectl wait --for=condition=Ready pod -l app=rds-mysql-connection-count-runbook

# port-forward rds-mysql-connection-count-runbook-svc
# kubectl port-forward svc/rds-mysql-connection-count-runbook-svc 3000:3000 


