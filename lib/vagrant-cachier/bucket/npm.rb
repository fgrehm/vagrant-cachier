module VagrantPlugins
  module Cachier
    class Bucket
      class Npm < Bucket
        def self.capability
          :npm_cache_dir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:npm_cache_dir)
            guest_path = guest.capability(:npm_cache_dir)

            @env[:cache_dirs] << guest_path

            machine.communicate.tap do |comm|
              comm.execute("mkdir -p /tmp/vagrant-cache/#{@name}")
              unless comm.test("test -L #{guest_path}")
                comm.execute("rm -rf #{guest_path}")
                comm.execute("mkdir -p `dirname #{guest_path}`")
                comm.execute("ln -s /tmp/vagrant-cache/#{@name} #{guest_path}")
              end
            end
          else
            Cachier.ui.info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'npm')
          end
        end
      end
    end
  end
end
