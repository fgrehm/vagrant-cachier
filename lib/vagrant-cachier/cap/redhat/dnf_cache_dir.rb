module VagrantPlugins
  module Cachier
    module Cap
      module RedHat
        module DnfCacheDir
          def self.dnf_cache_dir(machine)
            '/var/cache/dnf'
          end
        end
      end
    end
  end
end
