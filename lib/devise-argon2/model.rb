require 'argon2'

module Devise
  module Models
    module Argon2
      def valid_password?(password)
        argon2_secret = (self.class.argon2_options[:secret] || self.class.pepper)
        is_valid = ::Argon2::Password.verify_password(password, encrypted_password, argon2_secret)
        update_encrypted_password(password) if is_valid && outdated_work_factors?
        is_valid
      end

      protected

      def password_digest(password)
        hasher_options = { secret: self.class.pepper }.merge(self.class.argon2_options)
        hasher = ::Argon2::Password.new(hasher_options)
        hasher.create(password)
      end

      private

      def update_encrypted_password(password)
        if self.new_record?
          self.encrypted_password = password_digest(password)
        else
          self.update_attribute('encrypted_password', password_digest(password))
        end
      end

      def outdated_work_factors?
        # Since version 2.3.0 the argon2 gem exposes the default work factors via constants, see
        # https://github.com/technion/ruby-argon2/commit/d62ecf8b4ec6b8c1651fade5a5ebdc856e8aef42
        default_t_cost = defined?(::Argon2::Password::DEFAULT_T_COST) ? ::Argon2::Password::DEFAULT_T_COST : 2
        default_m_cost = defined?(::Argon2::Password::DEFAULT_M_COST) ? ::Argon2::Password::DEFAULT_M_COST : 16
        default_p_cost = defined?(::Argon2::Password::DEFAULT_P_COST) ? ::Argon2::Password::DEFAULT_P_COST : 1

        current_t_cost = self.class.argon2_options[:t_cost] || default_t_cost
        current_m_cost = self.class.argon2_options[:m_cost] || default_m_cost
        current_p_cost = self.class.argon2_options[:p_cost] || default_p_cost
        
        hash_format = ::Argon2::HashFormat.new(encrypted_password)

        hash_format.t_cost != current_t_cost ||
          hash_format.m_cost != (1 << current_m_cost) ||
          hash_format.p_cost != current_p_cost
      end

      module ClassMethods
        Devise::Models.config(self, :argon2_options)
      end
    end
  end
end