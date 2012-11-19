# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_masquerade/version'

Gem::Specification.new do |gem|
  gem.name          = "devise_masquerade"
  gem.version       = DeviseMasquerade::VERSION
  gem.authors       = ["Alexandr Korsak"]
  gem.email         = ["alex.korsak@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://github.com/oivoodoo/devise_masquerade/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('bundler', '>= 1.1.0')

  gem.add_runtime_dependency('railties', '~> 3.0')
  gem.add_runtime_dependency('devise', '>= 2.1.0')
end

