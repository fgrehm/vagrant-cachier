module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module SlackPkgCacheDir
          def self.slackpkg_cache_dir(machine)
            '/var/cache/packages'
          end
        end
      end
    end
  end
end