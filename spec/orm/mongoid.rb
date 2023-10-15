require 'mongoid/version'

Mongoid.configure do |config|
  config.load!('spec/rails_app/config/mongoid.yml')
end
