require 'argon2'

module Devise
  module Models
    module Argon2
      def valid_password?(password)
        is_valid = hash_needs_update = false
        
        if ::Argon2::Password.valid_hash?(encrypted_password)
          if migrate_hash_from_devise_argon2_v1?
            is_valid = ::Argon2::Password.verify_password(
              "#{password}#{password_salt}#{self.class.pepper}",
              encrypted_password
            )
            hash_needs_update = true
          else
            argon2_secret = (self.class.argon2_options[:secret] || self.class.pepper)
            is_valid = ::Argon2::Password.verify_password(
              password,
              encrypted_password,
              argon2_secret
            )
            hash_needs_update = outdated_work_factors?
          end
        else
          # Devise models are included in a fixed order, see
          # https://github.com/heartcombo/devise/blob/f6e73e5b5c8f519f4be29ac9069c6ed8a2343ce4/lib/devise/models.rb#L79.
          # Since we don't specify where this model should be inserted when we call add_module,
          # it will be inserted at the end, i.e. after DatabaseAuthenticatable (see
          # https://github.com/heartcombo/devise/blob/f6e73e5b5c8f519f4be29ac9069c6ed8a2343ce4/lib/devise.rb#L393). 
          # So we can call DatabaseAuthenticable's valid_password? with super.
          is_valid = super
          hash_needs_update = true
        end

        update_hash(password) if is_valid && hash_needs_update

        is_valid
      end

      protected

      def password_digest(password)
        hasher_options = self.class.argon2_options.except(:migrate_from_devise_argon2_v1)
        hasher_options[:secret] ||= self.class.pepper
        hasher = ::Argon2::Password.new(hasher_options)
        hasher.create(password)
      end

      private

      def update_hash(password)
        attributes = { encrypted_password: password_digest(password) }
        attributes[:password_salt] = nil if migrate_hash_from_devise_argon2_v1?

        self.assign_attributes(attributes)
        self.save if self.persisted?
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

      def migrate_hash_from_devise_argon2_v1?
        self.class.argon2_options[:migrate_from_devise_argon2_v1] &&
          defined?(password_salt) &&
          password_salt
      end

      module ClassMethods
        Devise::Models.config(self, :argon2_options)
      end
    end
  end
end