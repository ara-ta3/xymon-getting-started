# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos"
  config.vm.box_url = "https://vagrantcloud.com/chef/boxes/centos-6.6/versions/1/providers/virtualbox.box"

  config.vm.define :web1 do |web|
    web.vm.network :private_network, ip: "192.168.33.101"
    web.vm.provision :shell, :path => "script/setup.sh"
  end
end
