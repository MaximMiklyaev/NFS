# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end

  config.vm.define "nfsSerer" do |nfsSerer|
    nfsSerer.vm.network "private_network", ip: "192.168.10.10", virtualbox__intnet: "net1"
    nfsSerer.vm.hostname = "nfsSerer"
    nfsSerer.vm.provision "shell", path: "server_script.sh"
  end

  config.vm.define "nfsClient" do |nfsClient|
    nfsClient.vm.network "private_network", ip: "192.168.10.11", virtualbox__intnet: "net1"
    nfsClient.vm.hostname = "nfsClient"
    nfsClient.vm.provision "shell", path: "client_script.sh"
  end

end
