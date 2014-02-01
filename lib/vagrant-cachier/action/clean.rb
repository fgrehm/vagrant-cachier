require 'timeout'

module VagrantPlugins
  module Cachier
    class Action
      class Clean
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::clean")
        end

        def call(env)
          @env     = env
          @machine = env[:machine]

          if symlinks.any?
            env[:ui].info I18n.t('vagrant_cachier.cleanup')
            if sshable?
              symlinks.each do |symlink|
                remove_symlink symlink
              end
            end

            File.delete @machine.data_dir.join('cache_dirs').to_s
          end

          @app.call env
        end

        def sshable?
          return if @machine.state.id != :running

          # By default Vagrant will keep trying [1] to ssh connect to the VM for
          # a long and we've got to prevent that from happening, so we just wait
          # a few seconds and assume that the VM is halted / unresponsive and we
          # carry on if it times out.
          #   [1] - https://github.com/mitchellh/vagrant/blob/57e95323b6600b146167f0f14f83b22dd31dd03f/plugins/communicators/ssh/communicator.rb#L185-L200
          begin
            Timeout.timeout(35) do
              while true
                return true if @machine.communicate.ready?
                sleep 0.5
              end
            end
          rescue Timeout::Error
            @env[:ui].warn(I18n.t('vagrant_cachier.unable_to_ssh'))
          end

          return false
        end

        def symlinks
          # TODO: Check if file exists instead of a blank rescue
          @symlinks ||= @machine.data_dir.join('cache_dirs').read.split rescue []
        end

        def remove_symlink(symlink)
          if @machine.communicate.test("test -L #{symlink}")
            @logger.info "Removing symlink for '#{symlink}'"
            @machine.communicate.sudo("unlink #{symlink}")
          end
        end
      end
    end
  end
end
