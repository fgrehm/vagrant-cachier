Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |_, override|
    override.vm.box = "chef/ubuntu-14.04"
  end
  config.vm.provider :lxc do |_, override|
    override.vm.box = "fgrehm/trusty64-lxc"
  end

  config.vm.provision :shell, inline: 'echo Hello!'
end
