# vagrant-cachier

A [Vagrant](http://www.vagrantup.com/) plugin that helps you reduce the amount of
coffee you drink while waiting for boxes to be provisioned by sharing a common
package cache among similiar VM instances. Kinda like [vagrant-apt_cache](https://github.com/avit/vagrant-apt_cache)
or [this magical snippet](http://gist.github.com/juanje/3797297) but targetting
multiple package managers and Linux distros.


## Installation

Make sure you have Vagrant 1.4+ and run:

```
vagrant plugin install vagrant-cachier
```

## Quick start

The easiest way to set things up is just to enable [cache buckets auto detection](http://fgrehm.viewdocs.io/vagrant-cachier/usage)
from within your `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'your-box'
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
    # If you are using VirtualBox, you might want to enable NFS for shared folders
    # config.cache.enable_nfs  = true
    # You can pass extra mount options, for example:
    # config.cache.sync_opts = {:create = true}
  end
end
```

For more information please read the documentation available at
http://fgrehm.viewdocs.io/vagrant-cachier.


## Compatible providers

* Vagrant's built in VirtualBox provider
* [vagrant-lxc](https://github.com/fgrehm/vagrant-lxc)
* [VMware providers](http://www.vagrantup.com/vmware) with NFS enabled (See
  [GH-24](https://github.com/fgrehm/vagrant-cachier/issues/24) for more info)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fgrehm/vagrant-cachier/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
