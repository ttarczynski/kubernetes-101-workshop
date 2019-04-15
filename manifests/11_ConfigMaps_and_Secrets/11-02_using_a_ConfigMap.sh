#!/bin/bash

set -x

# create a Pod using a ConfigMap as:
#  a) Filesystem mount
#  b) Environment variable
#  c) Command-line argument

vim 11-02_kuard-config.yaml
read -p "Continue?"

kubectl apply -f 11-02_kuard-config.yaml
read -p "Continue?"

# setup port forwarding
kubectl port-forward kuard-config 8001:8080 &
read -p "Continue?"

# inspect the Pod in a browser
echo "Open in browser:"
echo "  1. http://localhost:8080/-/env"
echo "  2. http://localhost:8080/fs/config/"
