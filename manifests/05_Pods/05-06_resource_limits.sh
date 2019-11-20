#!/bin/bash

set -x

# what's changed in the kuard pod manifest:
diff 05-05_kuard-pod-reqreq.yaml 05-06_kuard-pod-reslim.yaml
read -p "Continue?"

# apply the pod manifest
kubectl apply -f 05-06_kuard-pod-reslim.yaml
sleep 5
read -p "Continue?"

# observe effects of resources request
kubectl describe pod kuard
read -p "Continue?"

# port forward
kubectl port-forward kuard 8001:8080 &
sleep 2
echo "Open in a browser: http://127.0.0.1:8001/"
read -p "Continue?"

# allocate 500 MiB RAM to trigger OOM Killer
echo "Go to: http://127.0.0.1:8001/-/mem and click: 'Allocate 500 MiB'"
read -p "Continue?"

# check if the pod was restarted
kubectl get pod kuard
read -p "Continue?"
kubectl describe pod kuard
read -p "Continue?"

# deploy 3 more pods
## kuard-a – CPU request: 0.3 / CPU limit: 1.0
## kuard-b – CPU request: 0.3 / CPU limit: 1.0
## kuard-c – CPU request: 0.3 / CPU limit: 1.0
vim 05-06_kuard-pod-reslim_more_pods.yaml
read -p "Continue?"
kubectl apply -f 05-06_kuard-pod-reslim_more_pods.yaml
read -p "Continue?"

# observe how overcommit works
kubectl get pods -o wide
read -p "Continue?"
kubectl describe node ks103
read -p "Continue?"

# delete all kuard pods
kubectl delete pod --all
read -p "Continue?"

# cleenup
kill $(jobs -p)
