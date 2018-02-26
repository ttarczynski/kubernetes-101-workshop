#!/bin/bash

set -x

kubectl apply -f 05-01_kuard-pod.yaml
read -p "Continue?"

KUBE_EDITOR="vim -c '%s#image: gcr.io/kuar-demo/kuard-amd64:1#image: gcr.io/kuar-demo/kuard-amd64:2#'" kubectl edit pod kuard
read -p "Continue?"

kubectl delete -f 05-01_kuard-pod.yaml
read -p "Continue?"
