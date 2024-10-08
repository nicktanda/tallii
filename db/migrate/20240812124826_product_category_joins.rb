class ProductCategoryJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :product_category_joins do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
