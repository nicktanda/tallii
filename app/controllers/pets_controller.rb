class PetsController < ApplicationController
  def show
    @pet = current_user.pets.find(params[:id])
  end

  def pictures
    @pet = current_user.pets.find(params[:id])
    @images = @pet.images
  end

  def update
    pet = current_user.pets.find(params[:id])
    pet.assign_attributes(pet_params)

    if pet.save
      pet.images.create!(name: "test_image", image: params[:pet][:image]) if params[:pet][:image]
      redirect_to pet_profiles_path, notice: 'Pet updated successfully'
    else
      redirect_back fallback_location: new_pet_onboarding_path, alert: 'Invalid pet information'
    end
  end

  def upload_new_image
    pet = current_user.pets.find(params[:id])
    pet.images.create!(name: "test_image", image: params[:image])
    redirect_to pet_pictures_path(pet), notice: 'Image uploaded'
  end

  def delete_image
    pet = current_user.pets.find(params[:id])
    image = pet.images.find(params[:image_id])
    if pet.images.count > 1
      image.destroy
      redirect_to pet_pictures_path(pet), notice: 'Image deleted'
    else
      redirect_to pet_pictures_path(pet), notice: 'Pet needs to always have at least 1 photo'
    end
  end

  def delete
    pet = current_user.pets.find(params[:id])
    pet.destroy
    redirect_to pet_profiles_path, notice: 'Pet deleted successfully'
  end

  def current_pet_profile
    redirect_to new_pet_onboarding_path unless current_pet

    @pet = current_pet
    render :show
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :gender, :dob, :breed, :weight, :health_conditions)
  end
end