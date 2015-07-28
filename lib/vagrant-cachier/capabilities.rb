module VagrantPlugins
  module Cachier
    class Plugin < Vagrant.plugin('2')
      guest_capability 'linux', 'gemdir' do
        require_relative 'cap/linux/gemdir'
        Cap::Linux::Gemdir
      end

      guest_capability 'linux', 'chef_gemdir' do
        require_relative 'cap/linux/chef_gemdir'
        Cap::Linux::ChefGemdir
      end

      guest_capability 'linux', 'rvm_path' do
        require_relative 'cap/linux/rvm_path'
        Cap::Linux::RvmPath
      end

      guest_capability 'linux', 'composer_path' do
        require_relative 'cap/linux/composer_path'
        Cap::Linux::ComposerPath
      end

      guest_capability 'linux', 'bower_path' do
        require_relative 'cap/linux/bower_path'
        Cap::Linux::BowerPath
      end

      guest_capability 'linux', 'chef_file_cache_path' do
        require_relative 'cap/linux/chef_file_cache_path'
        Cap::Linux::ChefFileCachePath
      end

      guest_capability 'linux', 'npm_cache_dir' do
        require_relative 'cap/linux/npm_cache_dir'
        Cap::Linux::NpmCacheDir
      end

      guest_capability 'linux', 'pip_cache_dir' do
        require_relative 'cap/linux/pip_cache_dir'
        Cap::Linux::PipCacheDir
      end
      
      guest_capability 'debian', 'apt_cache_dir' do
        require_relative 'cap/debian/apt_cache_dir'
        Cap::Debian::AptCacheDir
      end

      guest_capability 'debian', 'apt_cacher_dir' do
        require_relative 'cap/debian/apt_cacher_dir'
        Cap::Debian::AptCacherDir
      end

      guest_capability 'debian', 'apt_lists_dir' do
        require_relative 'cap/debian/apt_lists_dir'
        Cap::Debian::AptListsDir
      end

      guest_capability 'redhat', 'yum_cache_dir' do
        require_relative 'cap/redhat/yum_cache_dir'
        Cap::RedHat::YumCacheDir
      end

      guest_capability 'suse', 'yum_cache_dir' do
        # Disable Yum on suse guests
      end

      guest_capability 'arch', 'pacman_cache_dir' do
        require_relative 'cap/arch/pacman_cache_dir'
        Cap::Arch::PacmanCacheDir
      end

      guest_capability 'suse', 'zypper_cache_dir' do
        require_relative 'cap/suse/zypper_cache_dir'
        Cap::SuSE::ZypperCacheDir
      end
    end
  end
end
