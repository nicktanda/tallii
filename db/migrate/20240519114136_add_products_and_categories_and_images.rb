class AddProductsAndCategoriesAndImages < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description

      t.references :organisation, foreign_key: true
      t.timestamps
    end

    create_table :products do |t|
      t.string :name
      t.string :brand
      t.text :description
      t.decimal :price
      t.integer :stock
      t.string :features, array: true, default: []
      t.string :item_number
      t.string :dimensions
      t.string :weight
      t.string :life_stage
      t.string :breed_size
      t.string :toy_feature
      t.string :material

      t.references :organisation, foreign_key: true
      t.references :category, foreign_key: true
      t.timestamps
    end

    create_table :reviews do |t|
      t.integer :rating, max: 5
      t.text :comment

      t.references :product, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end

    create_table :onboarding_pets do |t|
      t.string :name, limit: 100
      t.date :dob
      t.string :breed
      t.integer :species
      t.integer :gender
      t.integer :weight
      t.string :health_conditions

      t.references :user, null: false, foreign_key: true
      t.references :organisation, foreign_key: true
      t.timestamps
    end

    create_table :images do |t|
      t.string :name, null: false, limit: 100

      t.references :pet, foreign_key: true
      t.references :onboarding_pet, foreign_key: true
      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
