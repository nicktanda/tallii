class AddAccessCodeToOrganisation < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :access_code, :string, unique: true, null: false
  end
end
