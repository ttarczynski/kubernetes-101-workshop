#!/bin/bash

set -x

# create the queue service
kubectl apply -f 10-05_service_queue.yaml
read -p "Continue?"

# check whether the job was created
kubectl get services
read -p "Continue?"

# put the work items in the queue
curl -X PUT localhost:8080/memq/server/queues/keygen
#
# check the result in the http://localhost:8080/-/memq

# put another 100 items in the queue
for i in work-item-{0..99}; do \
  curl -X POST localhost:8080/memq/server/queues/keygen/enqueue -d "$i"; \
done
#
# check the result in the http://localhost:8080/-/memq

# get the status from the MemQ server
curl -s -X GET localhost:8080/memq/server/stats | python -m json.tool
