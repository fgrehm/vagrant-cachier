require 'timeout'

module VagrantPlugins
  module Cachier
    class Action
      class ConfigureBucketRoot
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::clean")
        end

        def call(env)
          @env = env

          if !env[:cache_buckets_folder_configured] && env[:machine].config.cache.enabled?
            setup_buckets_folder
            env[:cache_buckets_folder_configured] = true
          end

          @app.call env
        end

        def setup_buckets_folder

          synced_folder_opts = {id: "vagrant-cache"}
          synced_folder_opts.merge!(@env[:machine].config.cache.synced_folder_opts || {})
          puts([@env[:machine].config.cache.override_directory, cache_root].join(''))

          FileUtils.mkdir_p([@env[:machine].config.cache.override_directory, cache_root].join('').to_s) unless File.directory?([@env[:machine].config.cache.override_directory, cache_root].join('').to_s)

          @env[:machine].config.vm.synced_folder [@env[:machine].config.cache.override_directory, cache_root].join(''), '/tmp/vagrant-cache', synced_folder_opts
          @env[:cache_dirs] = []
        end

        def cache_root
          @cache_root ||= case @env[:machine].config.cache.scope.to_sym
            when :box
              @box_name = box_name
              # Box is optional with docker provider
              if @box_name.nil? && @env[:machine].provider_name.to_sym == :docker
                @image_name = image_name
                # Use the image name if it's set
                if @image_name
                  bucket_name = @image_name.gsub(':', '-')
                else
                  raise "Cachier plugin only supported with docker provider when image is used"
                end
              else
                bucket_name = @box_name
              end
              @env[:home_path].join('cache', bucket_name)
            when :machine
              @env[:machine].data_dir.parent.join('cache')
            else
              raise "Unknown cache scope: '#{@env[:machine].config.cache.scope}'"
          end
        end

        def box_name
          @env[:machine].config.vm.box
        end

        def image_name
          @env[:machine].provider_config.image
        end
      end
    end
  end
end
