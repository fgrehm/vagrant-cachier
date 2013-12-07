# Chef

When a Chef provisioner is detected, this bucket caches the default
`file_cache_path` directory, `/var/chef/cache`. Requires Vagrant 1.2.4+.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-using-chef-provisioner'
  config.cache.enable :chef
end
```
