module VagrantPlugins
  module Cachier
    class Bucket
      class Generic < Bucket
        def install
          if @configs.has_key?(:cache_dir)
            @name = @configs.has_key?(:name) ? "generic-#{@configs[:name]}" : "generic"
            symlink(@configs[:cache_dir])
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'Generic')
          end
        end
      end
    end
  end
end
