module VagrantPlugins
  module Cachier
    class Bucket
      class Apt < Bucket
        def self.capability
          :apt_cache_dir
        end

        def install
          if guest.capability?(:apt_cache_dir)
            guest_path = guest.capability(:apt_cache_dir)

            return if @env[:cache_dirs].include?(guest_path)

            symlink(guest_path)
            comm.execute("mkdir -p /tmp/vagrant-cache/#{@name}/partial")
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'APT')
          end
        end
      end
    end
  end
end
