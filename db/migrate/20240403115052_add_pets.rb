class AddPets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.string :name, null: false, limit: 100
      t.date :dob
      t.string :breed
      t.integer :visits_remaining
      t.integer :grooms_remaining
      t.integer :species, default: 0
      t.integer :gender, default: 0
      t.integer :weight, default: 0
      t.string :health_conditions

      t.references :user, null: false, foreign_key: true
      t.references :organisation, foreign_key: true
      t.timestamps
    end
  end
end
