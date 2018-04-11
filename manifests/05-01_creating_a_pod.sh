#!/bin/bash

set -x
e="echo -e \n"

#######################
## 1. Creating a Pod ##
#######################

$e "1.1. Create a Pod with an imperative command"
kubectl run kuard --image=gcr.io/kuar-demo/kuard-amd64:1
read -p "Continue?"

$e "1.2. See status of the Pod"
kubectl get pods
read -p "Continue?"

$e "1.3. Delete the Pod"
kubectl delete deployments/kuard
read -p "Continue?"
