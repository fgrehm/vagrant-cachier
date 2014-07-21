# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-cachier/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-cachier"
  spec.version       = VagrantPlugins::Cachier::VERSION
  spec.authors       = ["Fabio Rehm"]
  spec.email         = ["fgrehm@gmail.com"]
  spec.description   = %q{Caffeine reducer}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/fgrehm/vagrant-cachier"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = %Q{
  Thanks for installing vagrant-cachier #{VagrantPlugins::Cachier::VERSION}!

  If you are new to vagrant-cachier just follow along with the docs available
  at http://fgrehm.viewdocs.io/vagrant-cachier.

  If you are upgrading from a previous version, please note that plugin has gone
  through many backwards incompatible changes recently. Please check out
  https://github.com/fgrehm/vagrant-cachier/blob/master/CHANGELOG.md
  before continuing and caching all the things :)
  }
end
