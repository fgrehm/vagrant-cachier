# TODO: Switch to Vagrant.require_version before 1.0.0
#       see: https://github.com/mitchellh/vagrant/blob/bc55081e9ffaa6820113e449a9f76b293a29b27d/lib/vagrant.rb#L202-L228
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
                          softlayer proxmox managed virtualbox )
  end
end

require_relative "hooks"
require_relative "capabilities"
