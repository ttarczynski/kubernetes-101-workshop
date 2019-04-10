#!/bin/bash

set -x

# create a job
kubectl apply -f 10-02_oneshot_failure2.yaml
read -p "Continue?"

# check whether the job was created
kubectl get jobs
read -p "Continue?"

# get the status of jobs (notice STATUS and RESTARTS)
kubectl get pod -a -l job-name=oneshot
read -p "Continue?"

# cleanup
kubectl delete jobs oneshot
read -p "Exit?"
