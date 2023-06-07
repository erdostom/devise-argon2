# frozen_string_literal: true

Devise.setup do |config|
  require 'devise/orm/active_record'
  config.stretches = 1
end
