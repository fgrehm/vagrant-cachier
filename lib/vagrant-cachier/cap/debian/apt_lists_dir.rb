module VagrantPlugins
  module Cachier
    module Cap
      module Debian
        module AptListsDir
          def self.apt_lists_dir(machine)
            '/var/lib/apt/lists'
          end
        end
      end
    end
  end
end
