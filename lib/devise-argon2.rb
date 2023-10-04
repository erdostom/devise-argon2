require 'devise'
require 'devise-argon2/version'

module Devise
  add_module(:argon2, :model => 'devise-argon2/model')
  
  mattr_accessor :argon2_options
  @@argon2_options = {}
end