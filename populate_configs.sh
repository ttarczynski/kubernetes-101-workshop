#!/bin/bash

set -x
set -eu

# CONSTATNTS
node_nums=`seq 1 3`

vagrant ssh-config > ssh-config
mkdir -p node_files

scp -F ./ssh-config root@ks1:/etc/kubernetes/admin.conf ./node_files/admin.conf

for i in $node_nums; do
  scp -F ./ssh-config  ./node_files/admin.conf root@ks${i}:/root/.kube/config
  scp -F ./ssh-config root@ks${i}:/root/.ssh/id_rsa.pub ./node_files/id_rsa.ks${i}.pub
  for j in $node_nums; do
    cat ./node_files/id_rsa.ks${i}.pub | ssh -F ./ssh-config root@ks${j} 'cat >> /root/.ssh/authorized_keys'
  done
done

mkdir -p "$HOME/.kube/"
cp ./node_files/admin.conf "$HOME/.kube/config"
