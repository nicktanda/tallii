module Desktop
  class PetsController < DesktopController
    def new
      @user = current_organisation.users.find(params[:id])
    end

    def create
      user = current_organisation.users.find(params[:pet][:user_id])
      pet = current_user.pets.new
    
      pet.assign_attributes(pet_params)

      if pet.save
        pet.images.create!(name: "test_image", image: params[:pet][:image]) if params[:pet][:image]
        redirect_to desktop_user_path(user), notice: 'Pet updated successfully'
      else
        redirect_back fallback_location: new_pet_path, alert: 'Invalid pet information'
      end
    end

    private

    def pet_params
      params.require(:pet).permit(:name, :species, :gender, :dob, :breed, :weight, :health_conditions)
    end
  end
end