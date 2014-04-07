zip_filepath = "#{Chef::Config['file_cache_path']}/vagrant-cachier.tar.gz"
zip_url      = "https://github.com/fgrehm/vagrant-cachier/archive/v0.6.0.tar.gz"

remote_file(zip_filepath) { source zip_url }
