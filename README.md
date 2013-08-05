# vagrant-cachier

A [Vagrant](http://www.vagrantup.com/) plugin that helps you reduce the amount of
coffee you drink while waiting for boxes to be provisioned by sharing a common
package cache among similiar VM instances. Kinda like [vagrant-apt_cache](https://github.com/avit/vagrant-apt_cache)
or [this magical snippet](http://gist.github.com/juanje/3797297) but targetting
multiple package managers and Linux distros.


## Installation

Make sure you have Vagrant 1.2+ and run:

```
vagrant plugin install vagrant-cachier
```

## Usage

The easiest way to set things up is just to enable [cache buckets auto detection](#auto-detect-supported-cache-buckets)
from within your `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'your-box'
  config.cache.auto_detect = true
  # If you are using VirtualBox, you might want to enable NFS for shared folders
  # config.cache.enable_nfs  = true
end
```

For more information about available buckets, please see the [configuration section](#configurations) below.


## Compatible providers

* Vagrant's built in VirtualBox provider
* [vagrant-lxc](https://github.com/fgrehm/vagrant-lxc)
* [VMware providers](http://www.vagrantup.com/vmware) with NFS enabled (See
  [GH-24](https://github.com/fgrehm/vagrant-cachier/issues/24) for more info)

## How does it work?

Right now the plugin does not make any assumptions for you and you have to
configure things properly from your `Vagrantfile`. Please have a look at
the [available cache buckets](#available-cache-buckets) section below for more
information.

Under the hood, the plugin will monkey patch `Vagrant::Builtin::Provision` and
will set things up for each configured cache bucket before running each defined
provisioner and after all provisioners are done. Before halting the machine,
it will revert the changes required to set things up by hooking into calls to
`Vagrant::Builtin::GracefulHalt` so that you can repackage the machine for others
to use without requiring users to install the plugin as well.

Cache buckets will be available from `/tmp/vagrant-cachier` on your guest and
the appropriate folders will get symlinked to the right path _after_ the machine is
up but _right before_ it gets provisioned. We _could_ potentially do it on one go
and share bucket's folders directly to the right path if we were only using VirtualBox
since it shares folders _after_ booting the machine, but the LXC provider does that
_as part of_ the boot process (shared folders are actually `lxc-start` parameters)
and as of now we are not able to get some information that this plugin requires
about the guest machine before it is actually up and running.

Please keep in mind that this plugin won't do magic, if you are compiling things
during provisioning or manually downloading packages that does not fit into a
"cache bucket" you won't see that much of improvement.


## Benchmarks / shameless plug

Please have a look at [this blog post](http://fabiorehm.com/blog/2013/05/24/stop-wasting-bandwidth-with-vagrant-cachier#show_me_the_numbers)
for the numbers I've got down here.


## Configurations

### Auto detect supported cache buckets

As described on the usage section above, you can enable automatic detection of
supported [cache "buckets"](#available-cache-buckets) by adding the code below to
your `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  # ...
  config.cache.auto_detect = true
end
```

This will make vagrant-cachier do its best to find out what is supported on the
guest machine and will set buckets accordingly.

### Cache scope

By default downloaded packages will get stored on a folder scoped to base boxes
under your `$HOME/.vagrant.d/cache`. The idea is to leverage the cache by allowing
downloaded packages to be reused across projects. So, if your `Vagrantfile` has
something like:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box'
end
```

The cached files will be stored under `$HOME/.vagrant.d/cache/some-box`.

If you are on a [multi VM environment](http://docs.vagrantup.com/v2/multi-machine/index.html),
there is a huge chance that you'll end up having issues by sharing the same bucket
across different machines. For example, if you `apt-get install` from two machines
at "almost the same time" you are probably going to hit a `SystemError: Failed to lock /var/cache/apt/archives/lock`.
To work around that, you can set the scope to be based on machines:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box'
  config.cache.scope = :machine
end
```

This will tell vagrant-cachier to download packages to `.vagrant/machines/<machine-name>/<provider-name>/cache`
on your current project directory.


### Available cache "buckets"

#### System package managers

##### APT

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-debian-box'
  config.cache.enable :apt
end
```

Used by Debian-like Linux distros, will get configured under guest's `/var/cache/apt/archives`.

_Please note that to avoid re-downloading packages, you should avoid `apt-get clean`
as much as possible in order to make a better use of the cache, even if you are
packaging a box_

##### Yum

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-centos-box'
  config.cache.enable :yum
end
```

Used by CentOS guests, will get configured under guest's `/var/cache/yum`. It will
also [make sure](lib/vagrant-cachier/bucket/yum.rb#L20) that `keepcache` is set to
`1` on guest's `/etc/yum.conf`.

##### Pacman

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-arch-linux-box'
  config.cache.enable :pacman
end
```

Used by Arch Linux, will get configured under guest's `/var/cache/pacman/pkg`.

#### Chef

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-using-chef-provisioner'
  config.cache.enable :chef
end
```

When a Chef provisioner is detected, this bucket caches the default
`file_cache_path` directory, `/var/chef/cache`. Requires Vagrant 1.2.4+.

#### RubyGems

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-ruby-installed'
  config.cache.enable :gem
end
```

Compatible with probably with any type of guest distro, will hook into the `cache`
folder under the result of running `gem env gemdir` as the default SSH user (usualy
`vagrant`) on your guest. If you use rbenv / rvm on the guest machine, make sure
it is already installed before enabling the bucket, otherwise you won't benefit
from this plugin.

#### RVM

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-rvm-installed'
  config.cache.enable :rvm
end
```

Compatible with probably with any type of linux guest distro, will hook into the `cache`
folder under the result of running `rvm info` as the default SSH user (usualy
`vagrant`) on your guest. If you use rvm on the guest machine, make sure
it is already installed before enabling the bucket, otherwise you won't benefit
from this plugin.

## Finding out disk space used by buckets

_TODO_

```shell
$ vagrant cache stats
```


## Cleaning up cache buckets

_TODO_

```shell
$ vagrant cache clean apt
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
