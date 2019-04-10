#!/bin/bash

set -x

# Imperative Scaling
kubectl scale rs/kuard --replicas=4
kubectl get rs -o wide
read -p "Continue?"

kubectl describe rs kuard
read -p "Continue?"

kubectl get pods -l app=kuard,version=2 --show-labels -o wide
read -p "Continue?"

# Declarative Scale
kubectl apply -f 08-03_kuard-rs_scale_replicas_3.yaml
kubectl get rs -o wide
read -p "Continue?"

kubectl describe rs kuard
read -p "Continue?"

kubectl get pods -l app=kuard,version=2 --show-labels -o wide
read -p "Continue?"

# Delete replicaSet
kubectl delete rs kuard
read -p "Continue?"
