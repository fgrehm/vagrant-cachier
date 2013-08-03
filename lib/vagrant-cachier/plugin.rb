module VagrantPlugins
  module Cachier
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-cachier'

      config 'cache' do
        require_relative "config"
        Config
      end

      guest_capability 'linux', 'gemdir' do
        require_relative 'cap/linux/gemdir'
        Cap::Linux::Gemdir
      end

      guest_capability 'linux', 'rvm_path' do
        require_relative 'cap/linux/rvm_path'
        Cap::Linux::RvmPath
      end

      guest_capability 'linux', 'chef_file_cache_path' do
        require_relative 'cap/linux/chef_file_cache_path'
        Cap::Linux::ChefFileCachePath
      end

      guest_capability 'debian', 'apt_cache_dir' do
        require_relative 'cap/debian/apt_cache_dir'
        Cap::Debian::AptCacheDir
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
        hook.after Vagrant::Action::Builtin::Provision, VagrantPlugins::Cachier::Action::Install
      end
      action_hook 'set-shared-cache-on-machine-up',     :machine_action_up, &install_action_hook
      action_hook 'set-shared-cache-on-machine-reload', :machine_action_reload, &install_action_hook

      clean_action_hook = lambda do |hook|
        require_relative 'action'
        hook.before Vagrant::Action::Builtin::GracefulHalt, VagrantPlugins::Cachier::Action::Clean
      end
      action_hook 'remove-guest-symlinks-on-machine-halt',    :machine_action_halt,    &clean_action_hook
      action_hook 'remove-guest-symlinks-on-machine-package', :machine_action_package, &clean_action_hook
    end
  end
end
