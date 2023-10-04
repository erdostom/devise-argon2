# frozen_string_literal: true

class DeviseCreateOldUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :old_users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :password_salt

      t.timestamps null: false
    end

    add_index :old_users, :email,                unique: true
  end
end
