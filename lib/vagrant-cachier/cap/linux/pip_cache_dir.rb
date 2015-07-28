module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module PipCacheDir
          def self.pip_cache_dir(machine)
            pip_cache_dir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which pip')
              comm.execute 'echo $HOME' do |buffer, output|
                pip_cache_dir = output.chomp if buffer == :stdout
              end
            end
            return "#{pip_cache_dir}/.cache/pip"
          end
        end
      end
    end
  end
end
