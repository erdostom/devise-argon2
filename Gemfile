source 'https://rubygems.org'

gemspec

gem 'rspec'
gem 'simplecov'
gem 'activerecord'
gem 'rails', ENV['RAILS_VERSION'] || '~> 7.0'
gem 'argon2', ENV['ARGON2_VERSION'] || '~> 2.3'
gem 'devise', ENV['DEVISE_VERSION'] || '~> 4.9'

if ENV['ORM'] == 'mongoid'
  gem 'mongoid', ENV['MONGOID_VERSION'] || '~> 7.5'
end

if ENV['RAILS_VERSION'] == '8.0.0.beta1'
  gem 'sqlite3', '~> 2.1'
else
  gem 'sqlite3', '~> 1.6', '>= 1.6.6'
end
