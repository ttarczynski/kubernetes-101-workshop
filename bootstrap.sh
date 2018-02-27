#!/bin/bash

set -x

# CONSTATNTS
node_nums=`seq 101 103`

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
timedatectl set-timezone Europe/Warsaw

# prerequirements:
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
setenforce 0
sed -i '/swap/d' /etc/fstab
swapoff --all
mkdir $HOME/.kube/

# install docker:
yum install -y docker
systemctl enable docker && systemctl start docker

# install kubelet:
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
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet

# adjust sysctl:
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
