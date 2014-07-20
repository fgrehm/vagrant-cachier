module VagrantPlugins
  module Cachier
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :scope, :auto_detect, :synced_folder_opts
      attr_reader   :buckets

      ALLOWED_SCOPES = %w( box machine )

      def initialize
        @scope = UNSET_VALUE
        @auto_detect = UNSET_VALUE
        @synced_folder_opts = UNSET_VALUE
        @ui = Vagrant::UI::Colored.new
      end

      def enable(bucket, opts = {})
        (@buckets ||= {})[bucket] = opts
      end

      def validate(machine)
        errors = _detected_errors

        if enabled? && backed_by_cloud_provider?(machine)
          machine.ui.warn(I18n.t('vagrant_cachier.backed_by_cloud_provider',
                                 provider: machine.provider_name))
          disable!
        end

        if enabled? && ! ALLOWED_SCOPES.include?(@scope.to_s)
          errors << I18n.t('vagrant_cachier.unknown_cache_scope',
                            allowed:     ALLOWED_SCOPES.inspect,
                            cache_scope: @scope)
        end

        { "vagrant cachier" => errors }
      end

      def enabled?
        return @enabled unless @enabled.nil?

        @enabled = @scope != UNSET_VALUE
      end

      def disable!
        @enabled = false
      end

      def finalize!
        return unless enabled?

        @auto_detect = true if @auto_detect == UNSET_VALUE
        @synced_folder_opts = nil if @synced_folder_opts == UNSET_VALUE
        @buckets = @buckets ? @buckets.dup : {}
      end

      private

      def backed_by_cloud_provider?(machine)
        CLOUD_PROVIDERS.include?(machine.provider_name.to_s)
      end
    end
  end
end
