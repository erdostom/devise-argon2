# encoding: utf-8
require 'spec_helper'

describe Devise::Models::Argon2 do
  CORRECT_PASSWORD = 'Tr0ub4dor&3'
  INCORRECT_PASSWORD = 'wrong'

  let(:user) { User.new(password: CORRECT_PASSWORD) }

  before do
    Devise.pepper = nil
    Devise.argon2_options = { m_cost: 3, t_cost: 1, p_cost: 1 }
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

      hash_format = Argon2::HashFormat.new(user.encrypted_password)
      
      expect(hash_format.m_cost).to eq(1 << 4)
      expect(hash_format.t_cost).to eq(3)
      expect(hash_format.p_cost).to eq(2)
    end
  end
end
