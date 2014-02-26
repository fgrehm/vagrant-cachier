module VagrantPlugins
  module Cachier
    class Bucket
      class Npm < Bucket
        def self.capability
          :npm_cache_dir
        end

        def install
          if guest.capability?(:npm_cache_dir)
            guest_path = guest.capability(:npm_cache_dir)
            user_symlink(guest_path) if guest_path
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'npm')
          end
        end
      end
    end
  end
end
