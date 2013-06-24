module VagrantPlugins
  module Cachier
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-cachier'

      config 'cache' do
        require_relative "config"
        Config
      end

      config 'apt_proxy' do
        require_relative 'apt_proxy_config'
        AptProxyConfig
      end

      guest_capability 'linux', 'gemdir' do
        require_relative 'cap/linux/gemdir'
        Cap::Linux::Gemdir
      end

      guest_capability 'debian', 'apt_cache_dir' do
        require_relative 'cap/debian/apt_cache_dir'
        Cap::Debian::AptCacheDir
      end

      guest_capability 'debian', 'apt_proxy_conf' do
        require_relative 'cap/debian/apt_proxy_conf'
        Cap::Debian::AptProxyConf
      end

      guest_capability 'redhat', 'yum_cache_dir' do
        require_relative 'cap/redhat/yum_cache_dir'
        Cap::RedHat::YumCacheDir
      end

      guest_capability 'arch', 'pacman_cache_dir' do
        require_relative 'cap/arch/pacman_cache_dir'
        Cap::Arch::PacmanCacheDir
      end

      install_action_hook = lambda do |hook|
        require_relative 'action'
        require_relative 'action/configure_apt_proxy'
        hook.after Vagrant::Action::Builtin::Provision, VagrantPlugins::Cachier::Action::Install
        hook.after Vagrant::Action::Builtin::Provision, VagrantPlugins::Cachier::Action::ConfigureAptProxy
      end
      action_hook 'set-shared-cache-on-machine-up',     :machine_action_up, &install_action_hook
      action_hook 'set-shared-cache-on-machine-reload', :machine_action_reload, &install_action_hook

      clean_action_hook = lambda do |hook|
        require_relative 'action'
        hook.before Vagrant::Action::Builtin::GracefulHalt, VagrantPlugins::Cachier::Action::Clean
      end
      action_hook 'remove-guest-symlinks-on-machine-halt',    :machine_action_halt, &clean_action_hook
      action_hook 'remove-guest-symlinks-on-machine-package', :machine_action_package, &clean_action_hook
    end
  end
end
