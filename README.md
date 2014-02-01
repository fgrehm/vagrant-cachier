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
    # Enable cache buckets auto detection
    config.cache.auto_detect = true

    # If you are using VirtualBox, you might want to use that to enable NFS for
    # shared folders. This is also very useful for vagrant-libvirt if you want
    # bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options = ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
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
* [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fgrehm/vagrant-cachier/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
