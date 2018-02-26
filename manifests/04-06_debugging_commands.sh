#!/bin/bash

set -x

kubectl apply -f 05-01_kuard-pod.yaml
read -p "Continue?"

sleep 10
kubectl logs kuard
read -p "Continue?"

kubectl exec -it kuard -- ash
read -p "Continue?"

kubectl cp kuard:/kuard ./tmp/
read -p "Continue?"

ls tmp/kuard
read -p "Continue?"

kubectl delete pod kuard
read -p "Continue?"
