#!/bin/bash

set -x

# install heapster (v1.5.1) as detailed in docs:
#  https://github.com/kubernetes/heapster/blob/v1.5.1/docs/influxdb.md
kubectl create -f heapster/deploy/kube-config/influxdb/
kubectl create -f heapster/deploy/kube-config/rbac/heapster-rbac.yaml

# verify installation

sleep 10
kubectl get pods --namespace=kube-system

sleep 30
kubectl top nodes

# install metrics-server (v0.2.1) as detailed in docs:
#  https://github.com/kubernetes-incubator/metrics-server/tree/v0.2.1
#  https://kubernetes.io/docs/tasks/debug-application-cluster/core-metrics-pipeline/

kubectl create -f metrics-server/deploy/
