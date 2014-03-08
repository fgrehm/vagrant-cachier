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
            if cache_vagrant_omnibus?
              setup_omnibus_cache_folder
            end
          end

          @app.call env
        end

        def cache_vagrant_omnibus?
          plugin_defined = defined?(VagrantPlugins::Omnibus::Plugin)
          puts "xxx - cap: vagrant-omnibus defined? #{plugin_defined}"
          return false unless plugin_defined

          chef_version = @env[:machine].config.omnibus.chef_version
          puts "xxx - cap: chef_version? #{chef_version}"
          return chef_version != nil
        end

        def setup_omnibus_cache_folder
          # since it's not configurable via the vagrant-omnibus plugin (yet)
          # we specify the directory where to download the omnibus package here
          omnibus_cache_dir = File.join(cache_root.to_s, 'omnibus')
          FileUtils.mkdir_p(omnibus_cache_dir) unless File.exist? omnibus_cache_dir
          ENV['OMNIBUS_DOWNLOAD_DIR'] = "/tmp/vagrant-cache/omnibus"
        end

        def setup_buckets_folder
          FileUtils.mkdir_p(cache_root.to_s) unless cache_root.exist?

          synced_folder_opts = {id: "vagrant-cache"}
          synced_folder_opts.merge!(@env[:machine].config.cache.synced_folder_opts || {})

          @env[:machine].config.vm.synced_folder cache_root, '/tmp/vagrant-cache', synced_folder_opts
          @env[:cache_dirs] = []
        end

        def cache_root
          @cache_root ||= case @env[:machine].config.cache.scope.to_sym
            when :box
              @env[:home_path].join('cache', @env[:machine].box.name)
            when :machine
              @env[:machine].data_dir.parent.join('cache')
            else
              raise "Unknown cache scope: '#{@env[:machine].config.cache.scope}'"
          end
        end
      end
    end
  end
end
