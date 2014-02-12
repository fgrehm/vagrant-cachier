module VagrantPlugins
  module Cachier
    class Plugin < Vagrant.plugin('2')
      action_hook VagrantPlugins::Cachier::Plugin::ALL_ACTIONS do |hook|
        require_relative 'action/configure_bucket_root'
        require_relative 'action/install_buckets'

        hook.before Vagrant::Action::Builtin::Provision, Action::ConfigureBucketRoot
        # This will do the initial buckets installation
        hook.after Vagrant::Action::Builtin::Provision, Action::InstallBuckets, chmod: true
      end

      # This ensure buckets are reconfigured after provisioners runs
      action_hook :provisioner_run do |hook|
        require_relative 'action/install_buckets'
        hook.after :run_provisioner, Action::InstallBuckets
      end

      clean_action_hook = lambda do |hook|
        require_relative 'action/clean'
        hook.before Vagrant::Action::Builtin::GracefulHalt, Action::Clean
      end
      action_hook 'remove-guest-symlinks-on-halt',    :machine_action_halt,    &clean_action_hook
      action_hook 'remove-guest-symlinks-on-package', :machine_action_package, &clean_action_hook
    end
  end
end
