#!/bin/bash

set -x

# export the deployment to yaml file:
kubectl get deployments nginx --export -o yaml > tmp/nginx-deployment.yaml
read -p "Continue?"

# replace the deployment:
kubectl replace -f tmp/nginx-deployment.yaml --save-config
read -p "Continue?"

# check contents of tmp/nginx-deployment.yaml
vim tmp/nginx-deployment.yaml
read -p "Continue?"

# check the 'strategy' definitin in the deployment object:
egrep -A4 'strategy:' tmp/nginx-deployment.yaml
read -p "Continue?"
