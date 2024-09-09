class AddNotesToUsersAndPets < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notes, :text
    add_column :pets, :notes, :text
  end
end
