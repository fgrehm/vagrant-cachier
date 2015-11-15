module VagrantPlugins
  module Cachier
    class Bucket
      class Dnf < Bucket
        def self.capability
          :dnf_cache_dir
        end

        def install
          if guest.capability?(:dnf_cache_dir)
            guest_path = guest.capability(:dnf_cache_dir)
            return if @env[:cache_dirs].include?(guest_path)

            # Ensure caching is enabled
            comm.sudo("echo 'keepcache=true' >> /etc/dnf/dnf.conf")

            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Dnf')
          end
        end
      end
    end
  end
end
