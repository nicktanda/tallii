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
      redirect_to root_path
    else
      redirect_back fallback_location: new_pet_path, alert: 'Invalid pet information'
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :dob, :breed, :visits_remaining, :grooms_remaining, :species)
  end
end