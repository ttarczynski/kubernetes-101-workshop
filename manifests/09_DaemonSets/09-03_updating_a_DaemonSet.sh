#!/bin/bash

set -x
e="echo -e \n"

######################################
## 1. Rolling Update of a DaemonSet ##
######################################

$e "1.1. Add label ssd=true to the second node"
kubectl label nodes ks103 ssd=true
read -p "Continue?"

$e "1.2. List nginx pods with node names"
kubectl get pods -o wide --selector app=nginx
read -p "Continue?"

$e "1.3. Display the updateStrategy"
kubectl get daemonset nginx-fast-storage  -o yaml | egrep -A1 '^  updateStrategy:'
read -p "Continue?"

$e "1.4. Set DaemonSet updateStrategy to rollingUpdate"
kubectl patch daemonset nginx-fast-storage -p "$(cat 09-03_DaemonSet_rolling_update_patch.yaml)"
read -p "Continue?"

$e "1.5. Display the updateStrategy"
kubectl get daemonset nginx-fast-storage  -o yaml | egrep -A3 '^  updateStrategy:'
read -p "Continue?"

$e "1.6. Update nginx"
kubectl patch daemonset nginx-fast-storage -p "$(cat 09-03_update_DaemonSet_patch.yaml)"
read -p "Continue?"

$e "1.7. List pods"
kubectl get pods -o wide --selector app=nginx --show-labels
read -p "Continue?"

$e "1.8. Describe a DaemonSet : see Evnets"
kubectl describe daemonset nginx-fast-storage
read -p "Continue?"
