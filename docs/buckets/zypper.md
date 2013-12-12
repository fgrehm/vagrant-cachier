# Zypper

Used by SuSE guests, will get configured under guest's `/var/cache/zypp/packages`. It will
also [make sure](lib/vagrant-cachier/bucket/zypper.rb#L20) that `keep-packages` is enabled
for all repositories.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-suse-box'
  config.cache.enable :zypper
end
```
