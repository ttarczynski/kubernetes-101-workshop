#!/bin/bash

set -x

kubectl patch service alpaca-prod -p "$(cat 07-02_looking_beyond_the_cluster_patch.yaml)"
read -p "Continue?"

kubectl describe service alpaca-prod
read -p "Continue?"
