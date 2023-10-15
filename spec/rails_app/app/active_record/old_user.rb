class OldUser < ActiveRecord::Base
  devise :database_authenticatable, :argon2
end
