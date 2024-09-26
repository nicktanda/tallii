module EmployeeApp
  class TemporaryGroomsController < MobileAppController
    def show
      @temporary_groom = current_user.temporary_grooms.find(params[:id])
    end

    def update
      temporary_groom = current_user.temporary_grooms.find(params[:id])
      temporary_groom.assign_attributes(temporary_groom_params)

      if temporary_groom.save
        redirect_to employee_app_grooms_path, notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: employee_app_temporary_groom_path(temporary_groom), alert: 'Invalid groom information'
      end
    end

    def images
      @temporary_groom = current_organisation.temporary_grooms.find(params[:id])
      @images = @temporary_groom.images
    end

    def upload_image
      temporary_groom = current_organisation.temporary_grooms.find(params[:id])
      temporary_groom.images.create!(name: "test_image", image: params[:image])
      redirect_to employee_app_temporary_groom_images_path(temporary_groom), notice: 'Image uploaded'
    end

    def destroy_image
      temporary_groom = current_organisation.temporary_grooms.find(params[:id])

      image = temporary_groom.images.find(params[:image_id])
      if temporary_groom.images.count > 1
        image.destroy
        redirect_to employee_app_temporary_groom_images_path(temporary_groom), notice: 'Image deleted'
      else
        redirect_to employee_app_temporary_groom_images_path(temporary_groom), notice: 'Groom needs to always have at least 1 photo'
      end
    end

    private

    def temporary_groom_params
      params.require(:temporary_groom).permit(:owner_name, :pet_name, :date, :time, :owner_notes, :pet_notes, :last_groom, :status)
    end
  end
end