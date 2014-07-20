module VagrantPlugins
  module Cachier
    module Cap
      module Arch
        module PacmanCacheDir
          def self.pacman_cache_dir(machine)
            '/var/cache/pacman/pkg'
          end
        end
      end
    end
  end
end
