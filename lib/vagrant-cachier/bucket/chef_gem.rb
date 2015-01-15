module VagrantPlugins
  module Cachier
    class Bucket
      class ChefGem < Bucket
        def self.capability
          :chef_gemdir
        end

        def install
          if guest.capability?(:chef_gemdir)
            if gemdir_path = guest.capability(:chef_gemdir)
              prefix         = gemdir_path.split('/').last
              bucket_path    = "/tmp/vagrant-cache/#{@name}/#{prefix}"
              gem_cache_path = "#{gemdir_path}/cache"

              symlink(gem_cache_path, bucket_path)
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'ChefRubyGems')
          end
        end
      end
    end
  end
end
