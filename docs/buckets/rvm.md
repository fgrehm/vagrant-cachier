# [rvm](https://rvm.io/)

Compatible with probably with any type of linux guest distro, will hook into the
`cache` folder under the result of running rvm info as the default SSH user (usualy
`vagrant`) on your guest. If you use rvm on the guest machine, make sure it is
already installed before enabling the bucket, otherwise you won't benefit from
this plugin.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-rvm-installed'
  config.cache.enable :gem
end
```

## Heads up!

If you are installing rvm, rubies and gems on a single provisioning step, **you
will not benefit from this bucket**. There is absolutely no way we can "magically"
hook into your provisioning scripts to configure things for leveraging the cache.

For instance, the following shell provisioner **will result in no package cached at
all**:

```ruby
config.vm.provision :shell, privileged: false, inline: %[
  curl -L https://get.rvm.io | bash -s stable
  rvm install 1.9.3
  rvm use 1.9.3 --default
  cd /path/to/project
  bundle install
]
```

To work around that you can either configure things by hand on your provisioning
scripts or you can enable automatic bucket detection and split your scripts into
multiple stages:

```ruby
# Install RVM so that Ruby tarballs are cached
config.vm.provision :shell, privileged: false, inline: %[
  curl -L https://get.rvm.io | bash -s stable
]

# Install Ruby 1.9.3 making use of the RVM cache and configure the RubyGems
# cache afterwards
config.vm.provision :shell, privileged: false, inline: %[
  rvm install 1.9.3
  rvm use 1.9.3 --default
]

# Install gems making use of the RubyGems cache
config.vm.provision :shell, privileged: false, inline: %[
  cd /path/to/project
  bundle install
]
```
