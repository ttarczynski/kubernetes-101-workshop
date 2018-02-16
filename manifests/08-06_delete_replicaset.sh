#!/bin/bash

set -x

# Delete replicaSet
kubectl delete rs kuard
kubectl get pods

# Delete HPA
kubectl delete hpa kuard
kubectl get hpa
