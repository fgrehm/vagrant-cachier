module VagrantPlugins
  module Cachier
    class Bucket
      class Zypper < Bucket
        def self.capability
          :zypper_cache_dir
        end

        def install
          if guest.capability?(:zypper_cache_dir)
            guest_path = guest.capability(:zypper_cache_dir)
            return if @env[:cache_dirs].include?(guest_path)

            # Ensure caching is enabled
            comm.sudo("zypper modifyrepo --keep-packages --all")

            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Zypper')
          end
        end
      end
    end
  end
end
