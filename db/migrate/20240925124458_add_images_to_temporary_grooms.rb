class AddImagesToTemporaryGrooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :temporary_groom, foreign_key: true
  end
end
