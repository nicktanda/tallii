class AddImageToGrooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :groom, foreign_key: true
  end
end
