module VagrantPlugins
  module Cachier
    module Cap
      module Debian
        module AptCacherDir
          def self.apt_cacher_dir(machine)
            # cat /etc/apt-cacher-ng/acng.conf |grep CacheDir
            '/var/cache/apt-cacher-ng'
          end
        end
      end
    end
  end
end
