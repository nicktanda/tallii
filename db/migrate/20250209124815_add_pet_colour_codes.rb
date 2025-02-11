class AddPetColourCodes < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :colour_codes, :string, default: [], array: true
  end
end
