class AddOrgSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :email, :string
    add_column :organisations, :phone, :string
    add_column :organisations, :address, :text
    add_column :organisations, :city, :text
    add_column :organisations, :postcode, :text
  end
end
