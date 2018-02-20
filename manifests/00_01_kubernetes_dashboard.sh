#!/bin/bash

set -x

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl apply -f 00_01_ServiceAccount_admin-user.yaml
kubectl apply -f 00_02_ClusterRoleBinding_admin-user.yaml

kubectl -n kube-system describe secret admin-user-token

echo "After kubectl port-forward is done, go to: https://127.0.0.1:8443/"

DASHBOARD_POD=$(kubectl -n kube-system get pods   --selector="k8s-app=kubernetes-dashboard" -o jsonpath='{.items[0].metadata.name}')
kubectl -n kube-system port-forward ${DASHBOARD_POD} 8443:8443
