module VagrantPlugins
  module Cachier
    class Bucket
      class Pip < Bucket
        def self.capability
          :pip_cache_dir
        end

        def install
          if guest.capability?(:pip_cache_dir)
            if guest_path = guest.capability(:pip_cache_dir)
              symlink("#{guest_path}/http", "/tmp/vagrant-cache/#{@name}/http")
              symlink("#{guest_path}/wheels", "/tmp/vagrant-cache/#{@name}/wheels")
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'pip')
          end
        end
      end
    end
  end
end
