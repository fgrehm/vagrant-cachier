module VagrantPlugins
  module Cachier
    class Action
      class Clean
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::clean")
        end

        def call(env)
          @machine = env[:machine]

          if should_remove_symlinks?
            env[:ui].info I18n.t('vagrant_cachier.cleanup')
            symlinks.each do |symlink|
              remove_symlink symlink
            end

            File.delete @machine.data_dir.join('cache_dirs').to_s
          end

          @app.call env
        end

        def should_remove_symlinks?
          @logger.info 'Checking if cache symlinks should be removed'
          symlinks.any? && @machine.state.id == :running
        end

        def symlinks
          # TODO: Check if file exists instead of a blank rescue
          @symlinks ||= @machine.data_dir.join('cache_dirs').read.split rescue []
        end

        def remove_symlink(symlink)
          if @machine.communicate.test("test -L #{symlink}")
            @logger.debug "Removing symlink for '#{symlink}'"
            @machine.communicate.sudo("unlink #{symlink}")
          end
        end
      end
    end
  end
end
