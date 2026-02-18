class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.integer :status, default: 0, null: false
      t.integer :progress, default: 0, null: false
      t.integer :total, default: 0, null: false
      t.integer :users_imported, default: 0, null: false
      t.integer :pets_imported, default: 0, null: false
      t.text :error_messages
      t.references :user, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true
      t.string :file_name
      t.string :import_type

      t.timestamps
    end
  end
end
