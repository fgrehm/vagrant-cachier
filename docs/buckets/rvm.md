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
