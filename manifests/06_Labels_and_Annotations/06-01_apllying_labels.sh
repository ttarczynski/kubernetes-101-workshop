#!/bin/bash

set -x

kubectl run alpaca-prod       --image=gcr.io/kuar-demo/kuard-amd64:1 --replicas=2 --labels="ver=1,app=alpaca,env=prod"
kubectl run alpaca-test       --image=gcr.io/kuar-demo/kuard-amd64:2 --replicas=1 --labels="ver=2,app=alpaca,env=test"
kubectl run bandicoot-prod    --image=gcr.io/kuar-demo/kuard-amd64:2 --replicas=2 --labels="ver=2,app=bandicoot,env=prod"
kubectl run bandicoot-staging --image=gcr.io/kuar-demo/kuard-amd64:2 --replicas=1 --labels="ver=2,app=bandicoot,env=staging"
read -p "Continue?"

kubectl get deployments --show-labels
read -p "Continue?"
