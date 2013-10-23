module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module NpmCacheDir
          def self.npm_cache_dir(machine)
            npm_cache_dir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which npm')
              comm.execute 'npm config get cache' do |buffer, output|
                npm_cache_dir = output.chomp if buffer == :stdout
              end
            end
            return npm_cache_dir
          end
        end
      end
    end
  end
end
