class AddProductOrderJoins < ActiveRecord::Migration[7.0]
  def change
    create_join_table :products, :orders, table_name: :product_order_joins do |t|
      t.index :product_id
      t.index :order_id
    end
  end
end
