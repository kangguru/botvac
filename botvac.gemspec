# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'botvac/version'

Gem::Specification.new do |spec|
  spec.name          = "botvac"
  spec.version       = Botvac::VERSION
  spec.authors       = ["Lars Brillert"]
  spec.email         = ["lars@railslove.com"]
  spec.summary       = %q{talk to your botvac connected robot}
  spec.description   = <<-description
Botvac allows you to interact with the Neato cloud service
which controls your robot without making use of the Android/iOS
application.
  description

  spec.homepage      = "https://github.com/kangguru/botvac"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "rack"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", ">= 1.6.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "timecop"
end
