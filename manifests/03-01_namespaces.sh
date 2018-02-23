#!/bin/bash

set -x

kubectl get namespaces
read -p "Continue?"

kubectl get pods
read -p "Continue?"

kubectl get pods --namespace=kube-system
read -p "Continue?"

kubectl get pods --all-namespaces
read -p "Continue?"
