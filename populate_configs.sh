#!/bin/bash

set -x

vagrant ssh-config > ssh-config
mkdir node_files
scp -F ./ssh-config root@ks101:/etc/kubernetes/admin.conf ./node_files/admin.conf
scp -F ./ssh-config  ./node_files/admin.conf root@ks102:/root/.kube/config
scp -F ./ssh-config root@ks101:/root/.ssh/id_rsa.pub ./node_files/id_rsa.ks101.pub
scp -F ./ssh-config root@ks102:/root/.ssh/id_rsa.pub ./node_files/id_rsa.ks102.pub
cat ./node_files/id_rsa.ks101.pub | ssh -F ./ssh-config root@ks102 'cat >> /root/.ssh/authorized_keys'
cat ./node_files/id_rsa.ks102.pub | ssh -F ./ssh-config root@ks101 'cat >> /root/.ssh/authorized_keys'
