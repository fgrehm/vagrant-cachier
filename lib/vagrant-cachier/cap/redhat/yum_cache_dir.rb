module VagrantPlugins
  module Cachier
    module Cap
      module RedHat
        module YumCacheDir
          def self.yum_cache_dir(machine)
            yum_cache_dir = nil
            machine.communicate.tap do |comm|
              # In case yum is only forwarding to dnf do not cache
              return unless not comm.test('yum --version 2>&1 | grep /usr/bin/dnf')
              yum_cache_dir = '/var/cache/yum'
            end
            return yum_cache_dir
          end
        end
      end
    end
  end
end
