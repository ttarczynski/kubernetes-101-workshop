#!/bin/bash

set -x

## 1. Scaling a deployment ##

# 1.1 modyfy the manifet:
sed -i.1 's/replicas: 2/replicas: 3/' tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{,.1}
read -p "Continue?"

# 1.2 apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl get deployments nginx
read -p "Continue?"

## 2. Updating a Container Image ##
sed -i.2 's/image: nginx:1.7.12/image: nginx:1.9.10/' tmp/nginx-deployment.yaml
