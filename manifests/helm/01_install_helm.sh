#!/bin/bash

# Docs:
#  - https://github.com/weaveworks/flux/blob/master/site/helm-get-started.md

set -x

kubectl -n kube-system create sa tiller

kubectl create clusterrolebinding tiller-cluster-rule \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:tiller

helm init --skip-refresh --upgrade --service-account tiller
