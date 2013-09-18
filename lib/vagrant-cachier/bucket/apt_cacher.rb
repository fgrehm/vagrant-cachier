# Apt-Cacher NG is a caching proxy for software packages which are downloaded by Unix/Linux system distribution mechanisms from mirror servers accessible via HTTP.
module VagrantPlugins
  module Cachier
    class Bucket
      class AptCacher < Bucket
        def self.capability
          :apt_cacher_dir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:apt_cacher_dir)
            guest_path = guest.capability(:apt_cacher_dir)

            @env[:cache_dirs] << guest_path

            machine.communicate.tap do |comm|
              comm.execute("mkdir -p /tmp/vagrant-cache/#{@name}")
              unless comm.test("test -L #{guest_path}")
                comm.sudo("rm -rf #{guest_path}")
                comm.sudo("mkdir -p `dirname #{guest_path}`")
                comm.sudo("ln -s /tmp/vagrant-cache/#{@name} #{guest_path}")
              end
            end
          else
            # TODO: Raise a better error
            raise "You've configured an APT-CACHER cache for a guest machine that does not support it!"
          end
        end
      end
    end
  end
end
