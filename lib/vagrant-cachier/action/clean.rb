module VagrantPlugins
  module Cachier
    class Action
      class Clean
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::clean")
        end

        def call(env)
          @env = env

          if env[:machine].state.id == :running && symlinks.any?
            env[:ui].info I18n.t('vagrant_cachier.cleanup')
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
