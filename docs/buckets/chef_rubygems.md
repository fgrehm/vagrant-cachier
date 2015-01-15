# Chef RubyGems

When a Chef installation is detected, this bucket caches its embedded gems.
Most of these gems are part of the Chef omnibus package but sometimes cookbooks
need to install extra gems to run within the context of a Chef recipe using the
`chef_gem` resource.

The embedded Chef gem location is returned by running the
`/opt/chef/embedded/bin/gem env gemdir` command.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-using-chef-provisioner'
  config.cache.enable :chef_gem
end
```
