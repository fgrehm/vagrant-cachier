require_relative 'bucket'

module VagrantPlugins
  module Cachier
    module ProvisionExt
      def self.included(base)
        base.class_eval do
          def cachier_debug(msg)
            @logger.debug "[CACHIER] #{msg}"
          end

          alias :old_call :call
          def call(env)
            @env = env

            return old_call(env) unless env[:machine].config.cache.enabled?

            FileUtils.mkdir_p(cache_root.to_s) unless cache_root.exist?

            synced_folder_opts = {id: "vagrant-cache"}
            synced_folder_opts.merge!(env[:machine].config.cache.sync_opts)
            
            if env[:machine].config.cache.enable_nfs
              # REFACTOR: Drop the `nfs: true` argument once we drop support for Vagrant < 1.4
              synced_folder_opts.merge!({ nfs: true, type: 'nfs' })
            end
            env[:machine].config.vm.synced_folder cache_root, '/tmp/vagrant-cache', synced_folder_opts

            env[:cache_dirs] = []

            old_call(env)

            configure_cache_buckets
          end

          alias :old_run_provisioner :run_provisioner
          def run_provisioner(*args)
            configure_cache_buckets
            old_run_provisioner(*args)
          end

          def configure_cache_buckets
            return unless @env[:machine].config.cache.enabled?

            if @env[:machine].config.cache.auto_detect
              Bucket.auto_detect(@env)
            end

            return unless @env[:machine].config.cache.buckets.any?

            @env[:ui].info 'Configuring cache buckets...'
            cache_config = @env[:machine].config.cache
            cache_config.buckets.each do |bucket_name, configs|
              cachier_debug "Installing #{bucket_name} with configs #{configs.inspect}"
              Bucket.install(bucket_name, @env, configs)
            end

            data_file = @env[:machine].data_dir.join('cache_dirs')
            data_file.open('w') { |f| f.print @env[:cache_dirs].uniq.join("\n") }
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
end
