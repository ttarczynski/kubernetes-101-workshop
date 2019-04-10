#!/bin/bash

set -x

# what's changed in the kuard pod manifest:
# kuard: 0.5 CPU / 128 Mi Mem
diff 05-04_kuard-pod-health.yaml 05-05_kuard-pod-reqreq.yaml
read -p "Continue?"

# apply the pod manifest
kubectl apply -f 05-05_kuard-pod-reqreq.yaml
read -p "Continue?"

# observe effects of resources request
kubectl describe pod kuard
read -p "Continue?"

KUARD_NODE=$(kubectl  get pod kuard -o jsonpath --template={.spec.nodeName})
kubectl describe node $KUARD_NODE
read -p "Continue?"

# schedule more pods
# kuard-a: 0.5 CPU / 128 Mi Mem
diff 05-05_kuard-pod-reqreq.yaml 05-05_kuard-pod-reqreq_a.yaml
read -p "Continue?"
kubectl apply -f 05-05_kuard-pod-reqreq_a.yaml
read -p "Continue?"
KUARD_A_NODE=$(kubectl  get pod kuard-a -o jsonpath --template={.spec.nodeName})
kubectl describe node $KUARD_A_NODE
read -p "Continue?"

# kuard-b: 0.6 CPU / 128 Mi Mem
diff 05-05_kuard-pod-reqreq.yaml 05-05_kuard-pod-reqreq_b.yaml
read -p "Continue?"
kubectl apply -f 05-05_kuard-pod-reqreq_b.yaml
read -p "Continue?"
kubectl get pod -o wide
read -p "Continue?"
kubectl describe pod kuard-b
read -p "Continue?"

# kuard-c: 0.3 CPU / 128 Mi Mem
diff 05-05_kuard-pod-reqreq.yaml 05-05_kuard-pod-reqreq_c.yaml
read -p "Continue?"
kubectl apply -f 05-05_kuard-pod-reqreq_c.yaml
read -p "Continue?"
kubectl get pod -o wide
read -p "Continue?"
KUARD_C_NODE=$(kubectl  get pod kuard-c -o jsonpath --template={.spec.nodeName})
kubectl describe node $KUARD_C_NODE
read -p "Continue?"

# delete all kuard pods
kubectl delete pod --all
read -p "Continue?"
