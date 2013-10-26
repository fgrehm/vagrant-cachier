module VagrantPlugins
  module Cachier
    module Cap
      module Debian
        module AptCacherDir
          CACHER_CONF      = '/etc/apt-cacher-ng/acng.conf'
          CACHER_CACHE_DIR = "$(cat #{CACHER_CONF} | grep CacheDir | cut -d' ' -f 2)"

          def self.apt_cacher_dir(machine)
            cache_dir = nil
            machine.communicate.tap do |comm|
              return unless comm.test("test -f #{CACHER_CONF}")
              comm.execute "echo #{CACHER_CACHE_DIR}" do |buffer, output|
                cache_dir = output.chomp if buffer == :stdout
              end
            end
            return cache_dir
          end
        end
      end
    end
  end
end
