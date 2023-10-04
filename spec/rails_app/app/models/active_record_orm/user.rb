class User < ActiveRecord::Base
  devise :database_authenticatable, :argon2
end
