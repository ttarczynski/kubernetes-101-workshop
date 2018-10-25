#!/bin/bash

set -x
set -eu

# CONSTATNTS
node_nums=`seq 101 103`

vagrant ssh-config > ssh-config

mkdir -p ./log/

for i in $node_nums; do
  ssh -F ./ssh-config root@ks${i} "kubeadm reset" 2>&1 | tee log/99_ks${i}_kubeadm_reset.log
done
