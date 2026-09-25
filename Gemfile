source 'https://rubygems.org'

gemspec

gem 'rspec'
gem 'simplecov'
gem 'activerecord'
gem 'rails', ENV['RAILS_VERSION'] || '~> 8.1.4'
gem 'argon2', ENV['ARGON2_VERSION'] || '~> 2.3.0'

if ENV['DEVISE_VERSION'] == 'main'
  gem 'devise', github: 'heartcombo/devise', branch: 'main'
else
  gem 'devise', ENV['DEVISE_VERSION'] || '~> 5.0.0'
end

if ENV['ORM'] == 'mongoid'
  gem 'mongoid', ENV['MONGOID_VERSION'] || '~> 9.1.0'
end

gem 'sqlite3', '~> 2.8'
