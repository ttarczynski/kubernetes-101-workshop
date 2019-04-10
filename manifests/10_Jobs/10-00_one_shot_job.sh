#!/bin/bash

set -x

# create a "one-shot job"
#
# -i : an interactive command
# --restart=OnFailure : create a Job object
# -- : separates a 'kubectl commands' from an '--image commands'
#
kubectl run -i oneshot --image=gcr.io/kuar-demo/kuard-amd64:1 --restart=OnFailure -- --keygen-enable --keygen-exit-on-complete --keygen-num-to-gen 10

# check the job
kubectl get jobs -o wide
read -p "Continue?"

# check with more details
kubectl get jobs -o yaml
read -p "Continue?"

# cleanup
kubectl delete jobs oneshot
read -p "Exit?"
