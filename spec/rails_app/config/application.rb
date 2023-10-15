ORM = (ENV['ORM'] || 'active_record')
p ENV['ORM']

require "rails"
require "active_record/railtie" if ORM == 'active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DummyRailsApp
  class Application < Rails::Application
    config.load_defaults Rails.version.match(/^\d.\d/)[0]
    config.eager_load = false
    config.autoload_paths += ["#{Rails.root}/app/models/#{ORM}_orm"]
  end
end
