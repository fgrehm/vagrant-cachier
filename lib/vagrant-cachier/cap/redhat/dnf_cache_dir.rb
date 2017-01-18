module VagrantPlugins
  module Cachier
    module Cap
      module RedHat
        module DnfCacheDir
          def self.dnf_cache_dir(machine)
            dnf_cache_dir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which dnf')
              dnf_cache_dir = '/var/cache/dnf'
            end
            return dnf_cache_dir
          end
        end
      end
    end
  end
end
