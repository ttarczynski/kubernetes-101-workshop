#!/bin/bash

set -x
e="echo -e \n"

###########################
## 1. Accessing Your Pod ##
###########################

$e "1.1. Apply the pod manifest"
kubectl apply -f 05-02_kuard-pod.yaml
sleep 5
read -p "Continue?"

$e "1.2. Using Port Forwarding"
kubectl port-forward kuard 8001:8080 &
sleep 2
echo "Open in a browser: http://127.0.0.1:8001/"
read -p "Continue?"

$e "1.3. Getting More Info With Logs"
# getting more info with logs
kubectl logs kuard
read -p "Continue?"

$e "1.4. Running Commands in Your Container with exec"
kubectl exec kuard date
read -p "Continue?"

kubectl exec -it kuard ash
read -p "Continue?"

$e "1.5. Copying Files to and from Containers"
mkdir -p ./tmp/
kubectl cp kuard:/kuard ./tmp/
read -p "Continue?"

kubectl cp 05-02_kuard-pod.yaml kuard:/05-02_kuard-pod.yaml
read -p "Continue?"

kubectl exec -it kuard ash
read -p "Continue?"

$e "1.6. Delete the kuard pod"
kubectl delete -f 05-02_kuard-pod.yaml
read -p "Continue?"
