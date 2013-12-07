# Development

## Installing from sources

If you want to install the plugin from sources:

```bash
git clone https://github.com/fgrehm/vagrant-cachier.git
cd vagrant-cachier
bundle install
bundle exec rake build
vagrant plugin install pkg/vagrant-cachier-VERSION.gem
```


## Sanity checks

While we don't get to implement some proper unit testing, there are some basic [Bats](https://github.com/sstephenson/bats)
tests that basically acts as a [sanity check](https://github.com/fgrehm/vagrant-cachier/blob/master/spec/acceptance/sanity_check.bats)
that you can run with `bats spec/acceptance` in case you are planning to submit a
Pull Request. Just keep in mind that it might take a while to run if you are
using the default VirtualBox provider.


## How to create a new bucket?

The concept of a cache _bucket_ is pretty easy to understand, we basically
symlink a folder under the guest's `/tmp/vagrant-cache` into the folder where
other tools keep downloaded packages. For example, in the case of the
[apt bucket](buckets/apt), we symlink `/var/cache/apt/archives` to
`/tmp/vagrant-cache/apt` so that `.deb` packages downloaded with `apt-get install`
can be reused when bringing machines up from scratch.

If you want to see some other package manager supported, you'll first need to
know if it has some sort of caching in place, where does it get stored and if
it needs some extra configuration. For some managers that path will be fixed
(like the canonical apt bucket), for others you might need to read some
configuration by [running a command](https://github.com/fgrehm/vagrant-cachier/blob/master/lib/vagrant-cachier/cap/linux/rvm_path.rb#L10)
on the guest VM (like [rvm](buckets/rvm)) and you might even need to [tweak some configs](https://github.com/fgrehm/vagrant-cachier/blob/master/lib/vagrant-cachier/bucket/yum.rb#L20)
on the guest (like the [yum](buckets/yum) bucket).

There's currently a lot of duplication around the "installation" of cache buckets
so there's plenty of source code for you to read in order to understand how
things work under the hood but if you don't feel comfortable reading / writing
Ruby code you can provide a high level overview of how to do things using plain
old bash.

For example, if you were to explain how to set up the rvm bucket, the script
below should give vagrant-cachier maintainers an overview of how to set things
up:

```bash
# Check is rvm is installed
if ! $(rvm info > /dev/null); then
  exit 0
fi

# If it is installed, read the cache dir
RVM_CACHE="${rvm_path}/archives"

# "Install" the bucket!
mkdir -p /tmp/vagrant-cache/rvm/archives
ln -s /tmp/vagrant-cache/rvm/archives $RVM_CACHE
```
