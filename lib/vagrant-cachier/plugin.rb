unless Gem::Requirement.new('>= 1.4.0').satisfied_by?(Gem::Version.new(Vagrant::VERSION))
  raise 'vagrant-cachier requires Vagrant >= 1.4.0 in order to work!'
end

# Add our custom translations to the load path
I18n.load_path << File.expand_path("../../../locales/en.yml", __FILE__)

module VagrantPlugins
  module Cachier
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-cachier'
      config 'cache' do
        require_relative "config"
        Config
      end
    end

    # Keep an eye on https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#wiki-providers
    # for more.
    CLOUD_PROVIDERS = %w( aws cloudstack digitalocean hp joyent openstack rackspace
                          softlayer proxmox managed azure brightbox cloudstack vcloud
                          vsphere )
  end
end

require_relative "hooks"
require_relative "capabilities"
