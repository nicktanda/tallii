class AddAdditionalContactDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :additional_user_first_name, :text
    add_column :users, :additional_user_last_name, :text
    add_column :users, :additional_user_email, :text
    add_column :users, :additional_user_phone, :text
    add_column :users, :additional_user_relationship, :text
  end
end
