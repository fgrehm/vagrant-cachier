module VagrantPlugins
  module Cachier
    class Action
      class Install
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::install")
        end

        def call(env)
          return @app.call(env) unless env[:machine].config.cache.enabled?

          @env = env

          FileUtils.mkdir_p(cache_root.to_s) unless cache_root.exist?

          nfs_flag = env[:machine].config.cache.enable_nfs
          env[:machine].config.vm.synced_folder cache_root, '/tmp/vagrant-cache', id: "vagrant-cache", nfs: nfs_flag

          @app.call env

          env[:cache_dirs] = []

          if env[:machine].config.cache.auto_detect
            Bucket.auto_detect(env)
          end

          if env[:machine].config.cache.buckets.any?
            env[:ui].info 'Configuring cache buckets...'
            cache_config = env[:machine].config.cache
            cache_config.buckets.each do |bucket_name, configs|
              @logger.debug "Installing #{bucket_name} with configs #{configs.inspect}"
              Bucket.install(bucket_name, env, configs)
            end

            data_file = env[:machine].data_dir.join('cache_dirs')
            data_file.open('w') { |f| f.print env[:cache_dirs].join("\n") }
          end
        end

        def cache_root
          @cache_root ||= case @env[:machine].config.cache.scope
            when :box
              @env[:home_path].join('cache', @env[:machine].box.name)
            when :machine
              @env[:machine].data_dir.join('cache')
            else
              raise "Unknown cache scope: '#{@env[:machine].config.cache.scope}'"
          end
        end
      end
    end
  end
end
