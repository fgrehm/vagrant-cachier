module VagrantPlugins
  module Cachier
    class Bucket
      class Mvn < Bucket
        def self.capability
          :maven_cache_dir
        end

        def install
          if guest.capability?(:maven_cache_dir)
            guest_path = guest.capability(:maven_cache_dir)
            return if @env[:cache_dirs].include?(guest_path)
            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Mvn')
          end
        end
      end
    end
  end
end
