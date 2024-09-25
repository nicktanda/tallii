module Desktop
  class GroomsController < DesktopController
    def index
      @grooms = (current_organisation.grooms.pending_or_confirmed.order(:date, :time) + current_organisation.temporary_grooms.pending_or_confirmed.order(:date, :time)).group_by(&:date)
      @in_progress_grooms = current_organisation.grooms.order(:date, :time).in_progress + current_organisation.temporary_grooms.order(:date, :time).in_progress
      @completed_grooms = current_organisation.grooms.order(:date, :time).missed_appointment_or_completed + current_organisation.temporary_grooms.order(:date, :time).missed_appointment_or_completed
    end

    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end

    def show
      @groom = current_organisation.grooms.find(params[:id])
    end

    def images
      @groom = current_organisation.grooms.find(params[:id])
      @images = @groom.images
    end

    def upload_image
      groom = current_organisation.grooms.find(params[:id])
      groom.images.create!(name: "test_image", image: params[:image])
      redirect_to desktop_groom_images_path(groom), notice: 'Image uploaded'
    end

    def destroy_image
      groom = current_organisation.grooms.find(params[:id])

      image = groom.images.find(params[:image_id])
      if groom.images.count > 1
        image.destroy
        redirect_to desktop_groom_images_path(groom), notice: 'Image deleted'
      else
        redirect_to desktop_groom_images_path(groom), notice: 'Category needs to always have at least 1 photo'
      end
    end

    def update
      groom = current_organisation.grooms.find(params[:id])
      groom.assign_attributes(groom_params)

      if groom.save
        redirect_to desktop_grooms_path, notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: desktop_groom_path(groom), alert: 'Invalid groom information'
      end
    end

    private

    def groom_params
      params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom, :employee_id, :status)
    end
  end
end