#!/bin/bash

set -x

# create a parallel job on workers
kubectl apply -f 10-06_job_consumers.yaml
read -p "Continue?"

# check whether the jobs were created
kubectl get pods
read -p "Continue?"

# observer the http://localhost:8080/-/memq
# the number in the "Depth" column should decrease
read -p "Exit?" 
