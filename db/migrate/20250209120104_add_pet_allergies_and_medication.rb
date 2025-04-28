class AddPetAllergiesAndMedication < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :allergies, :text
    add_column :pets, :medication, :text
  end
end
