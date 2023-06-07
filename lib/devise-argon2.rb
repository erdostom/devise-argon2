require 'devise'
require 'devise-argon2/version'

Devise.add_module(:argon2, :model => 'devise-argon2/model')