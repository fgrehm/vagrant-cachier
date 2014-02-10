module VagrantPlugins
  module Cachier
    module Cap
      module Debian
        module AptCacheDir
          def self.apt_cache_dir(machine)
            # TODO: Find out if there is a config file we can read from
			{ :archives_dir => '/var/cache/apt/archives', :lists_dir => '/var/lib/apt/lists'}
          end
        end
      end
    end
  end
end
