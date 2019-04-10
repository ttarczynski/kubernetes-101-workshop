#!/bin/bash

set -x

kubectl --namespace=kube-system get pod kube-apiserver-ks101 -o jsonpath --template={.status.podIP} ; echo
read -p "Continue?"

kubectl --namespace=kube-system describe pod etcd-ks101
read -p "Continue?"
