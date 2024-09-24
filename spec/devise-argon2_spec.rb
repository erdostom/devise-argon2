# encoding: utf-8
require 'spec_helper'
require 'bcrypt'

describe Devise::Models::Argon2 do
  CORRECT_PASSWORD = 'Tr0ub4dor&3'
  INCORRECT_PASSWORD = 'wrong'
  DEFAULT_M_COST = 3
  DEFAULT_T_COST = 1
  DEFAULT_P_COST = 1

  let(:user) { User.new(password: CORRECT_PASSWORD) }

  before do
    Devise.pepper = nil
    Devise.argon2_options = {
      m_cost: DEFAULT_M_COST,
      t_cost: DEFAULT_T_COST,
      p_cost: DEFAULT_P_COST
    }
    User.destroy_all
    OldUser.destroy_all
  end

  def work_factors(hash)
    hash_format = Argon2::HashFormat.new(hash)
    {
      m_cost: hash_format.m_cost,
      t_cost: hash_format.t_cost,
      p_cost: hash_format.p_cost
    }
  end

  describe 'valid_password?' do
    shared_examples 'a password is validated if and only if it is correct' do
      it 'validates the correct password' do
        expect(user.valid_password?(CORRECT_PASSWORD)).to be true
      end

      it 'does not validate an incorrect password' do
        expect(user.valid_password?(INCORRECT_PASSWORD)).to be false
      end
    end

    context 'no pepper' do
      include_examples 'a password is validated if and only if it is correct'
    end

    context 'Devise.pepper is set' do
      before do
        Devise.pepper = 'pepper'
      end

      include_examples 'a password is validated if and only if it is correct'
    end

    context 'argon2_options[:secret] is set' do
      before do
        Devise.argon2_options[:secret] = 'pepper'
      end

      include_examples 'a password is validated if and only if it is correct'
    end

    context 'encrypted_password is a BCrypt hash' do
      before do
        Devise.pepper = 'devise pepper'
        Devise.argon2_options.merge!({ secret: 'argon2 secret' })

        # Devise peppers by concatenating password and pepper:
        # https://github.com/heartcombo/devise/blob/main/lib/devise/encryptor.rb
        bcrypt_hash = BCrypt::Password.create("#{CORRECT_PASSWORD}#{Devise.pepper}", cost: 4)

        user.encrypted_password = bcrypt_hash
      end

      include_examples 'a password is validated if and only if it is correct'

      it 'updates hash if valid password is given' do
        expect{ user.valid_password?(CORRECT_PASSWORD) }.to(change(user, :encrypted_password))
        expect(
          ::Argon2::Password.verify_password(
            CORRECT_PASSWORD,
            user.encrypted_password,
            'argon2 secret'
          )
        ).to be true
      end

      it 'does not update the hash if an invalid password is given' do
        expect{ user.valid_password?(INCORRECT_PASSWORD) }.not_to(change(user, :encrypted_password))
      end
    end

    context 'encrypted_password is hashed with version 1 of devise-argon2' do
      let(:user) { OldUser.new(password: CORRECT_PASSWORD) }

      before do
        Devise.pepper = 'devise pepper'
        Devise.argon2_options.merge!({
          secret: 'argon2 secret',
          migrate_from_devise_argon2_v1: true
        })

        user.password_salt = 'devise-argon2 v1 salt'
        user.encrypted_password = ::Argon2::Password.create(
          "#{CORRECT_PASSWORD}#{user.password_salt}#{Devise.pepper}"
        )
      end

      include_examples 'a password is validated if and only if it is correct'

      it 'updates hash once if valid password is given' do
        expect{ user.valid_password?(CORRECT_PASSWORD) }.to(
          change(user, :encrypted_password)
          .and(change(user, :password_salt).to(nil))
        )
        expect(
          ::Argon2::Password.verify_password(
            CORRECT_PASSWORD,
            user.encrypted_password,
            'argon2 secret'
          )
        ).to be true
        expect{ user.valid_password?(CORRECT_PASSWORD) }.not_to(change(user, :encrypted_password))
      end

      it 'does not update the hash if an invalid password is given' do
        expect{ user.valid_password?(INCORRECT_PASSWORD) }.not_to(change(user, :encrypted_password))
      end

      it 'does not send password change notification emails on hash updates' do
        user.email = 'test@example.com'
        user.save!
        Devise.send_password_change_notification = true
        expect{ user.valid_password?(CORRECT_PASSWORD) }
          .not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    describe 'updating outdated work factors' do
      it 'updates work factors if a valid password is given' do
        user # build user

        Devise.argon2_options.merge!({
          m_cost: 4,
          t_cost: 3,
          p_cost: 2
        })

        expect{ user.valid_password?(CORRECT_PASSWORD) }.to(
          change{ work_factors(user.encrypted_password) }
            .from({ m_cost: 1 << DEFAULT_M_COST, t_cost: DEFAULT_T_COST, p_cost: DEFAULT_P_COST})
            .to({ m_cost: 1 << 4, t_cost: 3, p_cost: 2 })
        )
      end

      it 'does not update work factors if an invalid password is given' do
        user # build user

        Devise.argon2_options.merge!({
          m_cost: 4,
          t_cost: 3,
          p_cost: 2
        })

        expect{ user.valid_password?(INCORRECT_PASSWORD) }
          .not_to change{ work_factors(user.encrypted_password) }
      end

      it 'updates work factors for a persisted user' do
        user.save!

        Devise.argon2_options.merge!({
          m_cost: 4,
          t_cost: 3,
          p_cost: 2
        })

        expect{ user.valid_password?(CORRECT_PASSWORD) }.to(
          change{ work_factors(user.encrypted_password) }
            .from({ m_cost: 1 << DEFAULT_M_COST, t_cost: DEFAULT_T_COST, p_cost: DEFAULT_P_COST})
            .to({ m_cost: 1 << 4, t_cost: 3, p_cost: 2 })
        )
      end

      if Argon2::VERSION >= '2.3.0'
        it 'updates work factors if they changed via profile option' do
          # Build user with argon2 default work factors (which match the RFC_9106_LOW_MEMORY
          # profile.)
          Devise.argon2_options = {}
          user

          Devise.argon2_options = { profile: :pre_rfc_9106 }
          
          expect{ user.valid_password?(CORRECT_PASSWORD) }.to(
            change{ work_factors(user.encrypted_password) }
              .to(
                {
                  m_cost: 1 << Argon2::Profiles[:pre_rfc_9106][:m_cost],
                  t_cost: Argon2::Profiles[:pre_rfc_9106][:t_cost],
                  p_cost: Argon2::Profiles[:pre_rfc_9106][:p_cost]
                }
              )
          )
        end

        it 'gives precendence to the profile option over explicit configuration of work factors' do
          Devise.argon2_options = {
            m_cost: Argon2::Profiles[:pre_rfc_9106][:m_cost] + 1,
            t_cost: Argon2::Profiles[:pre_rfc_9106][:t_cost] + 1,
            p_cost: Argon2::Profiles[:pre_rfc_9106][:p_cost] + 1
          }
          user # build user

          Devise.argon2_options = {
            profile: :pre_rfc_9106,
            m_cost: Argon2::Profiles[:pre_rfc_9106][:m_cost] + 1,
            t_cost: Argon2::Profiles[:pre_rfc_9106][:t_cost] + 1,
            p_cost: Argon2::Profiles[:pre_rfc_9106][:p_cost] + 1
          }
          
          expect{ user.valid_password?(CORRECT_PASSWORD) }.to(
            change{ work_factors(user.encrypted_password) }
              .to(
                {
                  m_cost: 1 << Argon2::Profiles[:pre_rfc_9106][:m_cost],
                  t_cost: Argon2::Profiles[:pre_rfc_9106][:t_cost],
                  p_cost: Argon2::Profiles[:pre_rfc_9106][:p_cost]
                }
              )
          )
        end
      end
    end

    it 'ignores migrate_from_devise_argon2_v1 if password_salt is not present' do
      Devise.argon2_options.merge!({ migrate_from_devise_argon2_v1: true })
      expect{ user.valid_password?(CORRECT_PASSWORD) }.not_to(change(user, :encrypted_password))
    end
  end

  describe 'password_digest' do
    context 'no pepper' do
      it 'hashes the given password with Argon2' do
        expect(
          Argon2::Password.verify_password(CORRECT_PASSWORD, user.encrypted_password)
        ).to be true
      end
    end

    context 'Devise.pepper is set' do
      before do
        Devise.pepper = 'pepper'
      end

      it 'uses Devise.pepper as secret key for Argon2' do
        expect(
          Argon2::Password.verify_password(CORRECT_PASSWORD, user.encrypted_password, 'pepper')
        ).to be true
      end
    end

    context 'argon2_options[:secret] is set' do
      before do
        Devise.argon2_options[:secret] = 'pepper'
      end

      it 'uses argon2_options[:secret] as secret key for Argon2' do
        expect(
          Argon2::Password.verify_password(CORRECT_PASSWORD, user.encrypted_password, 'pepper')
        ).to be true
      end
    end

    context 'both Devise.pepper and argon2_options[:secret] are set' do
      before do
        Devise.pepper = 'devise pepper'
        Devise.argon2_options[:secret] = 'argon2_options pepper'
      end

      it 'uses argon2_options[:secret] as secret key for Argon2' do
        expect(
          Argon2::Password.verify_password(
            CORRECT_PASSWORD,
            user.encrypted_password,
            'argon2_options pepper'
          )
        ).to be true
      end
    end

    it 'uses work factors given in argon2_options' do
      Devise.argon2_options.merge!({
        m_cost: 4,
        t_cost: 3,
        p_cost: 2
      })

      expect(work_factors(user.encrypted_password)).to eq(
        { m_cost: 1 << 4, t_cost: 3, p_cost: 2 }
      )
    end
  end
end
