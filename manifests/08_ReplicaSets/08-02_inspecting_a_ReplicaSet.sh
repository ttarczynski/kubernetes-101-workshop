#!/bin/bash

set -x

# describe
kubectl describe rs kuard

read -p "Continue?"

# Find a ReplicaSet from a Pod
KUARD_POD=$(kubectl get pods -l app=kuard -o jsonpath='{.items[0].metadata.name}')
kubectl get pods $KUARD_POD -o yaml

read -p "Continue?"

# Find a Set of Pods for a ReplicaSet

kubectl get pods -l app=kuard,version=2 --show-labels
