#!/bin/bash

set -x

# set up NFS server on ks101
ssh -F ../ssh-config -l root ks101 /vagrant/manifests/05-08_setup_nfs_server.sh
read -p "Continue?"

# what's changed in the kuard pod manifest:
diff 05-07_kuard-pod-vol.yaml 05-08_kuard-pod-vol-nfs.yaml
read -p "Continue?"

# apply the pod manifest
kubectl apply -f 05-08_kuard-pod-vol-nfs.yaml
sleep 5
read -p "Continue?"

# see how volumes are displayed
kubectl describe pod kuard
read -p "Continue?"

# put some file to the volume dir on NFS server
ssh -F ../ssh-config -l root ks101 '(hostname ; date) > /var/export/1.txt'
read -p "Continue?"

# see result inside of the pod
kubectl exec -it kuard cat /data/1.txt
read -p "Continue?"

# test if we can create files in the mounted dir
kubectl exec -it kuard -- sh -c '(hostname ; date) > /data/2.txt'
read -p "Continue?"

# deploy next pod with the same mount
diff 05-08_kuard-pod-vol-nfs.yaml 05-08_kuard-pod-vol-nfs_a.yaml
read -p "Continue?"
kubectl apply -f 05-08_kuard-pod-vol-nfs_a.yaml
sleep 5
read -p "Continue?"

# see where the pods run
kubectl get pods -o wide
read -p "Continue?"

# write to the same file in the second pod
kubectl exec -it kuard-a -- sh -c '(hostname ; date) >> /data/2.txt'
read -p "Continue?"

# see the same file in the first pod
kubectl exec -it kuard cat /data/2.txt
read -p "Continue?"

# see the same file in the second pod
kubectl exec -it kuard-a cat /data/2.txt
read -p "Continue?"

# delete all kuard pods
kubectl delete pod --all
read -p "Continue?"
