#!/bin/bash

set -x

# what's changed in the kuard pod manifest:
diff 05-06_kuard-pod-reslim.yaml 05-07_kuard-pod-vol.yaml
read -p "Continue?"

# apply the pod manifest
kubectl apply -f 05-07_kuard-pod-vol.yaml
sleep 5
read -p "Continue?"

# see how volumes are displayed
kubectl describe pod kuard
read -p "Continue?"

# put some file to the volume dir on host
KUARD_NODE=$(kubectl  get pod kuard -o jsonpath --template={.spec.nodeName})
ssh -F ../ssh-config -l root $KUARD_NODE '(hostname ; date) > /var/lib/kuard/1.txt'
read -p "Continue?"

# see result inside of the pod
kubectl exec -it kuard cat /data/1.txt
read -p "Continue?"

# test if we can create files in the mounted dir
kubectl exec -it kuard -- sh -c '(hostname ; date) > /data/2.txt'
read -p "Continue?"

# check why the container can't write
kubectl exec -it kuard -- ls -ld /data
kubectl exec -it kuard -- id
read -p "Continue?"

# deploy next pod with the same mount
diff 05-07_kuard-pod-vol.yaml 05-07_kuard-pod-vol_a.yaml
read -p "Continue?"
kubectl apply -f 05-07_kuard-pod-vol_a.yaml
sleep 5
read -p "Continue?"

# see the same file in the second pod
kubectl exec -it kuard-a cat /data/1.txt
read -p "Continue?"

# delete all kuard pods
kubectl delete pod --all
read -p "Continue?"
