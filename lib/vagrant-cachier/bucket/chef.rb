module VagrantPlugins
  module Cachier
    class Bucket
      class Chef < Bucket
        def self.capability
          :chef_file_cache_path
        end

        def install
          if guest.capability?(:chef_file_cache_path)
            guest_path = guest.capability(:chef_file_cache_path)
            symlink(guest_path) if guest_path
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Chef')
          end
        end
      end
    end
  end
end
