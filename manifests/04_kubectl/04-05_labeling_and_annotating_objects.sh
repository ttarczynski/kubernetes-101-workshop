#!/bin/bash

set -x

kubectl apply -f 04-04_kuard-pod.yaml
read -p "Continue?"

kubectl label pod kuard color=red
read -p "Continue?"

kubectl get pod kuard --show-labels
read -p "Continue?"

kubectl label pod kuard color-
read -p "Continue?"

kubectl get pod kuard --show-labels
read -p "Continue?"
