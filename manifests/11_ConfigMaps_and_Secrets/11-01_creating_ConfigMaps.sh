#!/bin/bash

set -x

# create a ConfigMap from file and key/value pairs
kubectl create configmap my-config\
  --from-file=11-01_my-config.txt \
  --from-literal=extra-param=extra-value \
  --from-literal=another-param=another-value
read -p "Continue?"

# get/describe a configmap
kubectl get configmaps my-config
read -p "Continue?"
kubectl describe configmaps my-config
read -p "Continue?"
kubectl get configmaps my-config -o yaml
read -p "Continue?"
