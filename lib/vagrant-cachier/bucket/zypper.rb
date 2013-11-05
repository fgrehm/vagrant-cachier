module VagrantPlugins
  module Cachier
    class Bucket
      class Zypper < Bucket
        def self.capability
          :zypper_cache_dir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:zypper_cache_dir)
            guest_path = guest.capability(:zypper_cache_dir)

            @env[:cache_dirs] << guest_path

            machine.communicate.tap do |comm|
              # Ensure caching is enabled
              comm.sudo("zypper modifyrepo --keep-packages --all")

              comm.execute("mkdir -p /tmp/vagrant-cache/#{@name}")
              unless comm.test("test -L #{guest_path}")
                comm.sudo("rm -rf #{guest_path}")
                comm.sudo("mkdir -p `dirname #{guest_path}`")
                comm.sudo("ln -s /tmp/vagrant-cache/#{@name} #{guest_path}")
              end
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Zypper')
          end
        end
      end
    end
  end
end
