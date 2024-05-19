class AddProductsAndCategoriesAndImages < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :products do |t|
      t.string :name
      t.string :brand
      t.text :description
      t.decimal :price
      t.integer :stock

      t.references :category, foreign_key: true
      t.timestamps
    end

    create_table :images do |t|
      t.string :name, null: false, limit: 100

      t.references :pet, foreign_key: true
      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
