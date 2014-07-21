require_relative '../bucket'

module VagrantPlugins
  module Cachier
    class Action
      class InstallBuckets
        def initialize(app, env, opts = {})
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::clean")
          @opts   = opts
        end

        def call(env)
          @app.call(env)

          return unless env[:machine].config.cache.enabled?

          chmod_bucket_root(env[:machine]) if @opts[:chmod]
          configure_cache_buckets(env)
        end

        def chmod_bucket_root(machine)
          machine.communicate.sudo 'mkdir -p /tmp/vagrant-cache'

          # https://github.com/fgrehm/vagrant-cachier/issues/107
          if ! smb_synced_folder_enabled?(machine)
            @logger.info "'chmod'ing bucket root dir to 777..."
            machine.communicate.sudo 'chmod 777 /tmp/vagrant-cache'
          end
        end

        def configure_cache_buckets(env)
          if env[:machine].config.cache.auto_detect
            Bucket.auto_detect(env)
          end

          return unless env[:machine].config.cache.buckets.any?

          env[:ui].info 'Configuring cache buckets...'
          cache_config = env[:machine].config.cache
          cache_config.buckets.each do |bucket_name, configs|
            @logger.info "Installing #{bucket_name} with configs #{configs.inspect}"
            Bucket.install(bucket_name, env, configs)
          end

          data_file = env[:machine].data_dir.join('cache_dirs')
          data_file.open('w') { |f| f.print env[:cache_dirs].uniq.join("\n") }
        end

        def smb_synced_folder_enabled?(machine)
          synced_folder_opts = machine.config.cache.synced_folder_opts
          synced_folder_opts ||= {}

          # If smb was explicitly enabled
          if synced_folder_opts[:type] && synced_folder_opts[:type].to_s == 'smb'
            return true
          elsif machine.provider_name.to_sym == :hyperv
            # If the provider in use is hyperv, the default synced folder is 'smb'
            # unless specified
            return synced_folder_opts[:type] == nil
          end
        end
      end
    end
  end
end
