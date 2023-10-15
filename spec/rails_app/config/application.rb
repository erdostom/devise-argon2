ORM = (ENV['ORM'] || 'active_record')

require "rails"

Bundler.require :default, ORM

require "action_controller/railtie"

require "#{ORM}/railtie"
require "action_mailer/railtie"
require 'devise-argon2'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DummyRailsApp
  class Application < Rails::Application
    config.load_defaults Rails.version.match(/^\d.\d/)[0]
    config.eager_load = false
    config.autoload_paths.reject!{ |p| p =~ /\/app\/(\w+)$/ && !%w(controllers helpers mailers views).include?($1) }
    config.autoload_paths += ["#{config.root}/app/#{ORM}"]
  end
end
