module VagrantPlugins
  module Cachier
    class Bucket
      class Generic < Bucket
        def install

          # First we normalize the @configs hash as a hash of hashes
          if @configs.has_key?(:cache_dir)
            @configs = { @name => @configs }
          end

          # Now we iterate through all generic buckets's configurations and
          # set them up.
          @configs.each do |key, conf|
            if conf.has_key?(:cache_dir)
              symlink(conf[:cache_dir], "/tmp/vagrant-cache/#{key}")
            else
              @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: "Generic[#{key}]")
            end
          end

        end
      end
    end
  end
end
