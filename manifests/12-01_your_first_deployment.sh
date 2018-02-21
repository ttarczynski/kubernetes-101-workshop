#!/bin/bash

set -x

kubectl run nginx --image=nginx:1.7.12
read -p "Continue?"
kubectl get deployments nginx
read -p "Continue?"

# Deployment internals

# see how label selector is configured:
kubectl get deployments nginx -o jsonpath --template {.spec.selector.matchLabels}
echo
read -p "Continue?"

# dislpay the corresponding replicaset:
kubectl get replicasets --selector=run=nginx
read -p "Continue?"

# scale the deployment:
kubectl scale deployments nginx --replicas=2
read -p "Continue?"

# observe relsults on replicaset level:
kubectl get replicasets --selector=run=nginx
read -p "Continue?"

# scale the replicaset
NGINX_RS=$(kubectl get replicaset --selector=run=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl scale replicaset $NGINX_RS --replicas=1
read -p "Continue?"

# observe relsults on replicaset level:
kubectl get replicasets --selector=run=nginx
read -p "Continue?"

# describe the replicaset and check envents list:
kubectl describe replicaset $NGINX_RS
read -p "Continue?"

# describe the deployment and check events list:
$ kubectl describe deployment nginx
read -p "Continue?"
