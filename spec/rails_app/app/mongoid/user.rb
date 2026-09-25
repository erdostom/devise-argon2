class User
  include Mongoid::Document
  
  devise :database_authenticatable, :recoverable, :argon2

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  include Mongoid::Timestamps
end
