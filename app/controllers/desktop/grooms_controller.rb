module Desktop
  class GroomsController < DesktopController
    def index
      @date = params[:date] ? Date.new(params[:date].split("-").first.to_i, params[:date].split("-").second.to_i, params[:date].split("-").last.to_i) : Date.today

      @grooms = current_organisation.grooms.pending_or_confirmed.on_date(@date).order(:date, :time) + current_organisation.temporary_grooms.pending_or_confirmed.on_date(@date).order(:date, :time)
      @in_progress_grooms = current_organisation.grooms.order(:date, :time).in_progress.on_date(@date) + current_organisation.temporary_grooms.order(:date, :time).in_progress.on_date(@date)
      @completed_grooms = current_organisation.grooms.order(:date, :time).missed_appointment_or_completed.on_date(@date) + current_organisation.temporary_grooms.order(:date, :time).missed_appointment_or_completed.on_date(@date)

      @unscoped_grooms = current_organisation.grooms.on_date(@date).order(:date, :time) + current_organisation.temporary_grooms.on_date(@date).order(:date, :time)
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
        redirect_to desktop_groom_images_path(groom), notice: 'Groom needs to always have at least 1 photo'
      end
    end

    def update
      groom = current_organisation.grooms.find(params[:id])
      groom.assign_attributes(groom_params)

      if groom.save
        redirect_to desktop_grooms_path(date: groom.date), notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: desktop_grooms_path, alert: 'Invalid groom information'
      end
    end

    private

    def groom_params
      params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom, :employee_id, :status)
    end
  end
end