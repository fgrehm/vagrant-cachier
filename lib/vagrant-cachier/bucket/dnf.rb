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
            if !comm.sudo("grep -q 'keepcache=' /etc/dnf/dnf.conf", error_check: false)
              comm.sudo("sed -i 's/keepcache=0/keepcache=1/g' /etc/dnf/dnf.conf")
            else
              comm.sudo("echo 'keepcache=1' >> /etc/dnf/dnf.conf")
            end

            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Dnf')
          end
        end
      end
    end
  end
end
