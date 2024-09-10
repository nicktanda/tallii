class AddTemporaryGroomsAndDaycareVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :temporary_grooms do |t|
      t.text :pet_name, null: false
      t.text :owner_name, null: false
      t.date :date, null: false
      t.time :time, null: false
      t.date :last_groom
      t.text :pet_notes
      t.text :owner_notes
      t.bigint :employee_id
      t.integer :status, default: 0

      t.references :organisation, foreign_key: true
      t.timestamps
    end

    create_table :temporary_daycare_visits do |t|
      t.text :pet_name, null: false
      t.text :owner_name, null: false
      t.date :date, null: false
      t.time :time, null: false
      t.integer :duration, null: false
      t.text :pet_notes
      t.text :owner_notes
      t.bigint :employee_id
      t.integer :status, default: 0

      t.references :organisation, foreign_key: true
      t.timestamps
    end

    add_foreign_key :temporary_grooms, :users, column: :employee_id
    add_index :temporary_grooms, :employee_id

    add_foreign_key :temporary_daycare_visits, :users, column: :employee_id
    add_index :temporary_daycare_visits, :employee_id
  end
end
