#!/bin/bash

set -x

kubectl label deployments alpaca-test "canary=true"
kubectl get deployments -L canary

kubectl label deployments alpaca-test "canary-"
kubectl get deployments -L canary

kubectl label deployments alpaca-test "canary=true"
kubectl get deployments -L canary
