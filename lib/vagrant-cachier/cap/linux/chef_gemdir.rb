module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module ChefGemdir
          def self.chef_gemdir(machine)
            gemdir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('test -f /opt/chef/embedded/bin/gem')
              comm.execute '/opt/chef/embedded/bin/gem env gemdir' do |buffer, output|
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
