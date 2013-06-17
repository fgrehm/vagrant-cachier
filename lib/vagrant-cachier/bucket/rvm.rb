module VagrantPlugins
  module Cachier
    class Bucket
      class Rvm < Bucket
        def self.capability
          :rvmdir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:rvmdir)
            if rvmdir_path = guest.capability(:rvmdir)
              prefix      = rvmdir_path.split('/').last
              bucket_path = "/tmp/vagrant-cache/#{@name}/#{prefix}"
              machine.communicate.tap do |comm|
                comm.execute("mkdir -p #{bucket_path}")

                rvm_cache_path = "#{rvmdir_path}/archives"

                @env[:cache_dirs] << rvm_cache_path

                unless comm.test("test -L #{rvm_cache_path}")
                  comm.sudo("rm -rf #{rvm_cache_path}")
                  comm.sudo("mkdir -p `dirname #{rvm_cache_path}`")
                  comm.sudo("ln -s #{bucket_path} #{rvm_cache_path}")
                end
              end
            end
          else
            # TODO: Raise a better error
            raise "You've configured a RVM cache for a guest machine that does not support it!"
          end
        end
      end
    end
  end
end
