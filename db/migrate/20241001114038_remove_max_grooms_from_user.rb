class RemoveMaxGroomsFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :max_grooms, :integer
  end
end
