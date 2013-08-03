module VagrantPlugins
  module Cachier
    module Errors
      class MultipleProviderSpecificCacheDirsFound < Vagrant::Errors::VagrantError
        error_key(:multiple_provider_specific_cache_dirs_found)
      end
    end
  end
end
