module VagrantPlugins
  module Cachier
    class Bucket
      class Composer < Bucket
        def self.capability
          :composer_path
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:composer_path)
            if composer_path = guest.capability(:composer_path)
              bucket_path = "/tmp/vagrant-cache/#{@name}/"
              #remove trailing slash, or symlink will fail
              composer_path = composer_path.chomp('/')               
              @env[:cache_dirs] << composer_path

              machine.communicate.tap do |comm|
                comm.execute("mkdir -p #{bucket_path}")

                unless comm.test("test -L #{composer_path}")
                  comm.sudo("rm -rf #{composer_path}")
                  comm.sudo("ln -s #{bucket_path} #{composer_path}")
               end
              end
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Composer')
          end
        end
      end
    end
  end
end
