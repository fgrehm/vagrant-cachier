module VagrantPlugins
  module Cachier
    class Bucket
      def self.inherited(base)
        @buckets ||= []
        @buckets << base
      end

      def self.auto_detect(env)
        @buckets.each do |bucket|
          if env[:machine].guest.capability?(bucket.capability)
            env[:machine].config.cache.enable bucket.bucket_name
          end
        end
      end

      def self.bucket_name
        class_name = self.name.split('::').last
        class_name.scan(/[A-Z][a-z]*/).map{|x| x.downcase}.join("_")
      end

      def self.install(name, env, configs)
        bucket = const_get(name.to_s.split("_").map{|x| x.capitalize}.join(""))
        bucket.new(name, env, configs).install
      end

      def initialize(name, env, configs)
        @name    = name
        @env     = env
        @configs = configs
      end
    end
  end
end

require_relative "bucket/apt"
require_relative "bucket/chef"
require_relative "bucket/gem"
require_relative "bucket/pacman"
require_relative "bucket/yum"
require_relative "bucket/rvm"
require_relative "bucket/apt_cacher"
require_relative "bucket/npm"
