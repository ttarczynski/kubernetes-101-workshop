#!/bin/bash

set -x

# apply the pod manifest
kubectl apply -f 05-02_kuard-pod.yaml
sleep 5
read -p "Continue?"

# using port forwarding
kubectl port-forward kuard 8001:8080 &
sleep 2
echo "Open in a browser: http://127.0.0.1:8001/"
read -p "Continue?"

# getting more info with logs
kubectl logs kuard
read -p "Continue?"

# running commands in your container with exec
kubectl exec kuard date
read -p "Continue?"

kubectl exec -it kuard ash
read -p "Continue?"

# copying files to and from containers
kubectl cp kuard:/kuard ./tmp/
read -p "Continue?"

kubectl cp 05-02_kuard-pod.yaml kuard:/05-02_kuard-pod.yaml
read -p "Continue?"

kubectl exec -it kuard ash
read -p "Continue?"

# delete the kuard pod
kubectl delete -f 05-02_kuard-pod.yaml
read -p "Continue?"
