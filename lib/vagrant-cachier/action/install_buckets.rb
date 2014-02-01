require_relative '../bucket'

module VagrantPlugins
  module Cachier
    class Action
      class InstallBuckets
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @app.call(env)

          configure_cache_buckets(env)
        end

        def configure_cache_buckets
          return unless env[:machine].config.cache.enabled?

          if env[:machine].config.cache.auto_detect
            Bucket.auto_detect(env)
          end

          return unless env[:machine].config.cache.buckets.any?

          env[:ui].info 'Configuring cache buckets...'
          cache_config = env[:machine].config.cache
          cache_config.buckets.each do |bucket_name, configs|
            # cachier_debug "Installing #{bucket_name} with configs #{configs.inspect}"
            Bucket.install(bucket_name, env, configs)
          end

          data_file = env[:machine].data_dir.join('cache_dirs')
          data_file.open('w') { |f| f.print env[:cache_dirs].uniq.join("\n") }
        end
      end
    end
  end
end
