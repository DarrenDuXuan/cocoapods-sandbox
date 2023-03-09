# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-sandbox/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-sandbox'
  spec.version       = CocoapodsSandbox::VERSION
  spec.authors       = ['duxuan']
  spec.email         = ['duxuan']
  spec.description   = %q{A short description of cocoapods-sandbox.}
  spec.summary       = %q{A longer description of cocoapods-sandbox.}
  spec.homepage      = 'https://github.com/DarrenDuXuan/cocoapods-sandbox'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'cocoapods', '>= 1.10.0'
end
