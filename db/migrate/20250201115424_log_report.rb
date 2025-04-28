class LogReport < ActiveRecord::Migration[7.0]
  def change
    create_table :log_reports do |t|
      t.references :groom, foreign_key: true
      t.references :temporary_groom, foreign_key: true
      t.references :daycare_visit, foreign_key: true
      t.references :temporary_daycare_visit, foreign_key: true

      t.text :org_notes, default: "", null: false
      t.text :customer_notes, default: "", null: false
      t.float :price, default: 0, null: false
      t.integer :payment_method, default: 0, null: false

      t.timestamps
    end
  end
end
