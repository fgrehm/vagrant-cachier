# [Composer](http://getcomposer.org/)

Compatible with probably any type of linux guest distro, will cache guests'
`$HOME/.composer/cache` if PHP is detected.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-php-installed'
  config.cache.enable :composer
end
```
