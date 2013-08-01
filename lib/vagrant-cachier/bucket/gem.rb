module VagrantPlugins
  module Cachier
    class Bucket
      class Gem < Bucket
        def self.capability
          :gemdir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:gemdir)
            if gemdir_path = guest.capability(:gemdir)
              prefix      = gemdir_path.split('/').last
              bucket_path = "/tmp/vagrant-cache/#{@name}/#{prefix}"
              machine.communicate.tap do |comm|
                comm.execute("mkdir -p #{bucket_path}")

                gem_cache_path = "#{gemdir_path}/cache"

                @env[:cache_dirs] << gem_cache_path

                unless comm.test("test -L #{gem_cache_path}")
                  comm.sudo("rm -rf #{gem_cache_path}")
                  comm.sudo("mkdir -p `dirname #{gem_cache_path}`")
                  comm.sudo("ln -s #{bucket_path} #{gem_cache_path}")
                end
              end
            end
          else
            @env[:ui].info "Skipping RubyGems cache bucket as the guest machine does not support it"
          end
        end
      end
    end
  end
end
