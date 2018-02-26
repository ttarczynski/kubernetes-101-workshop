#!/bin/bash

set -x

# what's changed in the kuard pod manifest:
diff 05-02_kuard-pod.yaml 05-04_kuard-pod-health.yaml
read -p "Continue?"

# apply the pod manifest
kubectl apply -f 05-04_kuard-pod-health.yaml
read -p "Continue?"

# using port forwarding
sleep 10
kubectl port-forward kuard 8001:8080 &
sleep 2
echo "Open in a browser: http://127.0.0.1:8001/"
read -p "Continue?"

# see how the health check works in kuard
curl -i -w "\n" -XGET http://127.0.0.1:8001/healthy
read -p "Continue?"

# fail the next 2 /healthy API calls
echo "Go to: http://127.0.0.1:8001/-/liveness and click: 'Fail for next N calls: 2'"
read -p "Continue?"

# verify
curl -i -w "\n" -XGET http://127.0.0.1:8001/healthy
read -p "Continue?"

# fail the next 5 /healthy API calls
echo "Go to: http://127.0.0.1:8001/-/liveness and click: 'Fail for next N calls: 5'"
read -p "Continue?"

# verify
curl -i -w "\n" -XGET http://127.0.0.1:8001/healthy
sleep 30
read -p "Continue?"

kubectl describe pod kuard
read -p "Continue?"

kubectl get pods kuard
read -p "Continue?"

# delete the kuard pod
kubectl delete -f 05-02_kuard-pod.yaml
read -p "Continue?"

# cleenup
kill $(jobs -p)
