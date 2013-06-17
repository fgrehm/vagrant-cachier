module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module Rvmdir
          def self.rvmdir(machine)
            rvmdir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('rvm info')
              comm.execute 'echo $rvm_path' do |buffer, output|
                rvmdir = output.chomp if buffer == :stdout
              end
            end
            return rvmdir
          end
        end
      end
    end
  end
end

