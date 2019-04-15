#!/bin/bash

set -x

# create a Secret
vim 11-04_kuard-secret.yaml
read -p "Continue?"

kubectl apply -f 11-04_kuard-secret.yaml
read -p "Continue?"

# describe the Pod
kubectl describe pod kuard-tls
read -p "Continue?"

# setup port forwarding
kubectl port-forward kuard-tls 8443:8443 &
read -p "Continue?"

# inspect the Pod in a browser
echo "Open in browser:"
echo "  1. https://127.0.0.1:8443/"
echo "     and check the SSL certificate"
