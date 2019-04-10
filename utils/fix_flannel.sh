#!/bin/bash

set -x
set -eu

# CONSTATNTS
kube_flannel_yml='/vagrant/manifests/flannel/Documentation/kube-flannel_k8s_v1.12.yml'
kube_flannel_yml_bad='https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml'
kube_flannel_yml_bad2='/vagrant/manifests/flannel/Documentation/kube-flannel_v0.10.0.yml'

ssh -F ./ssh-config root@ks101 "kubectl delete -f ${kube_flannel_yml_bad}" || true
ssh -F ./ssh-config root@ks101 "kubectl delete -f ${kube_flannel_yml_bad2}" || true
sleep 10
ssh -F ./ssh-config root@ks101 "kubectl apply -f ${kube_flannel_yml}"
