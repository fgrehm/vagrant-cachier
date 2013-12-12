# APT

Used by Debian-like Linux distros, will get configured under guest's `/var/cache/apt/archives`.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-debian-box'
  config.cache.enable :apt
end
```

_Please note that to avoid re-downloading packages, you should avoid `apt-get clean`
as much as possible in order to make a better use of the cache, even if you are
packaging a box since the downloaded packages are actually stored on the host
machine._
