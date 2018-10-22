#!/bin/bash

set -x

# CONSTATNTS
node_nums=`seq 101 103`
kube_version="1.11.3"

# environment setup
mkdir /root/.ssh/
chmod 700 /root/.ssh/
cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
for i in $node_nums; do
  echo "192.168.33.${i} ks${i}" >> /etc/hosts
done
yum install -y vim-enhanced rdate
cat <<EOF >> /root/.bashrc
# Kubernetes Bash completion
source <(kubectl completion bash)
EOF
cat <<EOF >> /etc/motd
Please make sure your clock is in sync:
  run 'date' and verify with your local clock

If it's not in sync run:
  chronyc makestep
  chronyc sourcestats
  rdate -s ntp.task.gda.pl
EOF
# Set timezone:
timedatectl set-timezone Europe/Warsaw
# Fix DNS:
sed -i '/^\[main\]/a dns=none' /etc/NetworkManager/NetworkManager.conf
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8
EOF
# Fix routes:
## as described in: https://github.com/kubernetes/kubeadm/issues/139#issuecomment-276607463
cat <<EOF > /etc/sysconfig/network-scripts/route-eth1
10.96.0.0/12 dev eth1
EOF

# prerequirements:
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
setenforce 0
sed -i '/swap/d' /etc/fstab
swapoff --all
mkdir $HOME/.kube/

###############################################
# Install docker                              #
# Docs: https://kubernetes.io/docs/setup/cri/ #
###############################################

## Install prerequisites.
yum install -y yum-utils device-mapper-persistent-data lvm2

## Add docker repository.
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

## Install docker.
yum install -y docker-ce-18.06.1.ce

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

###############################################
# Install kubelet                             #
# Docs: https://kubernetes.io/docs/setup/independent/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
###############################################

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet-${kube_version} kubeadm-${kube_version} kubectl-${kube_version}
systemctl enable kubelet && systemctl start kubelet

###############################################

# adjust sysctl:
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
