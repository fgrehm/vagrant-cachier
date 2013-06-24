require 'tempfile'

module VagrantPlugins
  module Cachier
    class Action
      class ConfigureAptProxy
        attr_reader :logger

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::cachier::action::configure_apt_proxy")
        end

        def call(env)
          @app.call env

          proxy_config = env[:machine].config.apt_proxy
          if !proxy_config.enabled?
            logger.debug "apt_proxy not enabled or configured"
          elsif !proxy_conf_capability?(env[:machine])
            env[:ui].info "Skipping Apt proxy config as the machine does not support it"
          else
            env[:ui].info "Configuring proxy for Apt..."
            write_apt_proxy_conf(env[:machine], proxy_config)
          end
        end

        def write_apt_proxy_conf(machine, config)
          logger.debug "Configuration:\n#{config}"

          temp = Tempfile.new("vagrant")
          temp.binmode
          temp.write(config)
          temp.close

          machine.communicate.tap do |comm|
            comm.upload(temp.path, "/tmp/vagrant-apt-proxy-conf")
            comm.sudo("cat /tmp/vagrant-apt-proxy-conf > #{proxy_conf_path(machine)}")
            comm.sudo("rm /tmp/vagrant-apt-proxy-conf")
          end
        end

        def proxy_conf_capability?(machine)
          machine.guest.capability?(:apt_proxy_conf)
        end

        def proxy_conf_path(machine)
          machine.guest.capability(:apt_proxy_conf)
        end
      end
    end
  end
end
