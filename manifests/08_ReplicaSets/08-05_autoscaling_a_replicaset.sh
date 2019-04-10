#!/bin/bash

set -x

# view the pod manifest
vim 08-05_autoscaling_a_replicaset_request.yaml
read -p "Continue?"

# set requested resources
kubectl apply -f 08-05_autoscaling_a_replicaset_request.yaml
read -p "Continue?"

# display the rs
kubectl get rs kuard -o wide
read -p "Continue?"

# anable hpa
kubectl autoscale rs kuard --min=1 --max=5 --cpu-percent=80
read -p "Continue?"

# Observe HPA:
kubectl get hpa -w &
sleep 120
read -p "Continue?"

kubectl describe hpa kuard
read -p "Continue?"

# observe autoscaling:

kubectl proxy &
echo "Open grafana via: http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana:80/?orgId=1"
read -p "Continue?"

## generate load
KUARD_POD=$(kubectl get pods -l app=kuard -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $KUARD_POD 48858:8080 &
sleep 5
read -p "Continue?"

echo "Open in browser: http://localhost:48858/-/keygen"
echo "And generate some CPU load"
read -p "Continue?"

kubectl describe hpa kuard
read -p "Continue?"

kill $(jobs -p)
read -p "Exit?"
