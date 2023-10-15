source 'https://rubygems.org'

gemspec

gem 'rspec'
gem 'simplecov'
gem 'activerecord'
gem 'sqlite3'
gem 'rails', ENV['RAILS_VERSION'] || '~> 7.0'

if ENV['ORM'] == 'mongoid'
  gem 'mongoid', ENV['MONGOID_VERSION'] || '~> 7.5'
end
