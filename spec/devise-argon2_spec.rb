# encoding: utf-8
require 'spec_helper'

describe Devise::Encryptable::Encryptors::Argon2 do
  let(:argon2)    { Devise::Encryptable::Encryptors::Argon2 }
  let(:password)  { 'Tr0ub4dor&3' }
  let(:stretches) { 10 }

  describe "used with salt + pepper" do
    let(:salt)      { "You say you love me like salt! The simplest spice in my kingdom!" }
    let(:pepper)    { "I don't really want to stop the show But I thought that you might like to know That the singer's going to sing a song And he wants you all to sing along" }

    describe ".compare" do
      let(:encrypted) { Argon2::Password.create("#{password}#{salt}#{pepper}").to_s }

      it "is true when the encrypted password contains the argon2id format" do
        expect(encrypted).to match /argon2id/
      end    

      it "is true when comparing an encrypted password against given plaintext" do
        expect(argon2.compare(encrypted, password, stretches, salt, pepper)).to be true
      end

      it "is false when comparing with wrong password" do
        expect(argon2.compare(encrypted, 'hunter2', stretches, salt, pepper)).to be false
      end

      it "is false when comparing with correct password but wrong salt" do
        expect(argon2.compare(encrypted, password, stretches, 'nacl', pepper)).to be false
      end

      it "is false when comparing with correct password but wrong pepper" do
        expect(argon2.compare(encrypted, password, stretches, salt, 'beatles')).to be false
      end
    end

    describe "without any salt or pepper" do
      let(:encrypted) { Argon2::Password.create(password).to_s }
      let(:salt) { nil }
      let(:pepper) { nil }

      it "is still works" do
        expect(argon2.compare(encrypted, password, stretches, salt, pepper)).to be true
      end
    end

  end

end
