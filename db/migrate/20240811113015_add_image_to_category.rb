class AddImageToCategory < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :category, foreign_key: true
  end
end
