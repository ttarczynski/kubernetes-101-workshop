#!/bin/bash

set -x

kubectl config set-context my-context --namespace=kube-system
read -p "Continue?"

kubectl config get-contexts
read -p "Continue?"

kubectl config current-context
read -p "Continue?"

kubectl config use-context my-context
read -p "Continue?"

kubectl get pods
read -p "Continue?"

kubectl config set-context my-context --namespace=kube-system --cluster=kubernetes --user=kubernetes-admin
read -p "Continue?"

kubectl config get-contexts
read -p "Continue?"

kubectl get pods
read -p "Continue?"

kubectl config use-context kubernetes-admin@kubernetes
read -p "Continue?"

kubectl get pods
read -p "Continue?"
