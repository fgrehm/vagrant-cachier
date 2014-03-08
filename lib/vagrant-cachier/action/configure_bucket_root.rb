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
            setup_omnibus_cache_folder
            env[:cache_buckets_folder_configured] = true
          end

          @app.call env
        end

        def setup_buckets_folder
          FileUtils.mkdir_p(host_cache_root.to_s) unless host_cache_root.exist?

          synced_folder_opts = {id: "vagrant-cache"}
          synced_folder_opts.merge!(@env[:machine].config.cache.synced_folder_opts || {})

          @env[:machine].config.vm.synced_folder host_cache_root, guest_cache_root, synced_folder_opts
          @env[:cache_dirs] = []
        end

        def setup_omnibus_cache_folder
          # unfortunately vagrant-omnibus hooks in before our buckets are installed, yet
          # this is early enough to tell it to download to the vagrant-omnibus pseudo bucket
          if @env[:machine].config.cache.auto_detect && omnibus_plugin_detected? && omnibus_plugin_enabled?
            omnibus_pseudo_bucket = host_cache_root.join('vagrant_omnibus')
            FileUtils.mkdir(omnibus_pseudo_bucket.to_s) unless omnibus_pseudo_bucket.exist?
            ENV['OMNIBUS_DOWNLOAD_DIR'] ||= "#{guest_cache_root}/vagrant_omnibus"
          end
        end

        def host_cache_root
          @host_cache_root ||= case @env[:machine].config.cache.scope.to_sym
            when :box
              @env[:home_path].join('cache', @env[:machine].box.name)
            when :machine
              @env[:machine].data_dir.parent.join('cache')
            else
              raise "Unknown cache scope: '#{@env[:machine].config.cache.scope}'"
          end
        end

        def guest_cache_root
          '/tmp/vagrant-cache'
        end

        def omnibus_plugin_detected?
          defined?(VagrantPlugins::Omnibus::Plugin)
        end

        def omnibus_plugin_enabled?
          @env[:machine].config.omnibus.chef_version != nil
        end
      end
    end
  end
end
