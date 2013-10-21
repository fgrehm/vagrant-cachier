module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module ComposerPath 
          def self.composer_path(machine)
            composer_path = '/home/vagrant/.composer/'
            return composer_path 
          end
        end
      end
    end
  end
end
