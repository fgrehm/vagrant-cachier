module VagrantPlugins
  module Cachier
    class Bucket
      class Dnf < Bucket
        def self.capability
          :dnf_cache_dir
        end

        def install
          if guest.capability?(:dnf_cache_dir)
            if guest_path = guest.capability(:dnf_cache_dir)
              return if @env[:cache_dirs].include?(guest_path)

              # Ensure caching is enabled
              comm.sudo("sed -i '/keepcache=/d' /etc/dnf/dnf.conf")
              comm.sudo("sed -i '/^[main]/a keepcache=1' /etc/dnf/dnf.conf")

              symlink(guest_path)
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'DNF')
          end
        end
      end
    end
  end
end
