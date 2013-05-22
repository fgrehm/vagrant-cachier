module Vagrant
  module Cachier
    module Cap
      module RedHat
        module YumCacheDir
          def self.yum_cache_dir(machine)
            # TODO: Find out if there is a config file we can read from
            '/var/cache/yum'
          end
        end
      end
    end
  end
end
