# Materials for Kubernetes Workshop
This workshop is based on:
* [kubernetes-up-and-running/examples](https://github.com/kubernetes-up-and-running/examples) by [Brendan Burns](https://twitter.com/brendandburns) and [Joe Beda](https://twitter.com/jbeda)
* [Kubernetes: Up and Running](https://smile.amazon.com/Kubernetes-Running-Dive-Future-Infrastructure/dp/1491935677) book by [Kelsey Hightower](https://twitter.com/kelseyhightower), [Brendan Burns](https://twitter.com/brendandburns) and [Joe Beda](https://twitter.com/jbeda)

#### Table of Contents
1. [Prerequirements](#prerequirements)
   * [Technical Knowledge](#technical-knowledge)
   * [Kubernetes Cluster](#kubernetes-cluster)
2. [Materials](#materials)
   * [Books](#books)
   * [Documentation](#documentation)
3. [Cluster Preparation](#cluster-preparation)
   * [Local Vagrant Environment](#local-vagrant-environment)
   * [Google Kubernetes Engine](#google-kubernetes-engine)

## Prerequirements

### Technical Knowledge
Workshop participants should have woring knowledge of:
* Linux environment (commands, editors, packages, etc.)
* Docker
* Vagrant
* VirtualBox

### Kubernetes Cluster
Each participant should have access to a Kubernetes cluster (1 master + 2 worker nodes) prepared before the workshop.  
We suggest to use one of the 2 options:

* [Local environement based on Vagrant + VirtualBox](#local-vagrant-environment)
* [Google Kubernetes Engine](#google-kubernetes-engine)

## Materials
### Books
* [Kubernetes: Up and Running](https://smile.amazon.com/Kubernetes-Running-Dive-Future-Infrastructure/dp/1491935677) book by [Kelsey Hightower](https://twitter.com/kelseyhightower), [Brendan Burns](https://twitter.com/brendandburns) and [Joe Beda](https://twitter.com/jbeda)

### Documentation
* [kubernetes > Documentation > Concepts](https://kubernetes.io/docs/concepts/)

## Cluster Preparation
### Local Vagrant Environment
It requires:
  * Laptop with min. 8GB RAM
  * Preferably Linux environemnt on the laptop
  * Vagrant and VirtualBox installed

*Vagrant Environment setup:*
1. Install VirtualBox: https://www.virtualbox.org/wiki/Downloads
2. Install Vagrant: https://www.vagrantup.com/docs/installation/
3. Verify correct Vagrant/VirtualBox versions and config
  * the following versions are confirmed to be working OK:
```
# vagrant --version
  Vagrant 2.2.4
# VirtualBox --help
  Oracle VM VirtualBox VM Selector v6.0.4
```
  * in case you have another hypervisor (like KVM) in use, you maight need to disable it, by following this instruction:
    [Installing Vagrant > Running Multiple Hypervisors > Linux, VirtualBox, and KVM](https://www.vagrantup.com/docs/installation/#linux-virtualbox-and-kvm)
4. Install kubectl on your system
  * Follow these instructions: [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
  * or use Google Kubernetes yum/apt repos: [instructions](https://kubernetes.io/docs/setup/independent/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
5. Clone GIT repo:
```
$ git clone https://github.com/ttarczynski/kubernetes-101-workshop.git
$ cd kubernetes-101-workshop/
```
6. Run the initialization script:
```
$ ./01_initialize_kubernetes_cluster.sh
```
7. Verify:
```
$ kubectl get componentstatus
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health": "true"}

$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
ks101     Ready     master    3d        v1.9.6
ks102     Ready     <none>    3d        v1.9.6
ks103     Ready     <none>    3d        v1.9.6
```

### Google Kubernetes Engine
Use this in case the Local Vagrant Environment option doesn't work for you.  
It requires:
  * Google Cloud account with enabled billing  
  (there’s $300 credit for free trial)

*GCP Environment setup:*
1. Follow steps 1–3 from the [Running a Container in Kubernetes with Container Engine](https://codelabs.developers.google.com/codelabs/cloud-running-a-container/index.html#0) Codelab
2. Scale the cluster to 2 worker nodes
3. Make sure to clean-up after you're done with the excercises (to save on cost).
```
$ gcloud container clusters delete hello-world
```
