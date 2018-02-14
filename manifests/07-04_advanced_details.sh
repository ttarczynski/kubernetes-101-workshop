#!/bin/bash

set -x

# Endpoints
echo "Chapter 07-04 – Endpoints"

kubectl describe endpoints alpaca-prod
sleep 5
kubectl get endpoints alpaca-prod
sleep 5
kubectl get endpoints alpaca-prod -o yaml

# Cluster IP Environment Variables
echo "Chapter 07-04 – Cluster IP Environment Variables"

kubectl run --image=nginx:alpine shell --labels="app=shell"
sleep 30

kubectl describe pod -l app=shell

SHELL_POD=$(kubectl get pods -l app=shell -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $SHELL_POD -- sh -c 'env | sort'
