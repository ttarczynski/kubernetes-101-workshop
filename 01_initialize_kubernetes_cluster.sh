#!/bin/bash

set -x
set -eu

# CONSTANTS
node_nums=`seq 101 103`

# 0. Bring up ks101
vagrant up ks101 2>&1 | tee log/00_ks101_vagrant_up.log

# 1. Generate SSH config
vagrant ssh-config > ssh-config 2>/dev/null || true
mkdir -p node_files
mkdir -p log

# 2. Run kubeadm init on ks101
ssh -F ./ssh-config root@ks101 "kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.33.101" | tee log/02_ks101_kubeadm_init_output.log
join_command=$(egrep 'kubeadm join' log/02_ks101_kubeadm_init_output.log)

# 3. Copy admin.conf from ks101 to local .kube/config
scp -F ./ssh-config root@ks101:/etc/kubernetes/admin.conf ./node_files/admin.conf
mkdir -p "$HOME/.kube/"
cp ./node_files/admin.conf "$HOME/.kube/config"

# 4. Copy admin.conf on ks101 to /root/.kube
ssh -F ./ssh-config root@ks101 "mkdir -p /root/.kube"
ssh -F ./ssh-config root@ks101 "cp /etc/kubernetes/admin.conf /root/.kube/config"
ssh -F ./ssh-config root@ks101 "kubectl version" | tee log/04_ks101_kubectl_version.log

# 5. Sleep 2 minutes and get status
sleep 120
ssh -F ./ssh-config root@ks101 "kubectl get pods --all-namespaces" | tee log/05_ks101_get_pods.log
ssh -F ./ssh-config root@ks101 "kubectl get componentstatus" | tee log/05_ks101_get_componentstatus.log

# 6. Install a pod network
ssh -F ./ssh-config root@ks101 "kubectl apply -f /vagrant/manifests/flannel/Documentation/kube-flannel.yml" 2>&1 | tee log/06_ks101_install_flannel.log

# 7. Bring up ks102
vagrant up ks102 2>&1 | tee log/07_ks102_vagrant_up.log
vagrant ssh-config > ssh-config 2>/dev/null || true

# 8. Join worker node: ks102
ssh -F ./ssh-config root@ks102 "${join_command}" 2>&1 | tee log/08_ks102_kubeadm_join.log

# 9. Bring up ks103
vagrant up ks103 2>&1 | tee log/09_ks103_vagrant_up.log
vagrant ssh-config > ssh-config 2>/dev/null || true

# 10. Join worker node: ks103
ssh -F ./ssh-config root@ks103 "${join_command}" 2>&1 | tee log/10_ks103_kubeadm_join.log

# 11. Populate configs to all nodes
for i in $node_nums; do
  ssh -F ./ssh-config root@ks${i} "mkdir -p /root/.kube"
  scp -F ./ssh-config ./node_files/admin.conf root@ks${i}:/root/.kube/config
  scp -F ./ssh-config root@ks${i}:/root/.ssh/id_rsa.pub ./node_files/id_rsa.ks${i}.pub
  for j in $node_nums; do
    cat ./node_files/id_rsa.ks${i}.pub | ssh -F ./ssh-config root@ks${j} 'cat >> /root/.ssh/authorized_keys'
  done
done
