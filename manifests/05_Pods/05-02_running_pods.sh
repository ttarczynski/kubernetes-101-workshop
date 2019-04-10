#!/bin/bash

set -x
e="echo -e \n"

#####################
## 1. Running Pods ##
#####################

$e "1.1. View the pod manifest"
vim 05-02_kuard-pod.yaml
read -p "Continue?"

$e "1.2. Apply the pod manifest"
kubectl apply -f 05-02_kuard-pod.yaml
read -p "Continue?"

$e "1.3. List pods"
kubectl get pods
read -p "Continue?"

$e "1.4. List pods – wide"
kubectl get pods -o wide
read -p "Continue?"

$e "1.5. List pods – yaml"
kubectl get pods -o yaml | less -S
read -p "Continue?"

$e "1.6. Pod Details – describe the kuard pod"
kubectl describe pod kuard
read -p "Continue?"

$e "1.7. Delete the kuard pod"
kubectl delete -f 05-02_kuard-pod.yaml
read -p "Continue?"
