# [Composer](http://getcomposer.org/)

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-php-installed'
  config.cache.enable :composer
end
```

Compatible with probably any type of linux guest distro, will cache guests'
`$HOME/.composer` if PHP is detected.
