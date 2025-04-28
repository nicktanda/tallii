class AddPetVaccinations < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :rabies_expiration, :date
    add_column :pets, :bordetella_expiration, :date
    add_column :pets, :dhpp_expiration, :date
    add_column :pets, :heartworm_expiration, :date
    add_column :pets, :kennel_cough_expiration, :date
  end
end
