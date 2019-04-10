#!/bin/bash

set -x

# create a job
kubectl apply -f 10-03_job_parallel.yaml
read -p "Continue?"

# check whether the job was created
kubectl get jobs
read -p "Continue?"

# watch the pods are being created
kubectl get pods --watch

# cleanup
kubectl delete jobs parallel
read -p "Exit?"
