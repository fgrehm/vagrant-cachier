module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module BowerPath
          def self.bower_path(machine)
            bower_path = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which bower')
              comm.execute 'echo $HOME' do |buffer, output|
                bower_path = output.chomp if buffer == :stdout
              end
            end
            return "#{bower_path}/.cache/bower"
          end
        end
      end
    end
  end
end
