class AddDaycareVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :daycare_visits do |t|
      t.date :date, null: false
      t.time :time, null: false
      t.text :notes

      t.references :pet, null: false, foreign_key: true
      t.references :organisation, foreign_key: true
      t.timestamps
    end
  end
end
