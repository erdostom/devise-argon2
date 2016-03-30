require 'argon2'

module Devise
  module Encryptable
    module Encryptors
      class Argon2 < Base
        def self.digest(password, stretches, salt, pepper)
          ::Argon2::Password.create("#{password}#{salt}#{pepper}")
        end

        def self.compare(encrypted_password, password, stretches, salt, pepper)
          ::Argon2::Password.verify_password("#{password}#{salt}#{pepper}", encrypted_password)
        end
      end
    end
  end
end
