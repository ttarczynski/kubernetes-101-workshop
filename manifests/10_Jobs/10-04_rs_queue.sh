#!/bin/bash

set -x

# run the work queue
kubectl apply -f 10-04_rs_queue.yaml
read -p "Continue?"

# check whether the job was created
kubectl get rs 
read -p "Continue?"

# connect to the 'work queue daemon'
QUEUE_POD=$(kubectl get pods -l app=work-queue,component=queue -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $QUEUE_POD 8080:8080

# open the http://localhost:8080 and click the tab 'MemQ Server'
