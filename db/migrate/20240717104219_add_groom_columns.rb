class AddGroomColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :grooms, :status, :integer, default: 0
  end
end
