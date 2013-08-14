Vagrant.require_plugin 'vagrant-cachier'
Vagrant.require_plugin 'vagrant-lxc'
Vagrant.configure("2") do |config|
  config.cache.auto_detect = true
  config.vm.box = 'quantal64'
  config.vm.provision :shell, inline: 'echo Hello!'
end
