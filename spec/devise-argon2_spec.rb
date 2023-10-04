# encoding: utf-8
require 'spec_helper'

describe Devise::Models::Argon2 do
  CORRECT_PASSWORD = 'Tr0ub4dor&3'
  INCORRECT_PASSWORD = 'wrong'

  let(:user) { User.new(password: CORRECT_PASSWORD) }

  before do
    Devise.pepper = nil
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
  end
end
