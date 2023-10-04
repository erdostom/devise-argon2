require 'argon2'

module Devise
  module Models
    module Argon2
      def valid_password?(password)
        ::Argon2::Password.verify_password(password, encrypted_password, self.class.pepper)
      end

      protected

      def password_digest(password)
        hasher_options = { secret: self.class.pepper }
        hasher = ::Argon2::Password.new(hasher_options)
        hasher.create(password)
      end
    end
  end
end