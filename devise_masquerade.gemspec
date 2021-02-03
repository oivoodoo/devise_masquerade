# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_masquerade/version'

Gem::Specification.new do |gem|
  gem.name          = 'devise_masquerade'
  gem.version       = DeviseMasquerade::VERSION
  gem.authors       = ['Alexandr Korsak']
  gem.email         = ['alex.korsak@gmail.com']
  gem.description   = 'devise masquerade library'
  gem.summary       = 'use for login as functionallity on your admin users pages'
  gem.homepage      = 'http://github.com/oivoodoo/devise_masquerade'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.license = 'MIT'

  gem.add_development_dependency('bundler', '>= 2.0.0')

  gem.add_runtime_dependency('railties', '>= 5.2.0')
  gem.add_runtime_dependency('devise', '>= 4.7.0')
  gem.add_runtime_dependency('globalid', '>= 0.3.6')
end
