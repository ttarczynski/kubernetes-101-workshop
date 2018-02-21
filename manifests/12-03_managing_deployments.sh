#!/bin/bash

set -x

# describe the nginx deployment
# see fields:
#  - OldReplicaSets
#  - NewReplicaSet
#  - Events
kubectl describe deployment nginx
read -p "Continue?"
