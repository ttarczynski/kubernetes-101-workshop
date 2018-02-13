#!/bin/bash

set -x

kubectl run alpaca-prod       --image=gcr.io/kuar-demo/kuard-amd64:1 --replicas=3 --port=8080 --labels="ver=1,app=alpaca,env=prod"
kubectl expose deployment alpaca-prod
kubectl run bandicoot-prod    --image=gcr.io/kuar-demo/kuard-amd64:2 --replicas=2 --port=8080 --labels="ver=2,app=bandicoot,env=prod"
kubectl expose deployment bandicoot-prod

kubectl get services -o wide

ALPACA_POD=$(kubectl get pods -l app=alpaca -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $ALPACA_POD 48858:8080
