Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |_, override|
    override.vm.box = "chef/ubuntu-14.04"
  end

  config.vm.provider :lxc do |_, override|
    override.vm.box = "fgrehm/trusty64-lxc"
  end

  config.cache.auto_detect = true
  config.cache.scope = :machine

  config.vm.provision :shell, inline: 'apt-get update && apt-get install -y git'
end
