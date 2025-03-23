class AddRecoverableFieldsToOldUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :old_users, :reset_password_token, :string
    add_column :old_users, :reset_password_sent_at, :datetime
  end
end
