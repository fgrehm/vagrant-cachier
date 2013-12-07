# RubyGems

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-ruby-installed'
  config.cache.enable :gem
end
```

Compatible with probably with any type of guest distro, will hook into the `cache`
folder under the result of running `gem env gemdir` as the default SSH user (usualy
`vagrant`) on your guest. If you use rbenv / rvm on the guest machine, make sure
it is already installed before enabling the bucket, otherwise you won't benefit
from this plugin.
