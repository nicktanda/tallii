class DropProductToyFeatureColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :toy_feature
  end
end
