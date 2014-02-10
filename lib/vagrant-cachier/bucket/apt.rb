module VagrantPlugins
  module Cachier
    class Bucket
      class Apt < Bucket
        def self.capability
          :apt_cache_dir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:apt_cache_dir)
            apt_capability = guest.capability(:apt_cache_dir) 
            machine.communicate.tap do |comm|
              create_apt_symlink(comm, apt_capability[:archives_dir])
              create_apt_symlink(comm, apt_capability[:lists_dir])
            end
          else
            @env[:ui].info I18n.t('vagrant_cachier.skipping_bucket', bucket: 'APT')
          end
        end

        private
        def create_apt_symlink(comm, path)
          @env[:cache_dirs] << path
          folder = File.basename(path)	
          comm.execute("mkdir -p /tmp/vagrant-cache/#{@name}/#{folder}/partial")
          unless comm.test("test -L #{path}")
            comm.sudo("rm -rf #{path}")
            comm.sudo("mkdir -p `dirname #{path}`")
            comm.sudo("ln -s /tmp/vagrant-cache/#{@name}/#{folder} #{path}")
          end
        end	
      end
    end
  end
end
