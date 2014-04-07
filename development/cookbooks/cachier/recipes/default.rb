zip_filepath = "#{Chef::Config['file_cache_path']}/vagrant-cachier.zip"
zip_url      = "https://github.com/fgrehm/vagrant-cachier/archive/master.zip"

remote_file(zip_filepath) { source zip_url }
