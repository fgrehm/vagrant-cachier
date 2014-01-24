require_relative '../errors'

module VagrantPlugins
  module Cachier
    class Action
      class EnsureSingleCacheRoot
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @env = env

          # If the cache is scoped to boxes or the existing cache dirs are not
          # provider specific, there's nothing we need to do
          if cache_scoped_to_machine? && provider_specific_cache_dirs.any?
            ensure_single_cache_root_exists!
          end

          @app.call(env)
        end

        def cache_scoped_to_machine?
          @env[:machine].config.cache.enabled? &&
            @env[:machine].config.cache.scope.to_sym == :machine
        end

        def ensure_single_cache_root_exists!
          if provider_specific_cache_dirs.size > 1
            cache_dirs = provider_specific_cache_dirs.map do |dir|
              "  - #{dir.to_s.gsub(/^#{@env[:root_path]}\//, '')}"
            end
            machine_path = @env[:machine].data_dir.parent.to_s.gsub(/^#{@env[:root_path]}\//, '')
            raise Cachier::Errors::MultipleProviderSpecificCacheDirsFound,
                      machine:      @env[:machine].name,
                      machine_path: machine_path,
                      dirs:         cache_dirs.join("\n")
          else
            current_path = provider_specific_cache_dirs.first.to_s.gsub(/^#{@env[:root_path]}\//, '')
            new_path     = @env[:machine].data_dir.parent.join('cache')
            FileUtils.rm_rf new_path.to_s if new_path.directory?

            new_path = new_path.to_s.gsub(/^#{@env[:root_path]}\//, '')
            # If we got here there is a single provider specific cacher dir, so
            # let's be nice with users and just fix it ;)
            Cachier.ui.warn I18n.t('vagrant_cachier.will_fix_machine_cache_dir',
                                  current_path: current_path,
                                  new_path:     new_path)
            FileUtils.mv current_path, new_path
          end
        end

        def provider_specific_cache_dirs
          return @provider_specific_cache_dirs if @provider_specific_cache_dirs

          # By default data_dir points to ./.vagrant/machines/<NAME>/<PROVIDER>,
          # so we go one directory up
          machine_dir = @env[:machine].data_dir.parent
          @provider_specific_cache_dirs = Pathname.glob(machine_dir.join('*/cache'))
        end
      end
    end
  end
end
