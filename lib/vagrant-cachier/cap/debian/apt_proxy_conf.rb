module VagrantPlugins
  module Cachier
    module Cap
      module Debian
        module AptProxyConf
          def self.apt_proxy_conf(machine)
            '/etc/apt/apt.conf.d/01proxy'
          end
        end
      end
    end
  end
end
