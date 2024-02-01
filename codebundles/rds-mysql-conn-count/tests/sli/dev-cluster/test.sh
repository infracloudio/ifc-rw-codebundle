#!/bin/bash

# Deploy SLI test deployment
kubectl apply -f sli-deployment.yaml
# Exposes SLI test deployment

## Show browser URLs
echo <status page URL>
echo <log page URL>