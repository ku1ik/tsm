# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tsm/version'

Gem::Specification.new do |spec|
  spec.name          = "tsm"
  spec.version       = TSM::VERSION
  spec.authors       = ["Marcin Kulik"]
  spec.email         = ["marcin.kulik@gmail.com"]
  spec.description   = %q{Bindings for TSM library, a terminal state machine}
  spec.summary       = %q{TSM library bindings}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
end
