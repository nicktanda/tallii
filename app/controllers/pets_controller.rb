class PetsController < ApplicationController
  def index
    @pets = current_user.pets.all
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def pictures
    @pet = Pet.find(params[:id])
    @images = @pet.images
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

  def upload_new_image
    pet = Pet.find(params[:id])
    pet.images.create!(name: "test_image", image: params[:image])
    redirect_to pet_pictures_path(pet), notice: 'Image uploaded'
  end

  def delete_image
    pet = Pet.find(params[:id])
    image = pet.images.find(params[:image_id])
    image.destroy
    redirect_to pet_pictures_path(pet), notice: 'Image deleted'
  end

  def delete
    pet = Pet.find(params[:id])
    pet.destroy
    redirect_to pet_profiles_path, notice: 'Pet deleted successfully'
  end

  def current_pet_profile
    redirect_to new_pet_path unless current_pet

    @pet = current_pet
    render :show
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :gender, :dob, :breed, :weight, :health_conditions)
  end
end