require_relative 'bucket'

module Vagrant
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

          env[:machine].config.vm.synced_folder cache_root, '/tmp/vagrant-cache', id: "vagrant-cache"

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

      class Clean
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::clean")
        end

        def call(env)
          @env = env

          if env[:machine].state.id == :running && symlinks.any?
            env[:ui].info 'Removing cache buckets symlinks...'
            symlinks.each do |symlink|
              remove_symlink symlink
            end

            File.delete env[:machine].data_dir.join('cache_dirs').to_s
          end

          @app.call env
        end

        def symlinks
          # TODO: Check if file exists instead of a blank rescue
          @symlinks ||= @env[:machine].data_dir.join('cache_dirs').read.split rescue []
        end

        def remove_symlink(symlink)
          if @env[:machine].communicate.test("test -L #{symlink}")
            @logger.debug "Removing symlink for '#{symlink}'"
            @env[:machine].communicate.sudo("unlink #{symlink}")
          end
        end
      end
    end
  end
end
