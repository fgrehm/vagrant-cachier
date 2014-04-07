# Apt-Cacher NG is a caching proxy for software packages which are downloaded by
# Unix/Linux system distribution mechanisms from mirror servers accessible via HTTP.
module VagrantPlugins
  module Cachier
    class Bucket
      class AptCacher < Bucket
        def self.capability
          :apt_cacher_dir
        end

        def install
          if guest.capability?(:apt_cacher_dir)
            if guest_path = guest.capability(:apt_cacher_dir)
              synced_folder_type = (machine.config.cache.synced_folder_opts || {})[:type]
              if synced_folder_type && synced_folder_type.to_sym == :nfs
                symlink(guest_path)
              else
                @env[:ui].warn I18n.t('vagrant_cachier.nfs_required', bucket: 'apt-cacher')
              end
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'apt-cacher')
          end
        end
      end
    end
  end
end
