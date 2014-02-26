module VagrantPlugins
  module Cachier
    class Bucket
      class Yum < Bucket
        def self.capability
          :yum_cache_dir
        end

        def install
          if guest.capability?(:yum_cache_dir)
            guest_path = guest.capability(:yum_cache_dir)
            return if @env[:cache_dirs].include?(guest_path)

            # Ensure caching is enabled
            comm.sudo("sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf")

            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Yum')
          end
        end
      end
    end
  end
end
