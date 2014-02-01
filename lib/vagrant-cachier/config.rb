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
      end

      def enable(bucket, opts = {})
        (@buckets ||= {})[bucket] = opts
      end

      def enable_nfs=(value)
        # Flag to raise warning on #validate
        @_enable_nfs_set = true
        @synced_folder_opts = { type: 'nfs', nfs: true } if value
      end

      def validate(machine)
        if @_enable_nfs_set
          machine.ui.warn "The `enable_nfs` config for vagrant-cachier has been deprecated " \
              "and will be removed on 0.7.0, please use " \
              "`synced_folder_opts = { type: 'nfs' }` instead."
        end

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

        @scope = :box  if @scope == UNSET_VALUE
        @auto_detect = false if @auto_detect == UNSET_VALUE
        @synced_folder_opts = nil if @synced_folder_opts == UNSET_VALUE
        @buckets = @buckets ? @buckets.dup : {}
      end

      def enabled?
        @enabled ||= @auto_detect != UNSET_VALUE ||
                     @buckets != nil
      end
    end
  end
end
