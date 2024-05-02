class AddImageUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :name, null: false, limit: 100

      t.references :pet, foreign_key: true
      t.references :groom, foreign_key: true
      t.references :daycare_visit, foreign_key: true
      t.timestamps
    end
  end
end
