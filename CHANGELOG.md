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
