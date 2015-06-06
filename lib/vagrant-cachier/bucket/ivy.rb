module VagrantPlugins
  module Cachier
    class Bucket
      class Ivy < Bucket
        def self.capability
          :ivy_path
        end

        def install
          if guest.capability?(:ivy_path)
            if ivy_path = guest.capability(:ivy_path)
              user_symlink(ivy_path)
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Ivy')
          end
        end
      end
    end
  end
end
