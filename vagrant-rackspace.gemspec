# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-rackspace/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-rackspace-provision"
  gem.version       = VagrantPlugins::Rackspace::VERSION
  gem.authors       = ["Mitchell Hashimoto (original vagrant-rackspace)"]
  gem.email         = ["mitchell@hashicorp.com"]
  gem.description   = "FORK OF vagrant-rackspace, with provisioning support merged!  Enables Vagrant to manage machines in RackSpace Cloud."
  gem.summary       = "FORK OF vagrant-rackspace, with provisioning support merged!  Enables Vagrant to manage machines in RackSpace Cloud."
  gem.homepage      = "http://www.vagrantup.com"

  gem.add_runtime_dependency "fog", "~> 1.10.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.13.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
