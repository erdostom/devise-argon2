# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "devise-argon2/version"

Gem::Specification.new do |gem|
  gem.name          = "devise-argon2"
  gem.version       = Devise::Argon2::ARGON2_VERSION
  gem.authors       = ["Tamas Erdos"]
  gem.email         = ["tamas at tamaserdos com"]
  gem.description   = %q{A devise-encryptable password encryptor that uses Argon2}
  gem.summary       = %q{A devise-encryptable password encryptor that uses Argon2}
  gem.homepage      = "https://github.com/erdostom/devise-argon2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'devise', '>= 2.1.0'
  gem.add_dependency 'argon2', '~> 2.0'
end
