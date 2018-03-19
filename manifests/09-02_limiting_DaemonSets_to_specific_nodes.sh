#!/bin/bash

set -x
e="echo -e \n"

###############################
## 1. Adding Labels to Nodes ##
###############################

$e "1.1. Add label ssd=true to a single node"
kubectl label nodes ks102 ssd=true
read -p "Continue?"

$e "1.2. List all nodes"
kubectl get nodes
read -p "Continue?"

$e "1.3. List nodes with label ssd=true"
kubectl get nodes --selector ssd=true
read -p "Continue?"

###############################
## 2. Node Selectors         ##
###############################

$e "2.1. Create a DaemonSet"
kubectl apply -f 09-02_nginx-fast-storage.yaml
read -p "Continue?"

$e "2.2. List nginx pods with node names"
kubectl get pods -o wide --selector app=nginx
read -p "Continue?"
