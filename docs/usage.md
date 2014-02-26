# Usage

## Being nice to others

It is a good practice to wrap plugin specific configuration with `has_plugin?` checks
so the user's Vagrantfiles do not break if `vagrant-cachier` is uninstalled or
the Vagrantfile is shared with people that don't have the plugin installed:

```ruby
Vagrant.configure("2") do |config|
  # ...
  if Vagrant.has_plugin?("vagrant-cachier")
    # ... vagrant-cachier configs ...
  end
end
```

## Cache scope

This is the only required configuration for the plugin to work and should be present
on your project's specific `Vagrantfile` or on your `~/.vagrant.d/Vagrantfile` in
order to enable it.

### `:box` scope

By setting `cache.scope` to `:box`, downloaded packages will get stored on a folder
scoped to base boxes under your `~/.vagrant.d/cache`. The idea is to leverage the
cache by allowing downloaded packages to be reused across projects. So, if your
`Vagrantfile` has something like:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box'
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
end
```

The cached files will be stored under `$HOME/.vagrant.d/cache/some-box`.

### `:machine` scope

If you are on a [multi VM environment](http://docs.vagrantup.com/v2/multi-machine/index.html),
there is a huge chance that you'll end up having issues by sharing the same bucket
across different machines. For example, if you `apt-get install` from two machines
at "almost the same time" you are probably going to hit a _"SystemError: Failed to
lock /var/cache/apt/archives/lock"_. To work around that, you can set the scope
to be based on machines:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box'
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
  end
end
```

This will tell vagrant-cachier to download packages to `.vagrant/machines/<machine-name>/cache`
on your current project directory.

## Cache buckets automatic detection

This is the easiest way to get started with plugin and is enabled by default.
Under the hood, `vagrant-cachier` does its best to find out what is supported on the
guest machine and will set buckets accordingly.

If you want that behavior to be disabled, you can set `cache.auto_detect` to `false`
from your Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box'
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope       = :machine # or :box
    config.cache.auto_detect = false
  end
end
```

## Enable buckets as needed

If for whatever reason you need to have a fined grained control over what buckets
are configured, you can do so by "cherry picking" them on your `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.cache.auto_detect = false
  config.cache.enable :apt
  config.cache.enable :gem
end
```

_Please refer to the "Available Buckets" menu above to find out which buckets
are supported._

## Custom cache buckets synced folders options

For fine grained control over the cache bucket synced folder options you can use
the `synced_folder_opts` config. That's useful if, for example, you are using
VirtualBox and want to enable NFS for improved performance:

```ruby
Vagrant.configure("2") do |config|
  config.cache.synced_folder_opts = {
    type: :nfs,
    # The nolock option can be useful for an NFSv3 client that wants to avoid the
    # NLM sideband protocol. Without this option, apt-get might hang if it tries
    # to lock files needed for /var/cache/* operations. All of this can be avoided
    # by using NFSv4 everywhere. Please note that the tcp option is not the default.
    mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
  }
end
```

Please referer to http://docs.vagrantup.com/v2/synced-folders/basic_usage.html for
more information about the supported parameters.

## Finding out disk space used by buckets

At some point we might implement a `vagrant cache stats` command that will give you that
information, but while that does not get implemented you can run the code below
if you are on a Linux machine:

```
# scope = :box (default)
$ du -h -d0 $HOME/.vagrant.d/cache
405M /home/user/.vagrant.d/cache/precise64
1.1G /home/user/.vagrant.d/cache/raring64
448M /home/user/.vagrant.d/cache/quantal64

# scope = :machine
$ du -h -d0 .vagrant/machines/*/cache
16K	 .vagrant/machines/precise/cache
90M	 .vagrant/machines/quantal/cache
210M .vagrant/machines/raring/cache
```

## Cleaning up cache buckets

At some point we might implement a `vagrant cache clean [bucket-name]` command that will
take care of things for you, but while that does not get implemented you can run
the code below if you are on a Linux machine:

```
# scope = :box (default)
$ rm -rf $HOME/.vagrant.d/cache/<box-name>/<optional-bucket-name>

# scope = :machine
$ rm -rf .vagrant/machines/<machine-name>/cache/<optional-bucket-name>
```
