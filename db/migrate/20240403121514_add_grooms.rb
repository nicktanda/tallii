class AddGrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :grooms do |t|
      t.date :date, null: false
      t.time :time, null: false
      t.date :last_groom, null: false
      t.text :notes

      t.references :pet, null: false, foreign_key: true
      t.references :organisation, foreign_key: true
      t.timestamps
    end
  end
end
