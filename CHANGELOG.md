## [0.6.0](https://github.com/fgrehm/vagrant-cachier/compare/v0.5.1...master) (unreleased)


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
