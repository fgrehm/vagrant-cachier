module Vagrant
  module Cachier
    module Cap
      module Debian
        module AptCacheDir
          def self.apt_cache_dir(machine)
            # TODO: Find out if there is a config file we can read from
            '/var/cache/apt/archives'
          end
        end
      end
    end
  end
end
