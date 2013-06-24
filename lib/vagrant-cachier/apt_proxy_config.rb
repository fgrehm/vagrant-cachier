require 'vagrant'

module VagrantPlugins
  module Cachier
    class AptProxyConfig < Vagrant.plugin("2", :config)
      # HTTP proxy for Apt
      attr_accessor :http

      # HTTPS proxy for Apt
      attr_accessor :https

      def initialize
        @http  = UNSET_VALUE
        @https = UNSET_VALUE
      end

      def finalize!
        @http = override_from_env_var('http', @http)
        @http = nil if @http == UNSET_VALUE

        @https = override_from_env_var('https', @https)
        @https = nil if @https == UNSET_VALUE
      end

      def enabled?
        !http.nil? || !https.nil?
      end

      # @return [String] the full configuration stanza
      def to_s
        "#{config_for('http')}#{config_for('https')}"
      end

      private

      def override_from_env_var(proto, default)
        ENV.fetch("APT_PROXY_#{proto.upcase}", default)
      end

      def config_for(proto)
        ConfigValue.new(proto, send(proto.to_sym))
      end

      class ConfigValue

        attr_reader :proto, :value

        # @param proto [String] the protocol ("http", "https")
        # @param value [Object] the configuration value
        def initialize(proto, value)
          @proto = proto
          @value = value
        end

        # @return [String] the full Apt configuration line
        def to_s
          set? ? %Q{Acquire::#{proto}::Proxy "#{proxy_uri}";\n} : ""
        end

        private

        def set?
          value && !value.empty?
        end

        def direct?
          value.upcase == "DIRECT"
        end

        def proxy_uri
          direct? ? "DIRECT" : "#{prefix}#{value}#{suffix}"
        end

        def prefix
          "#{proto}://" if value !~ %r{^.*://}
        end

        def suffix
          ":#{default_port}" if value !~ %r{:\d+$}
        end

        def default_port
          3142
        end
      end
    end
  end
end
