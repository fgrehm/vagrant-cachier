module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module Gemdir
          def self.gemdir(machine)
            gemdir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which gem')
              comm.execute 'gem env gemdir' do |buffer, output|
                gemdir = output.chomp if buffer == :stdout
              end
            end
            return gemdir
          end
        end
      end
    end
  end
end
