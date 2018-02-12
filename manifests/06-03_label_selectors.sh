#!/bin/bash

set -x

kubectl get pods --show-labels
kubectl get pods --selector="ver=2" --show-labels
kubectl get pods --selector="app=bandicoot,ver=2" --show-labels
kubectl get pods --selector="app in (alpaca,bandicoot)" --show-labels
kubectl get deployments --selector="canary" --show-labels
