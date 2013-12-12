# [npm](https://npmjs.org/)

Compatible with probably any type of linux guest distro, will hook into npm's
cache directory under the result of running `npm config get cache` as
the default SSH user (usually `vagrant`) on your guest.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-nodejs-installed'
  config.cache.enable :npm
end
```

If you use [nvm](https://github.com/creationix/nvm) / [n](https://github.com/visionmedia/n)
on the guest machine, make sure it is already installed before enabling
the bucket, otherwise you won't benefit from this plugin.
