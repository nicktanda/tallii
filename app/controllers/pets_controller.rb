class PetsController < ApplicationController
  def index
    @pets = current_user.pets.all
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def new; end

  def create
    pet = current_user.pets.new(pet_params)

    if pet.save
      redirect_to pet_path(pet), notice: 'Pet created successfully'

      if params[:pet][:image].present?
        pet.images.create!(name: "test_image", image: params[:pet][:image])
      end
    else
      redirect_back fallback_location: new_pet_path, alert: 'Invalid pet information'
    end
  end

  def update
    pet = current_user.pets.find(params[:id])
    pet.assign_attributes(pet_params)

    if pet.save
      redirect_to pet_path(pet), notice: 'Pet updated successfully'
    else
      redirect_back fallback_location: new_pet_path, alert: 'Invalid pet information'
    end
  end

  def delete
    pet = Pet.find(params[:id])
    pet.destroy
    redirect_to pet_profiles_path, notice: 'Pet deleted successfully'
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :gender, :dob, :breed, :weight, :health_conditions)
  end
end