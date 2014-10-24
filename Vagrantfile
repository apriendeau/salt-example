# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VM_CPUS=1
VM_RAM_MEGABYTES=1024
ALPHA_IP = "192.168.30.30"

alpha = {
    :ip => ALPHA_IP,
    :name => "alpha",
    :salt_master => true,
    :salt_minion => false
}
# beta = {
#     :ip => BETA_IP,
#     :name => "beta",
#     :salt_master => false,
#     :salt_minion => true
# }

MACHINES = []
MACHINES.push(alpha)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder "salt", "/srv/salt"
  config.vm.synced_folder "formulas", "/srv/formulas"
  # config.vm.synced_folder "reactor", "/srv/reactor"
  config.vm.synced_folder "pillar", "/srv/pillar"

  MACHINES.each do | machine |
    config.vm.define machine[:name] do |host|
      host.vm.host_name = machine[:name]
      host.vm.network "private_network", ip: machine[:ip]
    end
  end

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  ###################
  # Salt Setup
  ###################
  config.vm.provision :salt do |salt|
    salt.install_master = true
    salt.install_type   = "stable"
    salt.master_config = "config/salt/master"
    salt.minion_config = "config/salt/minion"
  end

  config.vm.provision "shell", inline: "sudo service salt-minion restart"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  ###################
  # Virtualbox Provider
  ###################
  config.vm.provider :virtualbox do |vb, override|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", VM_RAM_MEGABYTES]
    vb.customize ["modifyvm", :id, "--cpus", VM_CPUS]
  end
end
