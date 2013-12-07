# Usage

## Configurations

### Auto detect supported cache buckets

This is the easiest way to get started with plugin. By adding the code below to
your `Vagrantfile` you can enable automatic detection of supported cache _buckets_:

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
  config.cache.auto_detect = true
end
```

The cached files will be stored under `$HOME/.vagrant.d/cache/some-box`.

If you are on a [multi VM environment](http://docs.vagrantup.com/v2/multi-machine/index.html),
there is a huge chance that you'll end up having issues by sharing the same bucket
across different machines. For example, if you `apt-get install` from two machines
at "almost the same time" you are probably going to hit a _"SystemError: Failed to
lock /var/cache/apt/archives/lock"_. To work around that, you can set the scope
to be based on machines:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box'
  config.cache.scope = :machine
end
```

This will tell vagrant-cachier to download packages to `.vagrant/machines/<machine-name>/cache`
on your current project directory.


## Finding out disk space used by buckets

At some point there'll be a `vagrant cache stats` command that will give you that
information, but while that does not get implemented you can run the code below
if you are on a Linux machine:

```
# scope = :box (default)
$ du -h -d0 $HOME/.vagrant.d/cache
405M /home/fabio/.vagrant.d/cache/precise64
1.1G /home/fabio/.vagrant.d/cache/raring64
448M /home/fabio/.vagrant.d/cache/quantal64

# scope = :machine
$ du -h -d0 .vagrant/machines/*/cache
16K	 .vagrant/machines/precise/cache
90M	 .vagrant/machines/quantal/cache
210M .vagrant/machines/raring/cache
```

## Cleaning up cache buckets

At some point there'll be a `vagrant cache clean [bucket-name]` command that will
take care of things for you, but while that does not get implemented you can run
the code below if you are on a Linux machine:

```
# scope = :box (default)
$ rm -rf $HOME/.vagrant.d/cache/<box-name>/<optional-bucket-name>

# scope = :machine
$ rm -rf .vagrant/cache/<box-name>/<optional-bucket-name>
```
