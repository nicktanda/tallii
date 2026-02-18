class AddRowsSkippedToImports < ActiveRecord::Migration[8.0]
  def change
    add_column :imports, :rows_skipped, :integer, default: 0, null: false
  end
end
