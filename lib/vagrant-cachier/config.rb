module VagrantPlugins
  module Cachier
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :scope, :auto_detect
      attr_reader   :buckets

      def initialize
        @scope       = UNSET_VALUE
        @auto_detect = UNSET_VALUE
      end

      def enable(bucket, opts = {})
        (@buckets ||= {})[bucket] = opts
      end

      def finalize!
        return unless enabled?

        @scope       = :box  if @scope == UNSET_VALUE
        @auto_detect = false if @auto_detect == UNSET_VALUE
        @buckets     = @buckets ? @buckets.dup : {}
      end

      def enabled?
        @enabled ||= @auto_detect != UNSET_VALUE ||
                     @buckets != nil
      end
    end
  end
end
