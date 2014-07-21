# APT lists

Used by Debian-like Linux distros, will get configured under guest's `/var/lib/apt/lists`.

As explained on [Wikipedia](http://en.wikipedia.org/wiki/Advanced_Packaging_Tool#Files),
`/var/lib/apt/lists` is the "storage area for state information for each package
resource specified in sources.list". By enabling this bucket, `apt` will be able
to install cached packages without hitting the remote repositories for the main
package lists, [being particularly useful when developing offline](https://github.com/fgrehm/vagrant-cachier/pull/84#issue-27311414).

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-debian-box'
  config.cache.enable :apt_lists
end
```

## Heads up!

This bucket is automatically disabled for Windows hosts, please have a look at
the following issues for more information:

* https://github.com/fgrehm/vagrant-cachier/issues/106
* https://github.com/fgrehm/vagrant-cachier/issues/109
* https://github.com/fgrehm/vagrant-cachier/issues/113
