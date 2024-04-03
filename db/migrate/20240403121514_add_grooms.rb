class AddGrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :grooms do |t|
      t.datetime :visit

      t.references :organisation, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.timestamps
    end
  end
end
