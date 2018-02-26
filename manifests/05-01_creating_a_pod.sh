#!/bin/bash

set -x

kubectl run kuard --image=gcr.io/kuar-demo/kuard-amd64:1
read -p "Continue?"

kubectl get pods
read -p "Continue?"

kubectl delete deployments/kuard
read -p "Continue?"
