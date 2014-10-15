# [Bower](http://bower.io/)

Compatible with probably any type of linux guest distro, will cache guests'
`$HOME/.cache/bower` if bower is detected.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-bower-installed'
  config.cache.enable :bower
end
```
