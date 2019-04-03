#!/bin/bash

set -x
set -eu

# CONSTANTS
node_nums=`seq 1 3`
kube_flannel_yml='https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml'

# 0. Bring up ks1
mkdir -p log
vagrant up ks1 2>&1 | tee log/00_ks1_vagrant_up.log

# 1. Generate SSH config
vagrant ssh-config > ssh-config 2>/dev/null || true
mkdir -p node_files

# 1.1. Bring up eth1 (just in case it's not up yet)
ssh -F ./ssh-config root@ks1 "ifup eth1"

# 2. Run kubeadm init on ks1
ssh -F ./ssh-config root@ks1 "kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.33.1" | tee log/02_ks1_kubeadm_init_output.log
join_command=$(egrep 'kubeadm join' log/02_ks1_kubeadm_init_output.log)

# 3. Copy admin.conf from ks1 to local .kube/config
scp -F ./ssh-config root@ks1:/etc/kubernetes/admin.conf ./node_files/admin.conf
mkdir -p "$HOME/.kube/"
if [ -f "$HOME/.kube/config" ] ; then
  cp "$HOME/.kube/config" "$HOME/.kube/config.bkp_`date +%Y%m%d_%H%M`"
fi
cp ./node_files/admin.conf "$HOME/.kube/config"

# 4. Copy admin.conf on ks1 to /root/.kube
ssh -F ./ssh-config root@ks1 "mkdir -p /root/.kube"
ssh -F ./ssh-config root@ks1 "cp /etc/kubernetes/admin.conf /root/.kube/config"
ssh -F ./ssh-config root@ks1 "kubectl version" | tee log/04_ks1_kubectl_version.log

# 5. Sleep 2 minutes and get status
sleep 120
ssh -F ./ssh-config root@ks1 "kubectl get pods --all-namespaces" | tee log/05_ks1_get_pods.log
ssh -F ./ssh-config root@ks1 "kubectl get componentstatus" | tee log/05_ks1_get_componentstatus.log

# 6. Install a pod network
ssh -F ./ssh-config root@ks1 "kubectl apply -f ${kube_flannel_yml}" 2>&1 | tee log/06_ks1_install_flannel.log

# 7. Bring up ks2
vagrant up ks2 2>&1 | tee log/07_ks2_vagrant_up.log
vagrant ssh-config > ssh-config 2>/dev/null || true

# 7.1. Bring up eth1 (just in case it's not up yet)
ssh -F ./ssh-config root@ks2 "ifup eth1"

# 8. Join worker node: ks2
ssh -F ./ssh-config root@ks2 "${join_command}" 2>&1 | tee log/08_ks2_kubeadm_join.log

# 9. Bring up ks3
vagrant up ks3 2>&1 | tee log/09_ks3_vagrant_up.log
vagrant ssh-config > ssh-config 2>/dev/null || true

# 9.1. Bring up eth1 (just in case it's not up yet)
ssh -F ./ssh-config root@ks3 "ifup eth1"

# 10. Join worker node: ks3
ssh -F ./ssh-config root@ks3 "${join_command}" 2>&1 | tee log/10_ks3_kubeadm_join.log

# 11. Populate configs to all nodes
for i in $node_nums; do
  for d in '/root' '/home/vagrant'; do
    ssh -F ./ssh-config root@ks${i} "mkdir -p ${d}/.kube"
    scp -F ./ssh-config ./node_files/admin.conf "root@ks${i}:${d}/.kube/config"
  done
  ssh -F ./ssh-config root@ks${i} "chown -R vagrant.vagrant /home/vagrant/.kube"
  scp -F ./ssh-config root@ks${i}:/root/.ssh/id_rsa.pub ./node_files/id_rsa.ks${i}.pub
  for j in $node_nums; do
    cat ./node_files/id_rsa.ks${i}.pub | ssh -F ./ssh-config root@ks${j} 'cat >> /root/.ssh/authorized_keys'
  done
done
