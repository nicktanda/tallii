class AddPets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.string :name, null: false, limit: 100
      t.integer :age
      t.string :breed
      t.integer :visits_remaining
      t.integer :grooms_remaining
      t.integer :species, default: 0

      t.references :user, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
