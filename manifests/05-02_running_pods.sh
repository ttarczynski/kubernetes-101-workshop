#!/bin/bash

set -x

# view the pod manifest
vim 05-02_kuard-pod.yaml
read -p "Continue?"

# apply the pod manifest
kubectl apply -f 05-02_kuard-pod.yaml
read -p "Continue?"

# list pods
kubectl get pods
read -p "Continue?"

# list pods – wide
kubectl get pods -o wide
read -p "Continue?"

# list pods – yaml
kubectl get pods -o yaml | less -S
read -p "Continue?"

# Pod Details
#  describe the kuard pod
kubectl describe pod kuard
read -p "Continue?"

# delete the kuard pod
kubectl delete -f 05-02_kuard-pod.yaml
read -p "Continue?"
