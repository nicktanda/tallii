class AddPetStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :status, :integer, default: 0
  end
end
