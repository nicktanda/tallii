class AddOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.string :payment_intent_id

      t.timestamps
    end
  end
end
