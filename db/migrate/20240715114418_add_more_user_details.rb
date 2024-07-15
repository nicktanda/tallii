class AddMoreUserDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone, :text
    add_column :users, :weight, :integer
    add_column :users, :address, :text
    add_column :users, :city, :text
    add_column :users, :postcode, :text
  end
end
