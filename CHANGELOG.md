## [1.2.1](https://github.com/fgrehm/vagrant-cachier/compare/v1.2.0...v1.2.1) (July 3, 2015)

IMPROVEMENTS:

  - Add chef\_zero support to chef bucket [[GH-153]]

[GH-153]: https://github.com/fgrehm/vagrant-cachier/issues/153

## [1.2.0](https://github.com/fgrehm/vagrant-cachier/compare/v1.1.0...v1.2.0) (Jan 14, 2015)

FEATURES:

  - [Chef Gems bucket](http://fgrehm.viewdocs.io/vagrant-cachier/buckets/chef_rubygems) [[GH-129]]

[GH-129]: https://github.com/fgrehm/vagrant-cachier/pull/129

BUG FIXES:

  - Fix provisioner resolution on Vagrant 1.7+ [[GH-133]] / [[GH-134]]
  - Do not modify Vagrant core object, preventing unpredictable behavior [[GH-135]]

[GH-133]: https://github.com/fgrehm/vagrant-cachier/issues/133
[GH-134]: https://github.com/fgrehm/vagrant-cachier/pull/134
[GH-135]: https://github.com/fgrehm/vagrant-cachier/pull/135


## [1.1.0](https://github.com/fgrehm/vagrant-cachier/compare/v1.0.0...v1.1.0) (Oct 15, 2014)

FEATURES:

  - [Bower bucket](http://fgrehm.viewdocs.io/vagrant-cachier/buckets/bower) [[GH-125]]

[GH-125]: https://github.com/fgrehm/vagrant-cachier/pull/125

IMPROVEMENTS:

  - Resolve $HOME even if VM spits bogus new lines [[GH-122]] / [[GH-124]]

[GH-122]: https://github.com/fgrehm/vagrant-cachier/issues/122
[GH-124]: https://github.com/fgrehm/vagrant-cachier/pull/124

## [1.0.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.9.0...v1.0.0) (Sep 22, 2014)

Public API is considered stable.


## [0.9.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.8.0...v0.9.0) (Aug 9, 2014)

FEATURES:

  - Suport for caching packages for Docker containers that doesn't have a base box specified [[GH-116]]

[GH-116]: https://github.com/fgrehm/vagrant-cachier/pull/116

## [0.8.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.7.2...v0.8.0) (Jul 20, 2014)

BACKWARDS INCOMPATIBILITIES:

  - Removed deprecated `config.enable_nfs` config.
  - Changed composer cache bucket to use `$HOME/.composer/cache` [[GH-89]]

IMPROVEMENTS:

  - Set composer cache bucket ownership to the configured SSH user.

BUG FIXES:

  - Automatically disable apt-lists bucket when a Windows host is detected [[GH-106]]
  - Skip `chmod 777` for `smb` mounted folders [[GH-107]]
  - Do not error if base box has been removed and `:box` is configured as the cache scope [[GH-86]]

[GH-86]: https://github.com/fgrehm/vagrant-cachier/issues/86
[GH-89]: https://github.com/fgrehm/vagrant-cachier/issues/89
[GH-106]: https://github.com/fgrehm/vagrant-cachier/issues/106
[GH-107]: https://github.com/fgrehm/vagrant-cachier/issues/107

## [0.7.2](https://github.com/fgrehm/vagrant-cachier/compare/v0.7.1...v0.7.2) (May 08, 2014)

IMPROVEMENTS:

  - Add `azure`, `brightbox`, `cloudstack`, `vcloud` and `vsphere` to the list
    of known cloud providers [[GH-104]]

[GH-104]: https://github.com/fgrehm/vagrant-cachier/pull/104

## [0.7.1](https://github.com/fgrehm/vagrant-cachier/compare/v0.7.0...v0.7.1) (May 04, 2014)

BUG FIXES:

  - Fix support for using multiple generic buckets [[GH-101]]

[GH-101]: https://github.com/fgrehm/vagrant-cachier/pull/101


## [0.7.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.6.0...v0.7.0) (Apr 06, 2014)

FEATURES:

  - ["Generic" cache bucket](http://fgrehm.viewdocs.io/vagrant-cachier/buckets/generic) [[GH-94]] / [[GH-4]].

BUG FIXES:

  - Fix apt-cacher bucket undefined method error [[GH-96]]

[GH-94]: https://github.com/fgrehm/vagrant-cachier/pull/94
[GH-4]: https://github.com/fgrehm/vagrant-cachier/issues/4
[GH-96]: https://github.com/fgrehm/vagrant-cachier/issues/96

## [0.6.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.5.1...v0.6.0) (Feb 26, 2014)

BACKWARDS INCOMPATIBILITIES:

  - Plugin activation is now triggered by the `cache.scope` config and that config
    is now required. Previous versions of the plugin had it set to `:box` but
    there is no consensus whether `:box` and `:machine` is better. This is to
    highlight that you need to think about the caching strategy you are going
    to use. For more information and to discuss this move please check [GH-17](https://github.com/fgrehm/vagrant-cachier/issues/17).
  - Because `cache.scope` is now a requirement and in order to reduce the amount of
    configuration required by the plugin, we enabled automatic bucket detection by
    default. To revert to the old behavior you can disable it globally from your
    `~/.vagrant.d/Vagrantfile`.
  - Support for Vagrant < 1.4 is gone, please use a previous plugin version if
    you are running Vagrant 1.2 / 1.3
  - Automatic handling of multiple machine scoped cache dirs from versions
    prior to 0.3.0 of this plugin was removed.
  - Support for `enable_nfs` has been deprecated and will be removed on 0.7.0,
    please use `cache.synced_folder_opts = {type: :nfs}` instead.

FEATURES:

  - Warm up cache buckets with files available on guest in case bucket is empty
  - Support for offline provisioning of apt-packages by caching `/var/lib/apt/lists` [GH-84]
  - Support for specifying custom cache bucket synced folder opts
  - Support to force disabe the plugin [GH-72]
  - Automatically disable the plugin for cloud providers [GH-45]
  - Skip configuration of buckets that have been configured already [GH-85]

BUG FIXES:

  - Properly fix NFS support for Vagrant 1.4+ [GH-76]

## [0.5.1](https://github.com/fgrehm/vagrant-cachier/compare/v0.5.0...v0.5.1) (Dec 20, 2013)

BUG FIXES:

  - Fix NFS support for Vagrant 1.4+ [GH-67]

## [0.5.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.4.1...v0.5.0) (Nov 8, 2013)

FEATURES:

  - Support for [zypper] [GH-54]

## [0.4.1](https://github.com/fgrehm/vagrant-cachier/compare/v0.4.0...v0.4.1) (Oct 27, 2013)

BUG FIXES:

  - Do not attempt to configure apt-cacher-ng bucket if it is not installed on guest
    machine.

## [0.4.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.3.3...v0.4.0) (Oct 23, 2013)

FEATURES:

  - Support for [npm](https://npmjs.org/) [GH-51]
  - Support for [Composer](http://getcomposer.org/) [GH-48]
  - Support for `apt-cacher-ng` [GH-30]

BUG FIXES:

  - Allow halting nonresponsive machine when plugin is installed [GH-8]

## [0.3.3](https://github.com/fgrehm/vagrant-cachier/compare/v0.3.2...v0.3.3) (Sep 11, 2013)

BUG FIXES:

  - Automatically create `partial` dir under apt cache bucket dir to allow usage
    on Ubuntu 10.04 guests [GH-40]

## [0.3.2](https://github.com/fgrehm/vagrant-cachier/compare/v0.3.1...v0.3.2) (Aug 14, 2013)

BUG FIXES:

  - Prevent errors when caching is disabled and a provisioner is enabled [GH-41]

## [0.3.1](https://github.com/fgrehm/vagrant-cachier/compare/v0.3.0...v0.3.1) (Aug 13, 2013)

BUG FIXES:

  - Prevent errors when caching is disabled

## [0.3.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.2.0...v0.3.0) (Aug 5, 2013)

BACKWARDS INCOMPATIBILITIES:

  - Machine scoped cache dirs are now kept on `.vagrant/machines/MACHINE/cache`
    to allow downloaded packages to be reused between providers. If a single cache
    directory exists, the plugin will automatically move it to the right place,
    if multiple directories are found, it will halt execution and will error out,
    letting the user know what has to be done in order to fix things.

FEATURES:

  - Add `file_cache_path` support for Chef. [GH-14]
  - Reconfigure buckets before each provisioner. [GH-26] / [GH-32]

IMPROVEMENTS:

  - Don't error out if a bucket is configured for a non-capable guest. [GH-27]

## [0.2.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.1.0...v0.2.0) (July 10, 2013)

FEATURES:

  - Support enabling NFS for root cache folder. [GH-7]
  - Support RVM bucket

## [0.1.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.0.6...v0.1.0) (June 9, 2013)

IMPROVEMENTS:

  - Moves from `Vagrant` to recommended `VagrantPlugins` top-level
    module namespace. [GH-9]

## 0.0.6 (May 22, 2013)

  - Initial public release.
