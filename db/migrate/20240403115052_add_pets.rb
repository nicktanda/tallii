class AddPets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :age
      t.string :breed

      t.references :users, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
