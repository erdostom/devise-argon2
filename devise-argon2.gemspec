# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "devise-argon2/version"

Gem::Specification.new do |gem|
  gem.name = "devise-argon2"
  gem.version = Devise::Argon2::ARGON2_VERSION
  gem.authors = ["Tamas Erdos", "Moritz Höppner"]
  gem.email = ["tamas at tamaserdos com"]
  gem.description = %q{Enables Devise to hash passwords with Argon2id}
  gem.summary = %q{Enables Devise to hash passwords with Argon2id}
  gem.license = 'MIT'
  gem.homepage = "https://github.com/erdostom/devise-argon2"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'devise', '~> 4.0'
  gem.add_dependency 'argon2', '~> 2.1'


  gem.post_install_message = "Version 2 of devise-argon2 introduces breaking changes, please see README.md for details."
end
