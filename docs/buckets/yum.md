# Yum

Used by CentOS guests, will get configured under guest's `/var/cache/yum`. It will
also [make sure](lib/vagrant-cachier/bucket/yum.rb#L20) that `keepcache` is set to
`1` on guest's `/etc/yum.conf`.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-centos-box'
  config.cache.enable :yum
end
```
