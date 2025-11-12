module EmployeeApp
  class GroomsController < MobileAppController
    def index
      @grooms = current_user.grooms.pending_or_confirmed.today.order(:start_time) + current_user.temporary_grooms.pending_or_confirmed.today.order(:start_time)
      @in_progress_grooms = current_user.grooms.in_progress.today.order(:start_time) + current_user.temporary_grooms.in_progress.today.order(:start_time)
      @completed_grooms = current_user.grooms.missed_appointment_or_completed.today.order(:start_time) + current_user.temporary_grooms.missed_appointment_or_completed.today.order(:start_time)
    end

    def show
      @groom = current_user.grooms.find(params[:id])
    end

    def update
      groom = current_user.grooms.find(params[:id])
      groom.assign_attributes(groom_params)
  
      if groom.save
        redirect_to employee_app_grooms_path, notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: employee_app_groom_path(groom), alert: 'Invalid groom information'
      end
    end

    def images
      @groom = current_organisation.grooms.find(params[:id])
      @images = @groom.images
    end

    def upload_image
      groom = current_organisation.grooms.find(params[:id])
      groom.images.create!(name: "test_image", image: params[:image])
      redirect_to employee_app_groom_images_path(groom), notice: 'Image uploaded'
    end

    def destroy_image
      groom = current_organisation.grooms.find(params[:id])

      image = groom.images.find(params[:image_id])
      if groom.images.count > 1
        image.destroy
        redirect_to employee_app_groom_images_path(groom), notice: 'Image deleted'
      else
        redirect_to employee_app_groom_images_path(groom), notice: 'Groom needs to always have at least 1 photo'
      end
    end

    private

    def groom_params
      params.require(:groom).permit(:date, :start_time, :notes, :pet_id, :last_groom, :status)
    end
  end
end