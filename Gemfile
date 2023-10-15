source 'https://rubygems.org'

gemspec

gem 'rspec'
gem 'simplecov'
gem 'activerecord', ENV['AR_VERSION'] || '~> 7.0'
gem 'sqlite3'
gem 'rails'

if ENV['ORM'] == 'mongoid'
  gem 'mongoid', ENV['MONGOID_VERSION'] || '~> 7.5'
end
