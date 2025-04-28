class AddUserColourCodes < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :colour_codes, :string, default: [], array: true
  end
end
