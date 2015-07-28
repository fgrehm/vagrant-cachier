# [pip](https://pip.pypa.io/)

Compatible with probably any type of linux guest distro, will hook into pip's
http and wheels cache directory under `$HOME/.cache/pip/http` and `$HOME/.cache/pip/wheels` as
the default SSH user (usually `vagrant`) on your guest.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-pip-installed'
  config.cache.enable :pip
end
```

