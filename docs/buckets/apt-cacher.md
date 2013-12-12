# APT-CACHER

Used by Debian-like Linux distros, will get configured under guest's `/var/cache/apt-cacher-ng`
and only works with NFS-shared folders since `vboxsf` is enforcing `vagrant`-user and `apt-cacher`
is running under `apt-cacher-ng` user.

To manually enable it:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'some-debian-box'
  config.cache.enable :apt_cacher
end
```

One use case for this bucket is if you are using containers inside your VMs, e.g
VirtualBox -> LXC. This would allow you to reuse packages without sharing folder
inside VirtualBox:

    # install apt-cacher on (Host)-VM
    $ sudo apt-get install apt-cacher-ng

    # get the IP for eth0 interface
    $ ifconfig eth0 |grep "inet addr"|awk '{print $2}' |cut -c6-20

    # configure mirror on for your docker/LXC instances:
    $ echo 'Acquire::http { Proxy "http://X.X.X.X:3142"; };' > /etc/apt/apt.conf.d/10mirror

    # check, if working by tailing log on (Host)-VM, while installing packages on (Guest)-VMs
    $ tail -f /var/log/apt-cacher-ng/apt-cacher.log
