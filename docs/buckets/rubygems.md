# RubyGems

Compatible with probably with any type of guest distro, will hook into the `cache`
folder under the result of running `gem env gemdir` as the default SSH user (usualy
`vagrant`) on your guest. If you use rbenv / rvm on the guest machine, make sure
it is already installed before enabling the bucket, otherwise you won't benefit
from this plugin.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-box-with-ruby-installed'
  config.cache.enable :gem
end
```

## Heads up about `bundle install --deployment`

Please note that when the `--deployment` flag is passed on to `bundle install`
your gems **will not be cached** since bundler ends up skipping the default gem
cache dir. For more information about this, please check [GH-62](https://github.com/fgrehm/vagrant-cachier/issues/62).
