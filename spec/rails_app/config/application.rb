require "rails"
require "active_record/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DummyRailsApp
  class Application < Rails::Application
    config.load_defaults Rails.version.match(/^\d.\d/)[0]
    config.eager_load = false
  end
end
