class AddPetSizeThresholdsToOrganisations < ActiveRecord::Migration[8.0]
  def change
    add_column :organisations, :small_pet_max_weight, :integer, default: 25
    add_column :organisations, :medium_pet_max_weight, :integer, default: 50
  end
end
