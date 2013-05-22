module Vagrant
  module Cachier
    module Cap
      module Arch
        module PacmanCacheDir
          def self.pacman_cache_dir(machine)
            # TODO: Find out if there is a config file we can read from
            '/var/cache/pacman/pkg'
          end
        end
      end
    end
  end
end
