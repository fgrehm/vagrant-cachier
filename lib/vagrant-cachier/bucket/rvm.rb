module VagrantPlugins
  module Cachier
    class Bucket
      class Rvm < Bucket
        def self.capability
          :rvm_path
        end

        def install
          if guest.capability?(:rvm_path)
            if rvm_path = guest.capability(:rvm_path)
              prefix         = rvm_path.split('/').last
              bucket_path    = "/tmp/vagrant-cache/#{@name}/#{prefix}"
              rvm_cache_path = "#{rvm_path}/archives"

              symlink(rvm_cache_path, bucket_path)
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'RVM')
          end
        end
      end
    end
  end
end
