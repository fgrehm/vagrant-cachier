module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module ComposerPath
          def self.composer_path(machine)
            composer_path = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which php')
              # on some VMs an extra new line seems to come out, so we loop over
              # the output just in case
              composer_path = ''
              comm.execute 'echo $HOME' do |buffer, output|
                composer_path += output.chomp if buffer == :stdout
              end
            end
            return "#{composer_path}/.composer/cache"
          end
        end
      end
    end
  end
end
