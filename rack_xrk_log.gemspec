# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/xrk/log'

Gem::Specification.new do |spec|
  spec.name          = "rack_xrk_log"
  spec.version       = Rack::Xrk::LOG::VERSION
  spec.authors       = ["Louis Liu"]
  spec.email         = ["louisliu813@gmail.com"]
  spec.description   = "Gem for overwriting outputting JSON formatted access logs from Rack apps"
  spec.summary       = "Gem for overwriting outputting JSON formatted access logs from Rack apps"
  spec.homepage      = "https://github.com/louis813/rack_xrk_log"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"

  spec.add_dependency 'rack'
  spec.add_dependency 'json'
end
