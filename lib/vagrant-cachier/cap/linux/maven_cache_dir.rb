module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module MavenCacheDir
          def self.maven_cache_dir(machine)
            maven_cache_dir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which mvn')
              comm.execute 'echo $HOME' do |buffer, output|
                maven_cache_dir = output.chomp if buffer == :stdout
              end
            end
            return "#{maven_cache_dir}/.m2/repository"
          end
        end
      end
    end
  end
end
