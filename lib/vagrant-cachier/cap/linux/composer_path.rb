module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module ComposerPath
          def self.composer_path(machine)
            composer_path = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which php')
              comm.execute 'echo $HOME' do |buffer, output|
                composer_path = output.chomp if buffer == :stdout
              end
            end
            return "#{composer_path}/.composer"
          end
        end
      end
    end
  end
end
