# -*- mode: ruby -*-
# vi: set ft=ruby :

# fix for a Vagrant bug: https://github.com/hashicorp/vagrant/issues/9442
## Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"


  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 1
    vb.memory = "768"
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
  config.vm.define "ks1" do |node|
    node.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = "2048"
    end
  end

  config.vm.provision "shell", path: "bootstrap.sh"

  (1..3).each do |i|
    config.vm.define "ks#{i}" do |node|
      node.vm.network "private_network", ip: "192.168.33.#{i}"
      node.vm.hostname = "ks#{i}"
    end
  end
end
