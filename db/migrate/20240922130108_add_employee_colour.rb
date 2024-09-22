class AddEmployeeColour < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :colour, :string
  end
end
