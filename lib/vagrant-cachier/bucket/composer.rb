module VagrantPlugins
  module Cachier
    class Bucket
      class Composer < Bucket
        def self.capability
          :composer_path
        end

        def install
          if guest.capability?(:composer_path)
            if composer_path = guest.capability(:composer_path)
              bucket_path = "/tmp/vagrant-cache/#{@name}"
              symlink(composer_path, create_parent: false)
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Composer')
          end
        end
      end
    end
  end
end
