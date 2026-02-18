class AddDetailedStatsToImports < ActiveRecord::Migration[8.0]
  def change
    add_column :imports, :users_found, :integer, default: 0, null: false
    add_column :imports, :users_created, :integer, default: 0, null: false
    add_column :imports, :pets_skipped, :integer, default: 0, null: false
    add_column :imports, :pets_created, :integer, default: 0, null: false
  end
end
