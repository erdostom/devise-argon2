class OldUser < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :argon2
end
