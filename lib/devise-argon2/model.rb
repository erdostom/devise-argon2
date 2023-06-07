require 'argon2'

module Devise
  module Models
    module Argon2
      def valid_password?(password)
        ::Argon2::Password.verify_password(password, encrypted_password)
      end

      protected

      def password_digest(password)
        ::Argon2::Password.create(password)
      end
    end
  end
end