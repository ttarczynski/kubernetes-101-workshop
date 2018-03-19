#!/bin/bash

set -x
e="echo -e \n"

###############################
## 1. Create a DaemonSet     ##
###############################

$e "1.1. Create a DaemonSet"
kubectl apply -f 09-01_fluentd.yaml
read -p "Continue?"

$e "1.2. Describe a DaemonSet"
kubectl -n kube-system describe daemonset fluentd
read -p "Continue?"

$e "1.3. List fluentd pods with node names"
kubectl -n kube-system get pods -o wide --selector=app=fluentd
read -p "Continue?"
