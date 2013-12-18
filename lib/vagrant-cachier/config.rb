module VagrantPlugins
  module Cachier
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :scope, :auto_detect, :enable_nfs, :mount_options
      attr_reader   :buckets

      ALLOWED_SCOPES = %w( box machine )

      def initialize
        @scope         = UNSET_VALUE
        @auto_detect   = UNSET_VALUE
        @enable_nfs    = UNSET_VALUE
        @mount_options = UNSET_VALUE
      end

      def enable(bucket, opts = {})
        (@buckets ||= {})[bucket] = opts
      end

      def validate(machine)
        errors = _detected_errors

        if enabled? && ! ALLOWED_SCOPES.include?(@scope.to_s)
          errors << I18n.t('vagrant_cachier.unknown_cache_scope',
                            allowed:     ALLOWED_SCOPES.inspect,
                            cache_scope: @scope)
        end

        { "vagrant cachier" => errors }
      end

      def finalize!
        return unless enabled?

        @scope         = :box  if @scope == UNSET_VALUE
        @auto_detect   = false if @auto_detect == UNSET_VALUE
        @enable_nfs    = false if @enable_nfs == UNSET_VALUE
        @mount_options = false if @mount_options == UNSET_VALUE
        @buckets       = @buckets ? @buckets.dup : {}
      end

      def enabled?
        @enabled ||= @auto_detect != UNSET_VALUE ||
                     @buckets != nil
      end
    end
  end
end
