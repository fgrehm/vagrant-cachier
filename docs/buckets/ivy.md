# [Ivy](http://ant.apache.org/ivy/)

Compatible with probably any type of linux guest distro, will cache guests'
`$HOME/.ivy2/cache` if sbt is detected.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-sbt-installed'
  config.cache.enable :ivy
end
```
