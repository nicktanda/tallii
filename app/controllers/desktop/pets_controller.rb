module Desktop
  class PetsController < DesktopController
    def show
      @pet = current_organisation.pets.joins(:user).find(params[:id])
    end

    def pictures
      @pet = current_organisation.pets.find(params[:id])
      @images = @pet.images
    end

    def upload_new_image
      pet = current_organisation.pets.find(params[:id])
      pet.images.create!(name: "test_image", image: params[:image])
      redirect_to desktop_pets_pictures_path(pet), notice: 'Image uploaded'
    end

    def delete_pet_picture
      pet = current_organisation.pets.find(params[:id])
      image = pet.images.find(params[:image_id])
      if pet.images.count > 1
        image.destroy
        redirect_to desktop_pets_pictures_path(pet), notice: 'Image deleted'
      else
        redirect_to desktop_pets_pictures_path(pet), notice: 'Pet needs to always have at least 1 photo'
      end
    end

    def new
      @user = current_organisation.users.find(params[:id])
    end

    def create
      user = current_organisation.users.find(params[:pet][:user_id])
      pet = user.pets.new
      pet.organisation_id = current_organisation.id
    
      pet.assign_attributes(pet_params)

      if pet.save
        pet.images.create!(name: "test_image", image: params[:pet][:image]) if params[:pet][:image]
        redirect_to desktop_user_edit_path(user), notice: 'Pet updated successfully'
      else
        redirect_back fallback_location: desktop_user_edit_path(user), alert: 'Invalid pet information'
      end
    end

    def update
      pet = current_organisation.pets.find(params[:id])
      pet.assign_attributes(pet_params)

      if pet.save
        pet.update!(colour_codes: params[:pet][:colour_codes] || [])
        return redirect_to desktop_user_path(pet.user), notice: "Pet updated successfully" unless pet.alive?
        redirect_to desktop_pets_path(pet), notice: 'Pet updated successfully'
      else
        redirect_back fallback_location: desktop_pets_path(pet), alert: 'Invalid pet information'
      end
    end

    def delete
      pet = current_organisation.pets.find(params[:id])
      user = pet.user
      pet.destroy

      redirect_to desktop_user_path(user)
    end

    def download_rabies_evidence
      pet = Pet.find(params[:id])
  
      if pet.rabies_evidence.attached?
        redirect_to rails_blob_url(pet.rabies_evidence, disposition: "attachment")
      else
        redirect_back fallback_location: desktop_pets_path(pet), alert: "File not found."
      end
    end
    
    def download_bordetella_evidence
      pet = Pet.find(params[:id])
  
      if pet.bordetella_evidence.attached?
        redirect_to rails_blob_url(pet.bordetella_evidence, disposition: "attachment")
      else
        redirect_back fallback_location: desktop_pets_path(pet), alert: "File not found."
      end
    end
    
    def download_dhpp_evidence
      pet = Pet.find(params[:id])
  
      if pet.dhpp_evidence.attached?
        redirect_to rails_blob_url(pet.dhpp_evidence, disposition: "attachment")
      else
        redirect_back fallback_location: desktop_pets_path(pet), alert: "File not found."
      end
    end
    
    def download_heartworm_evidence
      pet = Pet.find(params[:id])
  
      if pet.heartworm_evidence.attached?
        redirect_to rails_blob_url(pet.heartworm_evidence, disposition: "attachment")
      else
        redirect_back fallback_location: desktop_pets_path(pet), alert: "File not found."
      end
    end
    
    def download_kennel_cough_evidence
      pet = Pet.find(params[:id])
  
      if pet.kennel_cough_evidence.attached?
        redirect_to rails_blob_url(pet.kennel_cough_evidence, disposition: "attachment")
      else
        redirect_back fallback_location: desktop_pets_path(pet), alert: "File not found."
      end
    end

    private

    def pet_params
      params
        .require(:pet)
        .except(:user_name)
        .permit(
          :name,
          :species,
          :gender,
          :dob,
          :breed,
          :weight,
          :health_conditions,
          :notes,
          :date_of_death,
          :status,
          :allergies,
          :medication,
          :rabies_expiration,
          :rabies_evidence,
          :bordetella_expiration,
          :bordetella_evidence,
          :dhpp_expiration,
          :dhpp_evidence,
          :heartworm_expiration,
          :heartworm_evidence,
          :kennel_cough_evidence
        )
    end
  end
end