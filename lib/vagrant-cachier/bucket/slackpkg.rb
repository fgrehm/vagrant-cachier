module VagrantPlugins
  module Cachier
    class Bucket
      class SlackPkg < Bucket
        def self.capability
          :slackpkg_cache_dir
        end

        def install
          if guest.capability?(:slackpkg_cache_dir)
            guest_path = guest.capability(:slackpkg_cache_dir)
            return if @env[:cache_dirs].include?(guest_path)

            # Ensure caching is enabled
            comm.sudo("sed -i 's/DELALL=on/DELALL=off/g' /etc/slackpkg/slackpkg.conf")

            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Yum')
          end
        end
      end
    end
  end
end