require 'argon2'

module Devise
  module Models
    module Argon2
      def valid_password?(password)
        argon2_secret = (self.class.argon2_options[:secret] || self.class.pepper)
        ::Argon2::Password.verify_password(password, encrypted_password, argon2_secret)
      end

      protected

      def password_digest(password)
        hasher_options = { secret: self.class.pepper }.merge(self.class.argon2_options)
        hasher = ::Argon2::Password.new(hasher_options)
        hasher.create(password)
      end

      module ClassMethods
        Devise::Models.config(self, :argon2_options)
      end
    end
  end
end