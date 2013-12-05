Vagrant.require_plugin 'vagrant-cachier'
Vagrant.require_plugin 'vagrant-lxc'
Vagrant.configure("2") do |config|
  config.cache.auto_detect = true
  config.cache.scope = :machine

  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.provision :shell, inline: 'apt-get update && apt-get install -y git'
end
