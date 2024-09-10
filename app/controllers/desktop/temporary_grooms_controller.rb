module Desktop
  class TemporaryGroomsController < DesktopController
    def new
      @pets = current_organisation.users.map(&:pets).flatten
    end

    def show
      @temporary_groom = current_organisation.temporary_grooms.find(params[:id])
    end

    def create
      temporary_groom = current_organisation.temporary_grooms.new(temporary_groom_params)
  
      if current_organisation.grooms_today_count == current_organisation.maximum_daily_grooms
        redirect_back fallback_location: desktop_temporary_grooms_new_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
        return
      end
  
      if current_organisation.grooms_this_week_count == current_organisation.maximum_weekly_grooms
        redirect_back fallback_location: desktop_temporary_grooms_new_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
        return
      end
  
      if temporary_groom.save
        redirect_to desktop_grooms_path, notice: 'Groom created successfully'
      else
        redirect_back fallback_location: desktop_temporary_grooms_new_path, alert: 'Invalid groom information'
      end
    end

    def update
      temporary_groom = current_organisation.temporary_grooms.find(params[:id])
      temporary_groom.assign_attributes(temporary_groom_params)

      if temporary_groom.save
        redirect_to desktop_grooms_path, notice: 'Groom updated successfully'
      else
        redirect_back fallback_location: desktop_temporary_groom_path(temporary_groom), alert: 'Invalid groom information'
      end
    end

    private

    def temporary_groom_params
      params.require(:temporary_groom).permit(:owner_name, :pet_name, :date, :time, :owner_notes, :pet_notes, :last_groom, :employee_id, :status)
    end
  end
end