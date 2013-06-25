module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module RvmPath
          def self.rvm_path(machine)
            rvm_path = nil
            machine.communicate.tap do |comm|
              return unless comm.test('rvm info')
              comm.execute 'echo $rvm_path' do |buffer, output|
                rvm_path = output.chomp if buffer == :stdout
              end
            end
            return rvm_path
          end
        end
      end
    end
  end
end

