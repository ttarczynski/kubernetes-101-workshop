#!/bin/bash

set -x
e="echo -e \n"

######################
## 1. Health Checks ##
######################

$e "1.1. what's changed in the kuard pod manifest:"
diff 05-02_kuard-pod.yaml 05-04_kuard-pod-health.yaml
read -p "Continue?"

$e "1.2. apply the pod manifest"
kubectl apply -f 05-04_kuard-pod-health.yaml
read -p "Continue?"

$e "1.3. using port forwarding"
sleep 10
kubectl port-forward kuard 8001:8080 &
sleep 2
echo "Open in a browser: http://127.0.0.1:8001/"
read -p "Continue?"

$e "1.4. see how the health check works in kuard"
curl -i -w "\n" -XGET http://127.0.0.1:8001/healthy
read -p "Continue?"

$e "1.5. fail the next 2 /healthy API calls"
echo "Go to: http://127.0.0.1:8001/-/liveness and click: 'Fail for next N calls: 2'"
read -p "Continue?"

$e "1.6. verify"
curl -i -w "\n" -XGET http://127.0.0.1:8001/healthy
read -p "Continue?"

$e "1.7. fail the next 5 /healthy API calls"
echo "Go to: http://127.0.0.1:8001/-/liveness and click: 'Fail for next N calls: 5'"
read -p "Continue?"

$e "1.8. verify"
curl -i -w "\n" -XGET http://127.0.0.1:8001/healthy
sleep 30
read -p "Continue?"

kubectl describe pod kuard
read -p "Continue?"

kubectl get pods kuard
read -p "Continue?"

$e "1.9. delete the kuard pod"
kubectl delete -f 05-02_kuard-pod.yaml
read -p "Continue?"

$e "1.10. cleenup"
kill $(jobs -p)
