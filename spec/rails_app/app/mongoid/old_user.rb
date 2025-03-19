class OldUser
  include Mongoid::Document
  
  devise :database_authenticatable, :recoverable, :argon2

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :password_salt, type: String, default: ""

  include Mongoid::Timestamps
end
