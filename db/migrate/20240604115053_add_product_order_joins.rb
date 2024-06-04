class AddProductOrderJoins < ActiveRecord::Migration[7.0]
  def change
    create_join_table :products, :orders do |t|
      t.index :product_id
      t.index :order_id
    end
  end
end
