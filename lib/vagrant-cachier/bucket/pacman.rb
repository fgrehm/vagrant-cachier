module VagrantPlugins
  module Cachier
    class Bucket
      class Pacman < Bucket
        def self.capability
          :pacman_cache_dir
        end

        def install
          if guest.capability?(:pacman_cache_dir)
            guest_path = guest.capability(:pacman_cache_dir)
            symlink(guest_path)
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Pacman')
          end
        end
      end
    end
  end
end
