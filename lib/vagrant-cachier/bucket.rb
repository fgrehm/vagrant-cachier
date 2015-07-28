module VagrantPlugins
  module Cachier
    class Bucket
      def self.inherited(base)
        @buckets ||= []
        @buckets << base
      end

      def self.auto_detect(env)
        @buckets.each do |bucket|
          if bucket.respond_to?(:capability) && env[:machine].guest.capability?(bucket.capability)
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

      def machine
        @env[:machine]
      end

      def guest
        machine.guest
      end

      def comm
        machine.communicate
      end

      # TODO: "merge" symlink and user_symlink methods
      def symlink(guest_path, bucket_path = "/tmp/vagrant-cache/#{@name}")
        return if @env[:cache_dirs].include?(guest_path)

        @env[:cache_dirs] << guest_path
        comm.execute("mkdir -p #{bucket_path}")
        unless symlink?(guest_path)
          comm.sudo("mkdir -p `dirname #{guest_path}`")
          if empty_dir?(bucket_path) && !empty_dir?(guest_path)
            # Warm up cache with guest machine data
            comm.sudo("shopt -s dotglob && mv #{guest_path}/* #{bucket_path}")
          end
          comm.sudo("rm -rf #{guest_path}")
          comm.sudo("ln -s #{bucket_path} #{guest_path}")
        end
      end

      def user_symlink(guest_path)
        return if @env[:cache_dirs].include?(guest_path)

        @env[:cache_dirs] << guest_path
        bucket_path = "/tmp/vagrant-cache/#{@name}"
        comm.execute("mkdir -p #{bucket_path}")
        unless symlink?(guest_path)
          comm.execute("mkdir -p `dirname #{guest_path}`")
          if empty_dir?(bucket_path) && !empty_dir?(guest_path)
            # Warm up cache with guest machine data
            comm.execute("shopt -s dotglob && mv #{guest_path}/* #{bucket_path}")
          end
          comm.execute("rm -rf #{guest_path}")
          comm.execute("ln -s #{bucket_path} #{guest_path}")
        end
      end

      def empty_dir?(path)
        not comm.test("test \"$(ls -A #{path} 2>/dev/null)\"")
      end

      def symlink?(path)
        comm.test("test -L #{path}")
      end
    end
  end
end

require_relative "bucket/apt"
require_relative "bucket/chef"
require_relative "bucket/gem"
require_relative "bucket/chef_gem"
require_relative "bucket/pacman"
require_relative "bucket/yum"
require_relative "bucket/rvm"
require_relative "bucket/apt_cacher"
require_relative "bucket/apt_lists"
require_relative "bucket/composer"
require_relative "bucket/bower"
require_relative "bucket/npm"
require_relative "bucket/zypper"
require_relative "bucket/generic"
require_relative "bucket/pip"
