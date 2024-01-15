#!/bin/bash

GIT_TLD=`git rev-parse --show-toplevel`
source ${GIT_TLD}/.env

VALUES_FILE=${GIT_TLD}/setup/runwhen-local/helm/values.yaml

if [ -z "${RUNWHEN_PLATFORM_TOKEN}" ]; then
    echo "RUNWHEN_PLATFORM_TOKEN is not set in environment variables. Please export RUNWHEN_PLATFORM_TOKEN."
    exit 1
fi

helm repo add runwhen-contrib https://runwhen-contrib.github.io/helm-charts
helm repo update

# Install the RunWhen Local helm release 
helm upgrade --install  ${HELM_RELEASE_NAME} runwhen-contrib/runwhen-local \
    --set uploadInfo.token=${RUNWHEN_PLATFORM_TOKEN} \
    --set uploadInfo.workspaceOwnerEmail=${WORKSPACE_OWNER_EMAIL} \
     -f ${VALUES_FILE} -n ${NAMESPACE}

# Install RunWhen Istio Virtual Service
kubectl apply -f ${GIT_TLD}/setup/runwhen-local/istio/vs.yaml 