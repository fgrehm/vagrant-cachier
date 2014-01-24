module VagrantPlugins
  module Cachier
    class Bucket
      class Rvm < Bucket
        def self.capability
          :rvm_path
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:rvm_path)
            if rvm_path = guest.capability(:rvm_path)
              prefix      = rvm_path.split('/').last
              bucket_path = "/tmp/vagrant-cache/#{@name}/#{prefix}"
              machine.communicate.tap do |comm|
                comm.execute("mkdir -p #{bucket_path}")

                rvm_cache_path = "#{rvm_path}/archives"

                @env[:cache_dirs] << rvm_cache_path

                unless comm.test("test -L #{rvm_cache_path}")
                  comm.sudo("rm -rf #{rvm_cache_path}")
                  comm.sudo("mkdir -p `dirname #{rvm_cache_path}`")
                  comm.sudo("ln -s #{bucket_path} #{rvm_cache_path}")
                end
              end
            end
          else
            Cachier.ui.info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'RVM')
          end
        end
      end
    end
  end
end
