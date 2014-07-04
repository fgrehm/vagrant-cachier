## How does it work?

On vagrant-cachier's _"jargon"_, cached packages are kept in _cache buckets_.
Those _buckets_ are basically directories that are shared between the host machine
and VMs that are kept around between `vagrant destroy`s. Each _bucket_ (or synced
folder if you prefer) is meant to cache specific types of packages, like [apt](buckets/apt)'s
`.deb`s or [RubyGems](buckets/rubygems) `.gem`s. Please have a look at the
"Available Buckets" menu above for more information on each bucket.

Regarding configurations, right now the plugin does not make any assumptions for
you and you have to configure things properly from your `Vagrantfile`. In other
words, _the plugin is disabled by default_.

Cache buckets will always be available from `/tmp/vagrant-cache` on your guest and
the appropriate folders will get symlinked to the right path _after_ the machine is
up but _right before_ it gets provisioned. We _could_ potentially do it on one go
and share bucket's folders directly to the right path if we were only using VirtualBox
because it shares folders _after_ booting the machine but the LXC provider does that
_as part of_ the boot process (synced folders are actually `lxc-start` parameters)
and as of now we are not able to get some information that this plugin requires
about the guest machine / container before it is actually up and running.

Under the hood, the plugin will hook into Vagrant in order to set things up for each
configured cache bucket _before and after_ running each defined provisioner. Before
halting the machine, it will also revert the changes required to set things up by
hooking into calls to `Vagrant::Builtin::GracefulHalt` so that you can repackage
the machine for others to use without requiring users to install the plugin as well.

Please keep in mind that this plugin won't do magic, if you are compiling things
during provisioning or manually downloading packages outside of a bucket you
won't see that much of improvement.
