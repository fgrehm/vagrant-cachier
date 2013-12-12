# Pacman

Used by Arch Linux, will get configured under guest's `/var/cache/pacman/pkg`.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-arch-linux-box'
  config.cache.enable :pacman
end
```
