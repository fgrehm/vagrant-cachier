module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module IvyPath
          def self.ivy_path(machine)
            ivy_path = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which sbt')
              comm.execute 'echo $HOME' do |buffer, output|
                ivy_path = output.chomp if buffer == :stdout
              end
            end
            return "#{ivy_path}/.ivy2/cache"
          end
        end
      end
    end
  end
end
