module VagrantPlugins
  module Cachier
    module Cap
      module SuSE
        module ZypperCacheDir
          def self.zypper_cache_dir(machine)
            '/var/cache/zypp/packages'
          end
        end
      end
    end
  end
end
