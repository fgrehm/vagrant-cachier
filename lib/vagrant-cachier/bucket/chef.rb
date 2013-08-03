module VagrantPlugins
  module Cachier
    class Bucket
      class Chef < Bucket
        def self.capability
          :chef_file_cache_path
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:chef_file_cache_path)
            guest_path = guest.capability(:chef_file_cache_path)

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
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Chef')
          end
        end
      end
    end
  end
end
