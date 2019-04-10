#!/bin/bash

set -x

kubectl get pods --show-labels
read -p "Continue?"

kubectl get pods --selector="ver=2" --show-labels
read -p "Continue?"

kubectl get pods --selector="app=bandicoot,ver=2" --show-labels
read -p "Continue?"

kubectl get pods --selector="app in (alpaca,bandicoot)" --show-labels
read -p "Continue?"

kubectl get deployments --selector="canary" --show-labels
read -p "Continue?"
