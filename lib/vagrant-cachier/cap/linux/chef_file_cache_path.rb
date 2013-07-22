module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module ChefFileCachePath
          def self.chef_provisioner?(machine)
            provisioners = machine.config.vm.provisioners
            chef_provisioners = [:chef_solo, :chef_client]
            compat_provisioners = provisioners.keep_if { |p| chef_provisioners.include? p.name }

            if compat_provisioners.size > 1
              raise "One machine is using multiple chef provisioners, which is unsupported."
            end

            using_chef = compat_provisioners.empty? ? false : true

            using_chef
          end

          def self.chef_file_cache_path(machine)
            chef_file_cache_path = nil
            # TODO: Determine paths rather than using default.
            chef_file_cache_path = '/var/chef/cache' if chef_provisioner?(machine)

            return chef_file_cache_path
          end
        end
      end
    end
  end
end
