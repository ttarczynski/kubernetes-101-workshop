#!/bin/bash

set -x

# create a job
kubectl apply -f 10-01_job_oneshot.yaml
read -p "Continue?"

# check whether the job was created
kubectl get jobs
read -p "Continue?"

# describe the job
kubectl describe jobs oneshot
read -p "Continue?"

# get the logs from the Pod
JOB_POD=$(kubectl get pods -l chapter=jobs -o jsonpath='{.items[0].metadata.name}')
kubectl logs $JOB_POD
read -p "Continue?"

# cleanup
kubectl delete jobs oneshot
read -p "Exit?"
