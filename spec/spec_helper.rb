require 'rubygems'
require 'simplecov'
SimpleCov.start
require 'bundler/setup'

require 'rails_app/config/environment'
ORM = (ENV['ORM'] || 'active_record')
require "orm/#{ORM}"



RSpec.configure do |config|
end
