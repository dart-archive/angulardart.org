Vagrant.require_version ">= 1.5.0"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/debian-7.4"

  config.vm.network "private_network", ip: "10.0.0.2"

  config.vm.synced_folder ".", "/home/angulardart"

  config.vm.provision "shell", path: "provision.sh"
end
