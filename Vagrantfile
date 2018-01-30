# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"


  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
  end
  config.vm.provision "shell", path: "bootstrap.sh"

  (101..103).each do |i|
    config.vm.define "ks#{i}" do |node|
      node.vm.network "private_network", ip: "192.168.33.#{i}"
      node.vm.hostname = "ks#{i}"
    end
  end
end
