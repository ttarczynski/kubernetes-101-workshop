#!/bin/bash

set -x

# create ReplicaSet
kubectl apply -f 08-01_kuard-rs.yaml

# list pods, ReplicaSets
kubectl get pods,rs --show-labels -o wide
