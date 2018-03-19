#!/bin/bash

set -x
e="echo -e \n"

######################################
## 1. Delete a DaemonSet            ##
######################################

$e "1.1. Delete a DaemonSet : declaratively"
kubectl delete -f 09-01_fluentd.yaml
read -p "Continue?"

$e "1.2. Delete a DaemonSet : imperatively"
kubectl delete daemonset nginx-fast-storage
read -p "Continue?"
