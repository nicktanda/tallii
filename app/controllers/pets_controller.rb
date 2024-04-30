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
    else
      redirect_back fallback_location: new_pet_path, alert: 'Invalid pet information'
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :species, :gender, :dob, :breed, :weight, :health_conditions)
  end
end