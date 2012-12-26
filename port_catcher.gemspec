# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'port_catcher/version'

Gem::Specification.new do |gem|
  gem.name          = "port_catcher"
  gem.version       = PortCatcher::VERSION
  gem.authors       = ["Katsunori Kawaguchi"]
  gem.email         = ["hamakata@gmail.com"]
  gem.description   = %q{Catch your free port}
  gem.summary       = %q{Catch your free port}
  gem.homepage      = "https://github.com/tamac-io/port_catcher"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec')
end
