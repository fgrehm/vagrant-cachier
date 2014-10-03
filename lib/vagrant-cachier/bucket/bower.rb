module VagrantPlugins
  module Cachier
    class Bucket
      class Bower < Bucket
        def self.capability
          :bower_path
        end

        def install
          if guest.capability?(:bower_path)
            if bower_path = guest.capability(:bower_path)
              user_symlink(bower_path)
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Bower')
          end
        end
      end
    end
  end
end
