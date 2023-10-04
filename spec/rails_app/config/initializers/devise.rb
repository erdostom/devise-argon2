# frozen_string_literal: true

Devise.setup do |config|
  require "devise/orm/#{ENV['ORM'] || 'active_record'}"
  config.stretches = 1
end
