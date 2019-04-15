#!/bin/bash

set -x

# create a Secret
kubectl create secret generic kuard-tls \
  --from-file=kuard.crt \
  --from-file=kuard.key
read -p "Continue?"

# get / describe a secret
kubectl describe secrets kuard-tls
read -p "Continue?"

kubectl get secrets kuard-tls
read -p "Continue?"

kubectl get secrets kuard-tls -o yaml
read -p "Continue?"
