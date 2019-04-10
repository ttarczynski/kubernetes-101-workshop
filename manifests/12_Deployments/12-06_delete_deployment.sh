#!/bin/bash

set -x

##############################
## 1. Deleting a Deployment ##
##############################

# 1.1. declaratively delete the deployment:

kubectl delete -f tmp/nginx-deployment.yaml
read -p "Continue?"
