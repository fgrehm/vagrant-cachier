module VagrantPlugins
  module Cachier
    module Cap
      module SuSE
        module ZypperCacheDir
          def self.zypper_cache_dir(machine)
            # TODO: Find out if there is a config file we can read from
            '/var/cache/zypp/packages'
          end
        end
      end
    end
  end
end
