Vagrant.configure("2") do |config|
  config.cache.auto_detect = true
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.provision :shell, inline: 'echo Hello!'
end
