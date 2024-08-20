module Desktop
  class GroomsController < DesktopController
    def index
      @grooms = current_organisation.grooms.pending_or_confirmed.order(:date, :time).group_by(&:date)
      @in_progress_grooms = current_organisation.grooms.order(:date, :time).in_progress
      @completed_grooms = current_organisation.grooms.order(:date, :time).completed
    end

    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end

    def show
      @groom = current_organisation.grooms.find(params[:id])
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

    def update_settings
      current_organisation.assign_attributes(groom_settings_params)

      if current_organisation.save
        redirect_to desktop_grooms_path, notice: 'Groom settings updated successfully'
      else
        redirect_to desktop_grooms_path, notice: 'Invalid settings'
      end
    end

    private

    def groom_params
      params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom, :employee_id, :status)
    end

    def groom_settings_params
      params.permit(:maximum_weekly_grooms, :maximum_daily_grooms)
    end
  end
end